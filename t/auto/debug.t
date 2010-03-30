use Test::More;
use strict;

use Util::All '-debug';

ok(defined &watch);
ok(defined &dump);
ok(defined &pp);
ok(defined &dd);
ok(defined &ddx);
ok(defined &deep_dumper);
ok(defined &ex_dumper);
ok(defined &dumper);
ok(defined &deep_dump);
ok(defined &p);
is_deeply(
  [do {use Util::All -debug; my $d = ex_dumper({hoge => 1, fuga => 2, foo => {hoge => 3}}, ['hoge']); my $VAR1; eval "$d";}],
  [do {{fuga => 2, foo => {}}}],
);
done_testing;