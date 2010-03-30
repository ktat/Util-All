use Test::More;
use strict;

use Util::All '-xml';

ok(defined &to_xml);
ok(defined &from_xml);
is_deeply(
  [do {package xml_test1; use Util::All -xml => [-args => {force_array => 1, key_attr => "hoge"}]; from_xml("t/data/test.xml");}],
  [do {{"parent" => { "1" => {"child" => ["1"]}, "2" => {"child" => ["2","40","50"]}}};}],
);
is_deeply(
  [do {package xml_test2; use Util::All -xml => [-args => {force_array => 0, key_attr => "hoge"}]; from_xml("t/data/test.xml");}],
  [do {{"parent" => { "1" => {"child" => "1"}, "2" => {"child" => ["2","40","50"]}}};}],
);
is_deeply(
  [do {package xml_test3; use Util::All -xml; from_xml("t/data/test.xml");}],
  [do {{"parent" => [{hoge => 1, "child" => ["1"]}, {hoge => 2, "child" => ["2","40","50"]}]};}],
);
is_deeply(
  [do {package xml_test4; use Util::All -xml;from_xml("t/data/test.xml", force_array => 0, key_attr => "hoge");}],
  [do {{"parent" => { "1" => {"child" => "1"}, "2" => {"child" => ["2","40","50"]}}};}],
);
done_testing;