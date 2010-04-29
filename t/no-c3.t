package AA;
use Util::All -modern;
sub hello { 'AA::hello' }

package BB;
use base 'AA';
use Util::All -modern => [];

package CC;
use base 'AA';
use Util::All -modern => [];

sub hello { 'CC::hello' }

package DD;
use base ('BB', 'CC');
use Util::All -modern => [];

package main;
use Util::All;
use Test::More;

is(DD->hello(), 'AA::hello');

done_testing;
