use Test::More;
use strict;

use Util::All '-csv';

ok(defined &parse_csv);
is_deeply(
  [do {package test_csv1; use Util::All -csv; my $csv = parse_csv("t/data/test.csv"); my $sum = 0; while (my $l = $csv->next) {$sum +=$l->[1]}; $sum;}],
  [do {223}],
);
is_deeply(
  [do {package test_csv2; use Util::All -csv; my $csv = parse_csv("t/data/test.csv", ['l', 'num']); my $label = ''; while (my $l = $csv->next) {$label .=$l->{l}}; $label;}],
  [do {"abcdefアイウエオ"}],
);
is_deeply(
  [do {package test_csv3; use Util::All -csv; open my $fh, "t/data/test.csv"; my $csv = parse_csv($fh); my $sum = 0; while (my $l = $csv->next) {$sum +=$l->[1]}; $sum;}],
  [do {223}],
);
is_deeply(
  [do {package test_csv4; use Util::All -csv; open my $fh, "t/data/test.csv"; my $csv = parse_csv($fh); 1 while $csv->next; tell $fh;}],
  [do {49}],
);
done_testing;