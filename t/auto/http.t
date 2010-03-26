use Test::More;
use strict;

use Util::All '-http';

ok(defined &http_post);
ok(defined &http_put);
ok(defined &http_get);
ok(defined &http_head);
ok(defined &http_delete);
done_testing;