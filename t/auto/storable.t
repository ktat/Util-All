use Test::More;
use strict;

use Util::All '-storable';

ok(defined &freeze);
ok(defined &thaw);
is_deeply(
  [do {thaw(freeze({a => 1}))->{a}}],
  [do {1}],
);
is_deeply(
  [do {thaw(freeze({a => 123}))->{a}}],
  [do {123}],
);
is_deeply(
  [do {use Util::All -base64; thaw(base64_decode('BAcIMTIzNDU2NzgECAgIAwEAAAAI5AEAAABi'))->{b};}],
  [do {100}],
);
done_testing;