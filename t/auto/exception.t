use Test::More;
use strict;

use Util::All '-exception';

ok(defined &try);
ok(defined &catch);
done_testing;