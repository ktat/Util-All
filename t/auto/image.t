use Test::More;
use strict;

use Util::All '-image';

ok(defined &convert_image);
ok(defined &image_info);
ok(defined &image_type);
ok(defined &resize_image);
is_deeply(
  [do {use Util::All -image; convert_image("t/data/perl.jpg", "t/data/perl.png"); my $type = image_type("t/data/perl.png");}],
  [do {"PNG"}],
);
is_deeply(
  [do {use Util::All -image; my $info = image_info("t/data/perl.png"); ($info->{width}, $info->{height});}],
  [do {(100, 100)}],
);
is_deeply(
  [do {use Util::All -image; resize_image("t/data/perl.png", "t/data/perl_mini.png", 0.5); my $info = image_info("t/data/perl_mini.png"); ($info->{width}, $info->{height});}],
  [do {(50, 50)}],
);
is_deeply(
  [do {use Util::All -image; resize_image("t/data/perl.png", "t/data/perl_wide.png", [200,100]); my $info = image_info("t/data/perl_wide.png"); ($info->{width}, $info->{height});}],
  [do {(200, 100)}],
);
done_testing;