use Test::More;
use strict;

use Util::All '-encode';

ok(defined &encode);
ok(defined &decode);
ok(defined &from_to);
done_testing;