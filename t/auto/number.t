use Test::More;
use strict;

use Util::All '-number';

ok(defined &number_commify);
ok(defined &number_price);
ok(defined &number_unit);
ok(defined &number_round);
ok(defined &to_number);
ok(defined &number_format);
is_deeply(
  [do {number_commify(10000);}],
  [do {('10,000')}],
);
is_deeply(
  [do {number_price(10000);}],
  [do {Number::Format->new->format_price(10000);}],
);
is_deeply(
  [do {number_round(123, -2);}],
  [do {100}],
);
is_deeply(
  [do {number_round(123.25, 1);}],
  [do {123.3}],
);
is_deeply(
  [do {number_unit(1024, unit => 'K', mode => 'iec')}],
  [do {('1KiB')}],
);
is_deeply(
  [do {number_unit(1048576, unit => 'M', mode => 'trad')}],
  [do {('1M')}],
);
is_deeply(
  [do {to_number('1,000');}],
  [do {1000}],
);
is_deeply(
  [do {to_number('1,025');}],
  [do {1025}],
);
is_deeply(
  [do {to_number('1KiB');}],
  [do {1024}],
);
done_testing;