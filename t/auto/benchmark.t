use Test::More;
use strict;

use Util::All '-benchmark';

ok(defined &timeit);
ok(defined &timethis);
ok(defined &timethese);
ok(defined &timediff);
ok(defined &timestr);
ok(defined &timesum);
ok(defined &cmpthese);
ok(defined &countit);
ok(defined &timesamearg);
ok(defined &cmpsamearg);
done_testing;