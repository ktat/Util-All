use Test::More;
use strict;

use Util::All '-xml';

ok(defined &to_xml);
ok(defined &from_xml);
done_testing;