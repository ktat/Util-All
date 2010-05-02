use Test::More;
use strict;

use Util::All '-email';

ok(defined &send_template_email);
ok(defined &send_email);
ok(defined &parse_email);
ok(defined &create_email);
done_testing;