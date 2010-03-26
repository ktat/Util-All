use Test::More;
use strict;

use Util::All '-prompt';

ok(defined &prompt);
ok(defined &required_prompt);
ok(defined &password_prompt);
done_testing;