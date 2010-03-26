use Test::More;
use strict;

use Util::All '-file';

ok(defined &make_path);
ok(defined &remove_tree);
ok(defined &read_file);
ok(defined &write_file);
ok(defined &find_file);
ok(defined &move_file);
ok(defined &slurp_file);
ok(defined &file_base64);
ok(defined &tempfile);
ok(defined &copy_file);
is_deeply(
  [do {use Util::All -file; my $fh = tempfile("anyname*.dat", dir => "./t/data/", unlink => 1); $fh->filename =~m{^t/data/anyname\w{4}\.dat$} || $fh->filename;}],
  [do {1}],
);
is_deeply(
  [do {use Util::All -file; my $fh = tempfile("anyname", dir => "./t/data/", suffix => ".tmp", unlink => 1); $fh->filename =~m{^t/data/anyname\w{4}\.tmp$} || $fh->filename;}],
  [do {1}],
);
is_deeply(
  [do {use Util::All -file; my $fh = tempfile(template => "anyname", dir => "./t/data/", suffix => ".tmp", unlink => 1); $fh->filename =~m{^t/data/anyname\w{4}\.tmp$} || $fh->filename;}],
  [do {1}],
);
is_deeply(
  [do {use Util::All -file; my $fh = tempfile("anynameXXXXXXXX", dir => "./t/data/", suffix => ".tmp", unlink => 1); $fh->filename =~m{^t/data/anyname\w{8}\.tmp$} || $fh->filename;}],
  [do {1}],
);
done_testing;