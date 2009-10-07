#!/usr/bin/perl

use strict;
use YAML::Syck "LoadFile";
use File::Slurp 'slurp';
use Tie::IxHash;
use Data::Dumper;
use Perl::Tidy qw/perltidy/;

local $Data::Dumper::Deparse = 1;
local $Data::Dumper::Terse   = 1;
local $Data::Dumper::Indent  = 1;

write_file(def_usage_from_file("functions.yml"));

sub def_usage_from_file {
  tie my %new, 'Tie::IxHash';
  tie my %usage, 'Tie::IxHash';

  my $def = LoadFile(shift);
  my @modules;
  my @requires;
  my @as_plugins; # not yet
  my $default_priority = 1000;

  foreach my $k (sort keys %$def) {
    my %tmp;
    push @requires, @{delete $def->{$k}->{'-require'} || []};
    push @as_plugins, delete $def->{$k}->{'-as_plugin'} || (); # do nothing
    $usage{$k}->{'-all'} = delete $def->{$k}->{'-usage'} if exists $def->{$k}->{'-usage'};

    foreach my $m (sort {($tmp{$a} ||= (ref $def->{$k}{$a} ne 'HASH' ? $default_priority : delete $def->{$k}{$a}{-priority} || $default_priority)) <=>
                         ($tmp{$b} ||= (ref $def->{$k}{$b} ne 'HASH' ? $default_priority : delete $def->{$k}{$b}{-priority} || $default_priority))
                       } keys %{$def->{$k}}) {
      push @modules, $m;
      if ($def->{$k}->{$m} eq '*') {
        push @{$new{'-' . $k} ||= []}, [$m];
      } elsif (ref $def->{$k}{$m} eq 'HASH') {
        my @funcs;
        foreach my $f (keys  %{$def->{$k}->{$m}}) {
          next if $f eq '-select';
          if (ref $def->{$k}->{$m}->{$f} eq 'ARRAY') {
            ($def->{$k}->{$m}->{$f}, @{$usage{$k}{$f} ||= []}) = (@{$def->{$k}->{$m}->{$f}});
          }
          if ($def->{$k}->{$m}->{$f} =~m{^sub }) {
            # print Data::Dumper::Dumper(eval"$def->{$k}->{$m}->{$f}");
            if(exists $usage{$k}->{'-all'}) {
              push @{$usage{$k}->{-renames} ||= []}, $f;
            } elsif (exists $usage{$k}->{$f}) {
              $usage{$k}->{-rename}->{$f} = 1;
            } else {
              my $dest = '';
              $usage{$k}->{-rename}->{$f} = 1;
              perltidy(source => \$def->{$k}->{$m}->{$f}, destination => \$dest);
              $usage{$k}{$f} ||= [$dest];
              # $usage{$k}{$f} = [$def->{$k}->{$m}->{$f}];
            }
            no strict; # for not including "use strict" when Dumper.
            my $sub = eval "$def->{$k}->{$m}->{$f}";
            die $@. $def->{$k}->{$m}->{$f} if $@;
            $def->{$k}->{$m}->{$f} = $sub;
          } elsif ($f eq $def->{$k}->{$m}->{$f}) {
            push @funcs, delete $def->{$k}->{$m}->{$f};
          } else {
            delete $usage{$k}{$f};
            $usage{$k}{$def->{$k}->{$m}->{$f}} = ["", "$f of $m"];
          }
        }
        my (@selected, $pre_func);
        foreach my $func (@{$def->{$k}->{$m}->{-select} ||= []}, @funcs) {
            if (ref $func eq 'HASH') {
              $usage{$k}->{$pre_func} = $func->{usage};
            } else {
              if (ref $func eq 'ARRAY') {
                my $usage = $func;
                $func = shift @$usage;
                $usage{$k}->{$func} = $usage;
              } else {
                push @{$usage{$k}->{'-rest'}->{$m} ||= []}, $func;
              }
              push @selected, $func;
              $pre_func = $func;
            }
        }
        $def->{$k}->{$m}->{-select} = \@selected;
        push @{$new{'-' . $k} ||= []}, [
                                        $m, '',
                                        $def->{$k}->{$m},
                                       ];
      } else {
        $usage{$k}->{-rest}->{$m} = $def->{$k}->{$m};
        push @{$new{'-' . $k} ||= []}, [
                                        $m, '',
                                        {
                                         -select => $def->{$k}->{$m}},
                                       ];
      }
    }
  }
  return \%new, \%usage, \@modules, \@requires;
}

sub write_file {
  my ($new, $usage, $modules, $requires) = @_;
  my $def_string = Dumper($new);
  my $template = slurp("util-all.template") or die $!;

  $usage = usage($usage);

  $template =~s{###DEFINITION###}{$def_string};
  # $yaml =~s{^}{   }gm;
  # $template =~s{###YAML_DEFINITION###}{$yaml};
  $template =~s{###USAGE###}{$usage};

  {
    open my $out, '>', 'lib/Util/All.pm' or die $!;
    print $out $template;
    close $out;
    print "Writing lib/Util/All.pm\n";
  }

  my $makefile = do {local $/; <DATA>};
  my $dependent_modules = join ",\n", map {"\t'$_' => 0"} sort @$modules, @$requires;
  $makefile =~s{###DEPENDENT_MODULES###}{$dependent_modules};
  {
    open my $out, '>', 'Makefile.PL' or die $!;
    print $out $makefile;
    close $out;
    print "Writing Makefile.PL\n";
  }
}

sub usage {
  my ($usage) = @_;
  my $c;
  foreach my $kind (keys %$usage) {
    $c .= '=head2 -' . $kind . "\n\n";
    if (exists $usage->{$kind}->{'-all'}) {
      $c .= $usage->{$kind}->{'-all'} . "\n\n";
      if ($usage->{$kind}->{-renames}) {
        $c .= "=head3 function enable to rename\n\n";
        $c .= join ", ", @{$usage->{$kind}->{-renames}};
        $c .= "\n\n";
      }
    } else {
      foreach my $f (keys %{$usage->{$kind}}) {
        next if $f eq '-rename' or $f eq '-renames';
        if ($f eq '-rest') {
          foreach my $m (keys %{$usage->{$kind}->{'-rest'}}) {
            $c .= "=head3 functions of $m\n\n";
            foreach my $func (@{$usage->{$kind}->{'-rest'}->{$m}}) {
              $c .= "=head4 $func\n\n";
            }
          }
        } else {
          $c .= "=head3 $f" . ($usage->{$kind}->{'-rename'}->{$f} ? ' *' : '') . "\n\n";
          if ($usage->{$kind}->{$f}->[0]) {
            $usage->{$kind}->{$f}->[0] =~s{^}{  };
            $c .= $usage->{$kind}->{$f}->[0] . "\n\n";;
          }
          if ($usage->{$kind}->{$f}->[1]) {
            $c .= $usage->{$kind}->{$f}->[1] . "\n\n";;
          }
        }
      }
    }
  }
  return $c;
}

__END__
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Util::All',
    AUTHOR              => 'Ktat <ktat@cpan.org>',
    VERSION_FROM        => 'lib/Util/All.pm',
    ABSTRACT_FROM       => 'lib/Util/All.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Util::Any'  => 0.14,
###DEPENDENT_MODULES###
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Util-All-*' },
);
