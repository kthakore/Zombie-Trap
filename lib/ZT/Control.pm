package ZT::Control;
use Modern::Perl;
use Moose;
use ZT::Actor;
use Box2D;

has 'actors' => ( is => 'rw', isa => 'ArrayRef[ZT::Actor]', default => sub { [] } );
has 'world' => ( is => 'rw', isa => 'Box2D::b2World', builder => '_build_world' );

sub _build_world
{

	my $vec = Box2D::b2Vec2->new(0,0);
	my $world = Box2D::b2World->new($vec, 1);

}

1;

=pod

=head1 NAME

ZT::Control - Control for the game 

=cut 
