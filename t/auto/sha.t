use Test::More;
use strict;

use Util::All '-sha';

ok(defined &sha1);
ok(defined &sha1_hex);
ok(defined &sha1_base64);
ok(defined &sha256);
ok(defined &sha256_hex);
ok(defined &sha256_base64);
ok(defined &sha384);
ok(defined &sha384_hex);
ok(defined &sha384_base64);
ok(defined &sha512);
ok(defined &sha512_hex);
ok(defined &sha512_base64);
done_testing;