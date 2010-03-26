use Test::More;
use strict;

use Util::All '-image';

ok(defined &convert_image);
ok(defined &image_info);
ok(defined &image_type);
ok(defined &resize_image);
done_testing;