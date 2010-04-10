use Test::More;
use strict;

use Util::All '-json';

ok(defined &encode_json);
ok(defined &decode_json);
ok(defined &to_json_file);
ok(defined &from_json_file);
ok(defined &from_json);
ok(defined &to_json);
is_deeply(
  [do {no utf8; from_json(q/{"hoge":"あ"}/);}],
  [do {use utf8; {hoge => "あ"}}],
);
is_deeply(
  [do {use utf8; from_json(q/{"hoge":"あ"}/);}],
  [do {use utf8; {hoge => "あ"}}],
);
is_deeply(
  [do {no utf8; to_json({hoge => 'あ'});}],
  [do {no utf8; qq{{"hoge":"あ"}}}],
);
is_deeply(
  [do {use utf8; to_json({hoge => 'あ'});}],
  [do {no utf8; qq{{"hoge":"あ"}}}],
);
is_deeply(
  [do {no utf8; to_json_file({hoge => "あいうえお"}, "t/data/test.out.json"); from_json_file("t/data/test.out.json");}],
  [do {use utf8; {hoge => "あいうえお"}}],
);
done_testing;