#!perl -T

use Test::More;

BEGIN {

    foreach (qw/ ZT ZT::Actor ZT::XS ZT::View ZT::Control ZT::Actor::Zombie/) {
        use_ok($_) || print "Bail out!";
    }
}

diag("Testing ZT $ZT::VERSION, Perl $], $^X");

done_testing();
