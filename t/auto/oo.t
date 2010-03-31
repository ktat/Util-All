use Test::More;
use strict;

use Util::All '-oo';

ok(defined &classdata);
ok(defined &wo_accessors);
ok(defined &ro_accessors);
ok(defined &accessors);
is_deeply(
  [do {package Hoge1; use Util::All -oo; accessors("foo", "bar"); my $o = Hoge1->new; $o->foo(100); $o->bar("ABC"); ($o->foo, $o->bar);}],
  [do {(100, "ABC");}],
);
is_deeply(
  [do {package Hoge2; use Util::All -oo; ro_accessors("foo", "bar"); my $o = Hoge2->new({foo => 200, bar => 300}); ($o->foo, $o->bar);}],
  [do {(200, 300);}],
);
is_deeply(
  [do {package Hoge3; use Util::All -oo; wo_accessors("foo", "bar"); my $o = Hoge3->new; ($o->foo(300), $o->bar(400));}],
  [do {(300, 400);}],
);
is_deeply(
  [do {package Hoge4; use Util::All -oo; ro_accessors("foo", "bar"); my $o = Hoge2->new({foo => 200, bar => 300}); eval {($o->foo(300), $o->bar(400))}; if($@){1}else{0};}],
  [do {1;}],
);
is_deeply(
  [do {package Hoge5; use Util::All -oo; wo_accessors("foo", "bar"); my $o = Hoge3->new; ($o->foo(300), $o->bar(400)); eval {($o->foo, $o->bar)}; if($@){1}else{0};}],
  [do {1;}],
);
is_deeply(
  [do {package Hoge6; use Util::All -oo; classdata("Foo"); Hoge6->Foo("foo!"); Hoge6->Foo;}],
  [do {"foo!"}],
);
is_deeply(
  [do {package Hoge6; use Util::All -oo; classdata("Foo"); Hoge6->Foo("foo!"); package Hoge7; push @Hoge7::ISA, 'Hoge6'; my $s = Hoge7->Foo; Hoge7->Foo(100); $s.= Hoge7->Foo . Hoge6->Foo;}],
  [do {"foo!100foo!"}],
);
done_testing;