use Test::More;
use strict;

use Util::All '-oo';

ok(defined &mk_ro_accessors);
ok(defined &mk_wo_accessors);
ok(defined &mk_accessors);
is_deeply(
  [do {package Hoge1; use Util::All -oo; mk_accessors("foo", "bar"); my $o = Hoge1->new; $o->foo(100); $o->bar("ABC"); ($o->foo, $o->bar);}],
  [do {(100, "ABC");}],
);
is_deeply(
  [do {package Hoge2; use Util::All -oo; mk_ro_accessors("foo", "bar"); my $o = Hoge2->new({foo => 200, bar => 300}); ($o->foo, $o->bar);}],
  [do {(200, 300);}],
);
is_deeply(
  [do {package Hoge3; use Util::All -oo; mk_wo_accessors("foo", "bar"); my $o = Hoge3->new; ($o->foo(300), $o->bar(400));}],
  [do {(300, 400);}],
);
is_deeply(
  [do {package Hoge4; use Util::All -oo; mk_ro_accessors("foo", "bar"); my $o = Hoge2->new({foo => 200, bar => 300}); eval {($o->foo(300), $o->bar(400))}; if($@){1}else{0};}],
  [do {1;}],
);
is_deeply(
  [do {package Hoge5; use Util::All -oo; mk_wo_accessors("foo", "bar"); my $o = Hoge3->new; ($o->foo(300), $o->bar(400)); eval {($o->foo, $o->bar)}; if($@){1}else{0};}],
  [do {1;}],
);
done_testing;