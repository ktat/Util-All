use Test::More;
use strict;

use Util::All '-string';

ok(defined &camelize);
ok(defined &decamelize);
ok(defined &wordsplit);
ok(defined &crunch);
ok(defined &define);
ok(defined &equndef);
ok(defined &fullchomp);
ok(defined &hascontent);
ok(defined &htmlesc);
ok(defined &neundef);
ok(defined &nospace);
ok(defined &randcrypt);
ok(defined &randword);
ok(defined &trim);
ok(defined &unquote);
ok(defined &to_fh);
ok(defined &strings);
is_deeply(
  [do {package test_strings1; use Util::All -string; strings('111' . "\0" . '111');}],
  [do {"111111"}],
);
is_deeply(
  [do {use Util::All -string; my $s = "1\n2\n3\n4\n5\n"; my $fh = to_fh($s); my $sum = 0; while (<$fh>){ chomp; $sum += $_ ; $sum++}; $sum;}],
  [do {20}],
);
is_deeply(
  [do {use Util::All -string; my $s = "1\n2\n3\n4\n5\n"; my $fh = to_fh(\$s); my $sum = 0; while (<$fh>){ chomp; $sum += $_ ; $sum++}; $sum;}],
  [do {20}],
);
is_deeply(
  [do {use Util::All -string; my $fh = to_fh(url => "http://rwds.net/"); my $c = ''; while (<$fh>){m{<h1>(.+)</h1>} and do {$c = $1; last} }; $c;}],
  [do {"rwds.net"}],
);
done_testing;