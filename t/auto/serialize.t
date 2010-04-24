use Test::More;
use strict;

use Util::All '-serialize';

ok(defined &deserialize);
ok(defined &serialize);
is_deeply(
  [do {package Hoge1; use Util::All -serialize => [-args => {serializer => 'Storable', digester => 'MD5', cipher => 'DES', secret => 'my secret', compress => 1}]; my $serialized_data = serialize({a => 123,  b => 223}); deserialize($serialized_data);}],
  [do {{a => 123, b => 223}}],
);
is_deeply(
  [do {package Hoge2; use Util::All -serialize; my $opt = {serializer => 'Storable', digester => 'MD5', cipher => 'DES', secret => 'my secret', compress => 1}; my $serialized_data = serialize({a => 123,  b => 223}, $opt); deserialize($serialized_data, $opt);}],
  [do {{a => 123, b => 223}}],
);
done_testing;