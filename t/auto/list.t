use Test::More;
use strict;

use Util::All '-list';

ok(defined &first);
ok(defined &max);
ok(defined &maxstr);
ok(defined &min);
ok(defined &minstr);
ok(defined &reduce);
ok(defined &shuffle);
ok(defined &sum);
ok(defined &after);
ok(defined &after_incl);
ok(defined &all);
ok(defined &any);
ok(defined &apply);
ok(defined &before);
ok(defined &before_incl);
ok(defined &each_array);
ok(defined &each_arrayref);
ok(defined &false);
ok(defined &first_index);
ok(defined &first_value);
ok(defined &firstidx);
ok(defined &firstval);
ok(defined &indexes);
ok(defined &insert_after);
ok(defined &insert_after_string);
ok(defined &last_index);
ok(defined &last_value);
ok(defined &lastidx);
ok(defined &lastval);
ok(defined &mesh);
ok(defined &minmax);
ok(defined &natatime);
ok(defined &none);
ok(defined &notall);
ok(defined &pairwise);
ok(defined &part);
ok(defined &true);
ok(defined &uniq);
ok(defined &zip);
done_testing;