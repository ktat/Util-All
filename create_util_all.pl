#!/usr/bin/perl

use strict;
use YAML::Syck "LoadFile";
use File::Slurp 'slurp';
use Tie::IxHash;
use Data::Dumper;
use Perl::Tidy qw/perltidy/;
use List::MoreUtils ();

local $Data::Dumper::Deparse = 1;
local $Data::Dumper::Terse   = 1;
local $Data::Dumper::Indent  = 1;
local $Data::Dumper::Varname = 'Utils';

my %CONF;
@CONF{@ARGV} = ();

my $USE_PERLTIDY = !(exists $CONF{'-notidy'}) || 0;
my $NOTEST       = exists $CONF{'-notest'} || 0;

write_file(def_usage_from_file("functions.yml"));
system("prove -Ilib t/ t/auto/;") unless $NOTEST;

sub def_usage_from_file {
  tie my %new, 'Tie::IxHash';
  my %usage_test;
  tie %{$usage_test{usage} ||= {}}, 'Tie::IxHash';
  tie %{$usage_test{test} ||= {}}, 'Tie::IxHash';

  my $def = LoadFile(shift);
  my @modules;
  my @requires;
  my @as_plugins; # not yet
  my $default_priority = 1000;

  foreach my $k (sort keys %$def) {
    my %tmp;
    push @requires, @{delete $def->{$k}->{'-require'} || []};
    push @as_plugins, delete $def->{$k}->{'-as_plugin'} || (); # do nothing
    $usage_test{usage}->{$k}->{'-all'} = delete $def->{$k}->{'-usage'} if exists $def->{$k}->{'-usage'};
    $usage_test{test}->{$k}->{'-all'}  = delete $def->{$k}->{'-test'}  if exists $def->{$k}->{'-test'};

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
            my @usage_or_test;
            ($def->{$k}->{$m}->{$f}, @usage_or_test) = (@{$def->{$k}->{$m}->{$f}});
            if (@usage_or_test) {
              foreach my $usage_or_test (@usage_or_test) {
                if (ref $usage_or_test eq 'HASH') {
                  foreach my $ut ("usage", "test") {
                    if (exists $usage_or_test->{$ut}) {
                      $usage_test{$ut}{$k}{$f} = $usage_or_test->{$ut};
                    }
                  }
                } else {
                  push @{$usage_test{usage}{$k}{$f} ||= []}, $usage_or_test;
                }
              }
            }
          }
          if ($def->{$k}->{$m}->{$f} =~m{^sub }) {
            # print Data::Dumper::Dumper(eval"$def->{$k}->{$m}->{$f}");
            if(exists $usage_test{usage}{$k}->{'-all'}) {
              push @{$usage_test{usage}{$k}->{-renames} ||= []}, $f;
            } elsif (exists $usage_test{usage}{$k}->{$f}) {
              $usage_test{usage}{$k}->{-rename}->{$f} = 1;
            } else {
              my $dest = '';
              $usage_test{usage}{$k}->{-rename}->{$f} = 1;
              if ($USE_PERLTIDY) {
                perltidy(source => \$def->{$k}->{$m}->{$f}, destination => \$dest);
                $usage_test{usage}{$k}{$f} ||= [$dest];
              } else {
                $usage_test{usage}{$k}{$f} = [$def->{$k}->{$m}->{$f}];
              }
            }
            no strict; # for not including "use strict" when Dumper.
            my $sub = eval "$def->{$k}->{$m}->{$f}";
            die $@. $def->{$k}->{$m}->{$f} if $@;
            $def->{$k}->{$m}->{$f} = $sub;
          } elsif ($f eq $def->{$k}->{$m}->{$f}) {
            push @funcs, delete $def->{$k}->{$m}->{$f};
          } else {
            delete $usage_test{usage}{$k}{$f};
            $usage_test{usage}{$k}{$def->{$k}->{$m}->{$f}} = ["", "$f of L<$m>"];
          }
        }
        my (@selected, $pre_func);
        foreach my $func (@{$def->{$k}->{$m}->{-select} ||= []}, @funcs) {
            if (ref $func eq 'HASH') {
              if ($func->{usage}) {
                $usage_test{usage}{$k}->{$pre_func} = $func->{usage};
              }
              if ($func->{test}) {
                $usage_test{test}{$k}->{$pre_func} = $func->{test};
              }
            } else {
              if (ref $func eq 'ARRAY') {
                my $usage = $func;
                $func = shift @$usage;
                $usage_test{usage}{$k}->{$func} = $usage;
              } else {
                push @{$usage_test{usage}{$k}->{'-rest'}->{$m} ||= []}, $func;
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
        $usage_test{usage}{$k}->{-rest}->{$m} = $def->{$k}->{$m};
        push @{$new{'-' . $k} ||= []}, [
                                        $m, '',
                                        {
                                         -select => $def->{$k}->{$m}},
                                       ];
      }
    }
  }
  return \%new, $usage_test{usage}, \@modules, \@requires, $usage_test{test};
}

