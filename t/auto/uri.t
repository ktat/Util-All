use Test::More;
use strict;

use Util::All '-uri';

ok(defined &uri_escape);
ok(defined &uri_unescape);
ok(defined &uri_split);
ok(defined &uri_join);
ok(defined &make_uri);
ok(defined &make_query);
is_deeply(
  [do {make_query({foo => "あ", bar => ["い", "う"]});}],
  [do {('bar=%E3%81%86&bar=%E3%81%84&foo=%E3%81%82')}],
);
is_deeply(
  [do {my $x = "あ"; utf8::decode($x); make_query({foo => $x});}],
  [do {('foo=%E3%81%82')}],
);
is_deeply(
  [do {make_uri('http://example.com/', { foo => "あ", bar => "い"});}],
  [do {('http://example.com/?bar=%E3%81%84&foo=%E3%81%82')}],
);
is_deeply(
  [do {my $x = "あ"; utf8::decode($x); make_uri('http://example.com/', { foo => $x});}],
  [do {('http://example.com/?foo=%E3%81%82')}],
);
done_testing;