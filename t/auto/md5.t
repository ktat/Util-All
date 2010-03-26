use Test::More;
use strict;

use Util::All '-md5';

ok(defined &md5);
ok(defined &md5_hex);
ok(defined &md5_base64);
done_testing;