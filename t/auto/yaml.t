use Test::More;
use strict;

use Util::All '-yaml';

ok(defined &to_yaml);
ok(defined &to_yaml_file);
ok(defined &from_yaml_file);
ok(defined &from_yaml);
is_deeply(
  [do {package test_yaml; use Util::All -yaml, -debug; dump from_yaml(to_yaml({hoge => 1}));}],
  [do {'{ hoge => 1 }'}],
);
is_deeply(
  [do {package test_yaml; use Util::All -yaml; to_yaml(from_yaml_file("t/data/test.yml"));}],
  [do {"---\nhoge: 1\n"}],
);
done_testing;