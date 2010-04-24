#!/usr/bin/perl

use feature qw/say/;
use strict;
use FindBin;
require "$FindBin::Bin/lib/abstract_pod.pl";

main();

sub main {
  die "$0 MODULE FUNCTION1 FUNCTION2 ...\n" if @ARGV < 2;
  my @pod = abstract_pod(@ARGV);
  say join "\n", @pod;
  return 0;
}
