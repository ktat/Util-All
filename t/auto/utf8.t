use Test::More;
use strict;

use Util::All '-utf8';

ok(defined &is_utf8);
ok(defined &utf8_encode);
ok(defined &utf8_off);
ok(defined &utf8_upgrade);
ok(defined &utf8_downgrade);
ok(defined &utf8_on);
is_deeply(
  [do {package test_utf8_1; use Util::All -utf8; my $data = { a => "あ", b => {c => "い"}}; my $d = utf8_on($data); is_utf8($d->{a}) && is_utf8($d->{b}{c});}],
  [do {1}],
);
is_deeply(
  [do {package test_utf8_2; use utf8; use Util::All -utf8; my $data = { a => "あ", b => {c => "い"}}; my $d = utf8_off($data); is_utf8($d->{a}) || is_utf8($d->{b}{c});}],
  [do {''}],
);
done_testing;