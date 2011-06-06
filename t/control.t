use Test::More;
use Modern::Perl;
use ZT;

my $zt = ZT->new();

isa_ok( $zt->control(),        "ZT::Control" );
isa_ok( $zt->control->world(), "Box2D::b2World" );

done_testing();
