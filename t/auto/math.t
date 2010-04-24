use Test::More;
use strict;

use Util::All '-math';

ok(defined &lcm);
ok(defined &gcd);
ok(defined &gcf);
ok(defined &is_prime);
done_testing;