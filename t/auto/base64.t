use Test::More;
use strict;

use Util::All '-base64';

ok(defined &urlsafe_base64_decode);
ok(defined &base64_encode);
ok(defined &urlsafe_base64_encode);
ok(defined &base64_decode);
done_testing;