sub write_file {
  my ($new, $usage_data, $modules, $requires, $test) = @_;
  my $def_string = Dumper($new);
  my $success = 0;

  my $template = slurp("util-all.template") or die $!;

  my $usage = usage($usage_data, $test);
  generate_test($usage_data, $test);

  $template =~s{###DEFINITION###}{$def_string};
  $template =~s{###USAGE###}{$usage};
  $template =~s{\$Utils1}{\$Utils}g;

  {
    open my $out, '>', 'lib/Util/All.pm' or die $!;
    print $out $template;
    close $out;
    print "Writing lib/Util/All.pm\n";
    print "try perl -Ilib -MUtil::All=-all -e ''\n";
    unless(system("perl -Ilib -MUtil::All=-all -e '';")) {
      print "OK\n";
      $success = 1;
    } else {
      print "NG\n";
      die "maybe Util::All has syntax error.";
    }
  }

  my $makefile = do {local $/; <DATA>};
  my $dependent_modules = join ",\n", map {"\t'$_' => 0"} sort(List::MoreUtils::uniq(@$modules, @$requires));
  $makefile =~s{###DEPENDENT_MODULES###}{$dependent_modules};
  {
    open my $out, '>', 'Makefile.PL' or die $!;
    print $out $makefile;
    close $out;
    print "Writing Makefile.PL\n";
  }
  return $success;
}

sub usage {
  my ($usage, $test) = @_;
  my $c;
  foreach my $kind (keys %$usage) {
    $c .= '=head2 -' . $kind . "\n\n";
    if (exists $usage->{$kind}->{'-all'}) {
      $c .= $usage->{$kind}->{'-all'} . "\n\n";
      if ($usage->{$kind}->{-renames}) {
        $c .= "=head3 function enable to rename *\n\n";
        $c .= join ", ", @{$usage->{$kind}->{-renames}};
        $c .= "\n\n";
      }
    } else {
      my %tmp;
      foreach my $f (keys %{$usage->{$kind}}) {
        next if $f eq '-rename' or $f eq '-renames';
        if ($f eq '-rest') {
          foreach my $m (keys %{$usage->{$kind}->{'-rest'}}) {
            $c .= "=head3 functions of L<$m>\n\n";
            foreach my $func (@{$usage->{$kind}->{'-rest'}->{$m}}) {
              $c .= "=head4 $func\n\n";
            }
          }
        } else {
          $c .= "=head3 $f" . ($usage->{$kind}->{'-rename'}->{$f} ? ' *' : '') . "\n\n";
          if ($usage->{$kind}->{$f}->[0]) {
            $tmp{$f} = 1;
            if (ref $usage->{$kind}->{$f}->[0] eq 'ARRAY') {
              $usage->{$kind}->{$f}->[0] = join "\n", @{$usage->{$kind}->{$f}->[0]};
            }
            $usage->{$kind}->{$f}->[0] =~s{^}{  }mg;
            $c .= $usage->{$kind}->{$f}->[0] . "\n\n";;
          }
          if ($usage->{$kind}->{$f}->[1]) {
            $tmp{$f} = 1;
            $c .= $usage->{$kind}->{$f}->[1] . "\n\n";;
          }
        }
      }
    }
    foreach my $f (keys %{$test->{$kind}}) {
      # next if exists $tmp{$f};

      my $t = $test->{$kind}{$f};
      $c .= "=head3 test code\n\n";
      foreach my $test (@$t) {
        my ($_test, $_r) = @$test == 3 ? @{$test}[1,2] : @{$test}[0,1];
        $_test =~s{;}{;\n}g;
        $_test =~s{^\s*}{ }mg;
        $c .= $_test;
        chomp($c);
        $c .= "\n # equal to: " . $_r . "\n\n";
      }
    }
  }
  return $c;
}

sub generate_test {
  my ($usage, $test) = @_;
  my $i = 0;
  unless (-d "t/auto") {
    mkdir 't/auto';
  } else {
    unlink <t/auto/*>;
  }
  foreach my $kind (sort keys %$test) {
    my $kind_tag = defined &{$kind} ? "-$kind" : "'-$kind'";
    open my $fh, ">", sprintf "t/auto/%02d-%s.t", $i, $kind;
    print $fh <<__EOL;
use Test::More;
use strict;

use Util::All $kind_tag;

__EOL
    my @funcs;
    if (exists $usage->{$kind}->{-renames}) {
      push @funcs, @{$usage->{$kind}->{-renames}};
    }
    if (exists $usage->{$kind}->{-rest}) {
      push @funcs, @{$usage->{$kind}->{-rest}->{$_} || []} for keys %{$usage->{$kind}->{-rest}};
    }
    push @funcs, grep !/^-/, keys %{$usage->{$kind}};
    @funcs = List::MoreUtils::uniq(@funcs);
    foreach my $func (@funcs) {
      print $fh "ok(defined \&$func);\n";
    }
    foreach my $func (sort keys %{$test->{$kind}}) {
      my $defs = $test->{$kind}->{$func};
      next if !$defs or !@$defs;
      foreach my $def (@$defs) {
        if (ref $def) {
          if (@$def == 3) {
            print $fh <<EOL
${$def}[0](
  [do {${$def}[1]}],
  [do {${$def}[2]}],
);
EOL
          } elsif(@$def == 2) {
            print $fh <<EOL
is_deeply(
  [do {${$def}[0]}],
  [do {${$def}[1]}],
);
EOL
          }
        } else {
          print $fh "ok(do {${$def}[0]})\n";
        }
      }
    }
    print $fh "done_testing;";
    close $fh;
    $i++
  }
}

__END__
use strict;
use warnings;

use inc::Module::Install;

# Define metadata
name           'Util-All';
all_from       'lib/Util/All.pm';

# Specific dependencies
requires       'Util::Any'  => '0.18',
# requires       'Task::Email::PEP::NoStore' => 0,
#               'Errno::AnyString' => 0,
###DEPENDENT_MODULES###
;
test_requires  'Test::More'  => '0.88';
no_index       'directory'   => 'demos';
# install_script 'myscript';

tests_recursive;
# auto_install;
WriteAll;
