use Test::More;
use strict;

use Util::All '-hash';

ok(defined &hash_seed);
ok(defined &lock_hash);
ok(defined &lock_keys);
ok(defined &lock_value);
ok(defined &unlock_hash);
ok(defined &unlock_keys);
ok(defined &unlock_value);
ok(defined &indexed);
is_deeply(
  [do {indexed my %hash; %hash = qw/5 1 4 2 3 3 2 4 1 5 0 6/;  keys %hash}],
  [do {qw/5 4 3 2 1 0/}],
);
done_testing;