use Test::More;
use strict;

use Util::All '-utime';

ok(defined &usleep);
ok(defined &nanosleep);
ok(defined &ualarm);
done_testing;