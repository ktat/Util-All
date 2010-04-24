use Test::More;
use strict;

use Util::All '-unicode';

ok(defined &unicode_name);
ok(defined &unicode_block);
ok(defined &utf32be);
ok(defined &utf32le);
ok(defined &utf16be);
ok(defined &utf16le);
ok(defined &utf8);
ok(defined &utf7);
ok(defined &latin1);
ok(defined &uhex);
ok(defined &uchr);
done_testing;