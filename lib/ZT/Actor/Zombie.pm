package ZT::Actor::Zombie;
use Modern::Perl;
use Moose;
use Carp;
use Box2D;

extends 'ZT::Actor';

has 'body' => ( is => 'rw', isa => 'Box2D::b2Body', builder=> '_build_body' );

sub _build_body {

	my $self = shift;

	my $body_def = Box2D::b2BodyDef->new();
	   $body_def->type( Box2D::b2_dynamicBody );

		$body_def->position->Set(0,0);

	my $zt = ZT->instance();

	my $body = $zt->control->world->CreateBody($body_def);

	my $box = Box2D::b2PolygonShape->new();
	   $box->SetAsBox( 16, 16 );

	my $fixture = Box2D::b2FixtureDef->new();
	   $fixture->shape( $box );
	   $fixture->density( 0.1 + 2*rand() );
	   $fixture->friction( 0.1 );

	$body->CreateFixtureDef( $fixture );

	return $body;
}

1;

=pod 

=head1 NAME

ZT::Actor::Zombie - Zombie Construct 

=cut 
