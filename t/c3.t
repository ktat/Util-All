package AA;
use Util::All;
sub hello { 'AA::hello' }

package BB;
use base 'AA';
use Util::All;

package CC;
use base 'AA';
use Util::All;

sub hello { 'CC::hello' }

package DD;
use base ('BB', 'CC');
use Util::All;

package main;
use Util::All;
use Test::More;

is(DD->hello(), 'CC::hello');

done_testing;
