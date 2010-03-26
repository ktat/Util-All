use Test::More;
use strict;

use Util::All '-string';

ok(defined &camelize);
ok(defined &decamelize);
ok(defined &wordsplit);
ok(defined &crunch);
ok(defined &define);
ok(defined &equndef);
ok(defined &fullchomp);
ok(defined &hascontent);
ok(defined &htmlesc);
ok(defined &neundef);
ok(defined &nospace);
ok(defined &randcrypt);
ok(defined &randword);
ok(defined &trim);
ok(defined &unquote);
ok(defined &strings);
is_deeply(
  [do {package test_strings1; use Util::All -string; strings('111' . "\0" . '111');}],
  [do {"111111"}],
);
done_testing;