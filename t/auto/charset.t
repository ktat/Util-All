use Test::More;
use strict;

use Util::All '-charset';

ok(defined &h2z_sym);
ok(defined &h2z);
ok(defined &z2h_alpha);
ok(defined &z2h_num);
ok(defined &h2z_num);
ok(defined &h2z_kana);
ok(defined &z2h_sym);
ok(defined &h2z_alpha);
ok(defined &z2h);
ok(defined &z2h_kana);
ok(defined &jfold);
ok(defined &char_convert);
ok(defined &char_from_to);
ok(defined &char_encode);
ok(defined &char_decode);
is_deeply(
  [do {use Util::All -charset; jfold("アイウエオ１２３４ABCD（）＊＆", 4);}],
  [do {"アイ\nウエ\nオ１\n２３\n４AB\nCD（\n）＊\n＆"}],
);
is_deeply(
  [do {use Util::All -charset; jfold("ｱｲｳｴｵ１２３４ＡＢＣＤ（）＊", 4);}],
  [do {"ｱｲｳｴ\nｵ１２\n３４\nＡＢ\nＣＤ\n（）\n＊"}],
);
is_deeply(
  [do {use Util::All -charset; jfold("～！＠＃＄％＾＆＊（）＿＋＝ー／＼；？＞＜。、，．：｛｝「」［］｜『』《》〔〕", 4);}],
  [do {"～！\n＠＃\n＄％\n＾＆\n＊（\n）＿\n＋＝\nー／\n＼；\n？＞\n＜。\n、，\n．：\n｛｝\n「」\n［］\n｜『\n』《\n》〔\n〕"}],
);
is_deeply(
  [do {use Util::All -charset; jfold("アイウエオ１２３４ABCD（）＊＆", 4, "\t");}],
  [do {"アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"}],
);
is_deeply(
  [do {use utf8; use Util::All -charset; jfold("アイウエオ１２３４ABCD（）＊＆", 4, "\t");}],
  [do {use utf8; "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"}],
);
is_deeply(
  [do {no utf8; use Util::All -charset; jfold("アイウエオ１２３４ABCD（）＊＆", 4, "\t");}],
  [do {no utf8; "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"}],
);
is_deeply(
  [do {package charset_jfold; use Util::All -charset => [jfold => {width => 4, nl => "\t"}]; jfold("アイウエオ１２３４ABCD（）＊＆");}],
  [do {no utf8; "アイ\tウエ\tオ１\t２３\t４AB\tCD（\t）＊\t＆"}],
);
is_deeply(
  [do {my $ss = char_convert(my $s = "あ", "euc-jp"); $ss}],
  [do {my $s = "あ"; Encode::from_to($s, "utf8", "euc-jp"); $s;}],
);
is_deeply(
  [do {my $ss = char_convert(my $s = "あ", "cp932", "utf8"); $ss}],
  [do {my $s = "あ"; Encode::from_to($s, "utf8", "cp932"); $s;}],
);
is_deeply(
  [do {use utf8; my $ss = char_convert(my $s = "あ", "euc-jp"); $ss}],
  [do {my $s = "あ"; Encode::from_to($s, "utf8", "euc-jp"); $s;}],
);
is_deeply(
  [do {use utf8; my $ss = char_convert(my $s = "あ", "cp932", "utf8"); $ss}],
  [do {my $s = "あ"; Encode::from_to($s, "utf8", "cp932"); $s;}],
);
is_deeply(
  [do {my $ss = char_convert(\(my $s = "あ"), "euc-jp"); $$ss eq $s}],
  [do {1;}],
);
is_deeply(
  [do {z2h('アイウエオ１２３４ＡＢＣＤ（）＊＆')}],
  [do {'ｱｲｳｴｵ1234ABCD()*&'}],
);
is_deeply(
  [do {z2h_alpha('アイウエオ１２３４ＡＢＣＤ（）＊＆')}],
  [do {'アイウエオ１２３４ABCD（）＊＆'}],
);
is_deeply(
  [do {z2h_sym('アイウエオ１２３４ＡＢＣＤ（）＊＆')}],
  [do {'アイウエオ１２３４ＡＢＣＤ()*&'}],
);
is_deeply(
  [do {z2h_num('アイウエオ１２３４ＡＢＣＤ（）＊＆')}],
  [do {'アイウエオ1234ＡＢＣＤ（）＊＆'}],
);
is_deeply(
  [do {z2h_kana('アイウエオ１２３４ＡＢＣＤ（）＊＆')}],
  [do {'ｱｲｳｴｵ１２３４ＡＢＣＤ（）＊＆'}],
);
is_deeply(
  [do {h2z('ｱｲｳｴｵ1234ABCD()*&')}],
  [do {'アイウエオ１２３４ＡＢＣＤ（）＊＆'}],
);
is_deeply(
  [do {h2z_alpha('ｱｲｳｴｵ1234ABCD()*&')}],
  [do {'ｱｲｳｴｵ1234ＡＢＣＤ()*&'}],
);
is_deeply(
  [do {h2z_sym('ｱｲｳｴｵ1234ABCD()*&')}],
  [do {'ｱｲｳｴｵ1234ABCD（）＊＆'}],
);
is_deeply(
  [do {h2z_num('ｱｲｳｴｵ1234ABCD()*&')}],
  [do {'ｱｲｳｴｵ１２３４ABCD()*&'}],
);
is_deeply(
  [do {h2z_kana('ｱｲｳｴｵ1234ABCD()*&')}],
  [do {'アイウエオ1234ABCD()*&'}],
);
is_deeply(
  [do {use utf8; z2h('アイウエオ１２３４ＡＢＣＤ（）＊＆')}],
  [do {use utf8; 'ｱｲｳｴｵ1234ABCD()*&'}],
);
is_deeply(
  [do {use utf8; z2h('アイウエオ１２３４ＡＢＣＤ（）＊＆')}],
  [do {use utf8; 'ｱｲｳｴｵ1234ABCD()*&'}],
);
done_testing;