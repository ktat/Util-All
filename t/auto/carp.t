use Test::More;
use strict;

use Util::All '-carp';

ok(defined &croak);
ok(defined &cluck);
ok(defined &carp);
ok(defined &confess);
ok(defined &shortmess);
ok(defined &longmess);
done_testing;