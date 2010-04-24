use Test::More;
use strict;

use Util::All '-basecalc';

ok(defined &to_base);
ok(defined &from_base);
ok(defined &dec2hex);
ok(defined &hex2dec);
ok(defined &dec2bin);
ok(defined &dec2oct);
ok(defined &oct2dec);
is_deeply(
  [do {package test_basecalc1; use Util::All -basecalc => [-args => {digits => [0,1]}]; (to_base(4), from_base(100));}],
  [do {100, 4}],
);
is_deeply(
  [do {package test_basecalc2; use Util::All -basecalc => [to_base => {digits => [0,1], -as => 'to_base2'}]; to_base2(4);}],
  [do {100}],
);
is_deeply(
  [do {package test_basecalc3; use Util::All -basecalc => [from_base => {digits => [0,1], -as => 'from_base2'}]; from_base2(100);}],
  [do {4}],
);
done_testing;