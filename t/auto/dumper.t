use Test::More;
use strict;

use Util::All '-dumper';

ok(defined &dump);
ok(defined &pp);
ok(defined &dd);
ok(defined &ddx);
ok(defined &deep_dump);
ok(defined &p);
done_testing;