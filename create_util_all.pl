#!/usr/bin/perl

use strict;
use YAML::Syck "Load";
use File::Slurp 'slurp';
use Tie::IxHash;
use Data::Dumper;

$Data::Dumper::Deparse = 1;
$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 1;

my %new;
tie %new, 'Tie::IxHash';
my $yaml = slurp("functions.yml");
my $def = Load($yaml);
my @modules;

my $default_priority = 1000;

foreach my $k (sort keys %$def) {
  my %tmp;
  foreach my $m (sort {($tmp{$a} ||= (ref $def->{$k}{$a} ne 'HASH' ? $default_priority : delete $def->{$k}{$a}{-priority} || $default_priority)) <=>
                       ($tmp{$b} ||= (ref $def->{$k}{$a} ne 'HASH' ? $default_priority : delete $def->{$k}{$b}{-priority} || $default_priority))
                     } keys %{$def->{$k}}) {
    push @modules, $m;
    if ($def->{$k}->{$m} eq '*') {
      push @{$new{'-' . $k} ||= []}, [$m];
    } elsif (ref $def->{$k}{$m} eq 'HASH') {
      foreach my $f (keys  %{$def->{$k}->{$m}}) {
        if ($def->{$k}->{$m}->{$f} =~m{^sub }) {
          no strict; # for not including "use strict" when Dumper.
          my $sub = eval "$def->{$k}->{$m}->{$f}";
          die $@. $def->{$k}->{$m}->{$f} if $@;
          $def->{$k}->{$m}->{$f} = $sub;
        }
      }
      push @{$new{'-' . $k} ||= []}, [
                                      $m, '',
                                      $def->{$k}->{$m},
                                     ];
    } else {
      push @{$new{'-' . $k} ||= []}, [
                                      $m, '',
                                      {
                                       -select => $def->{$k}->{$m}},
                                     ];

    }
  }
}

my $def_string = Dumper(\%new);
my $template = slurp("util-all.template") or die $!;

$template =~s{###DEFINITION###}{$def_string};
$yaml =~s{^}{   }gm;
$template =~s{###YAML_DEFINITION###}{$yaml};

open my $out, '>', 'lib/Util/All.pm' or die $!;
print $out $template;
close $out;
print "Writing lib/Util/All.pm\n";

my $makefile = do {local $/; <DATA>};
my $dependent_modules = join ",\n", map {"\t'$_' => 0"} sort @modules;
$makefile =~s{###DEPENDENT_MODULES###}{$dependent_modules};

open my $out, '>', 'Makefile.PL' or die $!;
print $out $makefile;
close $out;
print "Writing Makefile.PL\n";

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
        'Util::Any'  => 0.13,
        'Date::Manip' => 0,
        'LWP::UserAgent' => 0,
###DEPENDENT_MODULES###
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Util-All-*' },
);
