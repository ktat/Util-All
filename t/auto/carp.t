use Test::More;
use strict;

use Util::All '-carp';

ok(defined &croak);
ok(defined &cluck);
ok(defined &carp);
ok(defined &confess);
done_testing;