#!perl -T

use Test::More;

BEGIN {

    foreach (qw/ ZT ZT::Level ZT::State ZT::Util ZT::Camera /) {
        use_ok($_) || print "Bail out!";
    }
}

diag("Testing ZT $ZT::VERSION, Perl $], $^X");

done_testing();
