use Test::More;
use strict;

use Util::All '-prompt';

ok(defined &prompt);
ok(defined &required_prompt);
ok(defined &password_prompt);
SKIP: { skip(q{$^O eq 'MSWin32';}, 2) if $^O eq 'MSWin32';;
is_deeply(
  [do {package Util::All::_prompt;use Util::All '-prompt'; $|=1; my $answer = required_prompt("input somthing(1):"); $answer !~ /%$/;}],
  [do {1;}],
);
is_deeply(
  [do {package Util::All::_prompt;use Util::All '-prompt'; $|=1; password_prompt("input somthing(2):"); my $answer = required_prompt("\ninputted value was displaied as '*' ?(y/n)", -yn); $answer eq 'y';}],
  [do {1;}],
);
}
done_testing;