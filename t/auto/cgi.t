use Test::More;
use strict;

use Util::All '-cgi';

ok(defined &encode_html_entities);
ok(defined &decode_html_entities);
ok(defined &cgi_escape);
ok(defined &cgi_unescape);
is_deeply(
  [do {package AAA; no utf8; use Util::All -cgi; encode_html_entities("あいうえお");}],
  [do {'&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'}],
);
is_deeply(
  [do {package BBB; use utf8; use Util::All -cgi; encode_html_entities("あいうえお");}],
  [do {'&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'}],
);
is_deeply(
  [do {package CCC; no utf8; use Util::All -cgi; encode_html_entities(my $s = "あいうえお"); $s;}],
  [do {'&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'}],
);
is_deeply(
  [do {package DDD; use utf8; use Util::All -cgi; encode_html_entities(my $s = "あいうえお"); $s;}],
  [do {'&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'}],
);
is_deeply(
  [do {package EEE; no utf8; use Util::All -cgi; decode_html_entities(encode_html_entities("あいうえお"));}],
  [do {use utf8; 'あいうえお'}],
);
is_deeply(
  [do {package FFF; use utf8; use Util::All -cgi; decode_html_entities(encode_html_entities("あいうえお"));}],
  [do {use utf8; 'あいうえお'}],
);
is_deeply(
  [do {package GGG; no utf8; use Util::All -cgi; my $str = "あいうえお"; encode_html_entities($str); $str;}],
  [do {'&#x3042;&#x3044;&#x3046;&#x3048;&#x304A;'}],
);
is_deeply(
  [do {package HHH; no utf8; use Util::All -cgi; my $str = "あいうえお"; scalar encode_html_entities($str); $str;}],
  [do {no utf8; 'あいうえお'}],
);
is_deeply(
  [do {package III; no utf8; use Util::All -cgi => [encode_html_entities => {words => "<>"}]; my $str = "あいうえお<&>"; encode_html_entities($str);}],
  [do {use utf8; 'あいうえお&lt;&&gt;'}],
);
is_deeply(
  [do {package JJJ; no utf8; use Util::All -cgi => [-args => {words => "<>"}]; my $str = "あいうえお<&>"; encode_html_entities($str);}],
  [do {use utf8; 'あいうえお&lt;&&gt;'}],
);
is_deeply(
  [do {package KKK; no utf8;use Util::All -cgi => [-args => {words => "<>"}]; my $str = "あいうえお<&>"; encode_html_entities($str, "&");}],
  [do {use utf8; 'あいうえお<&amp;>'}],
);
done_testing;