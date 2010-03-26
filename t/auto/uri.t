use Test::More;
use strict;

use Util::All '-uri';

ok(defined &uri_escape);
ok(defined &uri_unescape);
ok(defined &uri_split);
ok(defined &uri_join);
ok(defined &uri_make);
is_deeply(
  [do {uri_make('http://example.com/', { foo => "あ", bar => "い"});}],
  [do {('http://example.com/?bar=%E3%81%84&foo=%E3%81%82')}],
);
is_deeply(
  [do {my $x = "あ"; utf8::decode($x); uri_make('http://example.com/', { foo => $x});}],
  [do {('http://example.com/?foo=%E3%81%82')}],
);
done_testing;