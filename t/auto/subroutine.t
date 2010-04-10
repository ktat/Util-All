use Test::More;
use strict;

use Util::All '-subroutine';

ok(defined &install_subroutine);
ok(defined &uninstall_subroutine);
ok(defined &get_code_info);
ok(defined &get_code_ref);
ok(defined &curry);
ok(defined &modify_subroutine);
ok(defined &subroutine_modifier);
done_testing;