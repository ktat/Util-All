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
done_testing;