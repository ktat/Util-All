use Test::More;
use strict;

use Util::All '-json';

ok(defined &to_json_file);
ok(defined &from_json_file);
ok(defined &from_json);
ok(defined &to_json);
is_deeply(
  [do {package test_json; use Util::All -json, -debug; dump from_json(to_json({hoge => 1}));}],
  [do {'{ hoge => 1 }'}],
);
is_deeply(
  [do {package test_json; use Util::All -json; to_json(from_json_file("t/data/test.json"));}],
  [do {qq{{"hoge":1}}}],
);
done_testing;