use Test::More;
use strict;

use Util::All '-datetime';

ok(defined &now);
ok(defined &today);
ok(defined &datetime);
ok(defined &hour);
ok(defined &hours);
ok(defined &second);
ok(defined &month);
ok(defined &minutes);
ok(defined &days);
ok(defined &seconds);
ok(defined &minute);
ok(defined &years);
ok(defined &day);
ok(defined &datetime_duration);
ok(defined &year);
ok(defined &months);
ok(defined &datetime_parse);
is_deeply(
  [do {package test_datetime1; use Util::All '-datetime'; my $dt = datetime_parse("1970/01/01"); $dt += year; $dt->year;}],
  [do {1971}],
);
is_deeply(
  [do {package test_datetime2; use Util::All '-datetime'; my $dt = datetime_parse("1970/01/01"); $dt += years 2; $dt->year;}],
  [do {1972}],
);
is_deeply(
  [do {package test_datetime3; use Util::All '-datetime'; my $dt = datetime_parse("1970/02/01"); $dt += month; $dt->day;}],
  [do {1}],
);
is_deeply(
  [do {package test_datetime4; use Util::All '-datetime'; year->end_of_month_mode;}],
  [do {('limit')}],
);
is_deeply(
  [do {package test_datetime5; use Util::All '-datetime' => [-args => {end_of_month => 'wrap'}]; year->end_of_month_mode;}],
  [do {('wrap')}],
);
is_deeply(
  [do {package test_datetime6; use Util::All '-datetime' => ['month', year => {end_of_month => 'preserve'}]; join ' ', year->end_of_month_mode, month->end_of_month_mode;}],
  [do {('preserve limit')}],
);
is_deeply(
  [do {package test_datetime7; use Util::All '-datetime' => ['year', month => {end_of_month => 'wrap'}]; join ' ', month->end_of_month_mode, year->end_of_month_mode;}],
  [do {('wrap limit')}],
);
is_deeply(
  [do {package test_datetime8; use Util::All '-datetime' => ['day', days => {end_of_month => 'preserve'}]; join ' ', days(5)->end_of_month_mode, day->end_of_month_mode;}],
  [do {('preserve limit')}],
);
done_testing;