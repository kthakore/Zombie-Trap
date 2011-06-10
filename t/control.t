use Test::More;
use Modern::Perl;
use ZT;

my $zt = ZT->instance();

isa_ok( $zt->control(),        "ZT::Control" );
isa_ok( $zt->control->world(), "Box2D::b2World" );

#is( $zt->control->state() , "menu" );

done_testing();
