#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok( 'Util::All' );
	use_ok( 'Util::All', 'all');
}

diag( "Testing Util::All $Util::All::VERSION, Perl $], $^X" );
