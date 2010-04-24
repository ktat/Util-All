use Test::More;
use strict;

use Util::All '-yml';

ok(defined &to_yaml);
ok(defined &to_yaml_file);
ok(defined &decode_yaml);
ok(defined &encode_yaml);
ok(defined &from_yaml_file);
ok(defined &from_yaml);
is_deeply(
  [do {no utf8; from_yaml( qq{---\nhoge: あ\n} );}],
  [do {use utf8; { hoge => 'あ' };}],
);
is_deeply(
  [do {use utf8; from_yaml( qq{---\nhoge: あ\n} );}],
  [do {use utf8; { hoge => 'あ' };}],
);
is_deeply(
  [do {no utf8; decode_yaml( qq{---\nhoge: あ\n} );}],
  [do {use utf8; { hoge => 'あ' };}],
);
is_deeply(
  [do {no utf8; to_yaml({hoge => 'あ'})}],
  [do {no utf8; qq{---\nhoge: あ\n}}],
);
is_deeply(
  [do {use utf8; to_yaml({hoge => 'あ'})}],
  [do {no utf8; qq{---\nhoge: あ\n}}],
);
is_deeply(
  [do {use utf8; encode_yaml({hoge => 'あ'})}],
  [do {no utf8; qq{---\nhoge: あ\n}}],
);
is_deeply(
  [do {from_yaml_file("t/data/test.yml");}],
  [do {use utf8; {hoge => 'あ'};}],
);
is_deeply(
  [do {use utf8; to_yaml_file({hoge => "あいうえお"}, "t/data/test.out.yml"); from_yaml_file("t/data/test.out.yml");}],
  [do {use utf8; {hoge => "あいうえお"}}],
);
is_deeply(
  [do {no utf8; to_yaml_file({hoge => "あいうえお"}, "t/data/test.out.yml"); from_yaml_file("t/data/test.out.yml");}],
  [do {use utf8; {hoge => "あいうえお"}}],
);
done_testing;