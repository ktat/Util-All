#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Util::All' );
}

diag( "Testing Util::All $Util::All::VERSION, Perl $], $^X" );
