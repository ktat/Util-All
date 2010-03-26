use Test::More;
use strict;

use Util::All '-data';

ok(defined &blessed);
ok(defined &dualvar);
ok(defined &isvstring);
ok(defined &isweak);
ok(defined &looks_like_number);
ok(defined &openhandle);
ok(defined &readonly);
ok(defined &refaddr);
ok(defined &reftype);
ok(defined &set_prototype);
ok(defined &tainted);
ok(defined &weaken);
done_testing;