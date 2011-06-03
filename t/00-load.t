#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'ZT' ) || print "Bail out!
";
}

diag( "Testing ZT $ZT::VERSION, Perl $], $^X" );
