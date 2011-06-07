package ZT::Control;
use Modern::Perl;
use Moose;
use Moose::Util::TypeConstraints;
use ZT::Actor;
use Box2D;

our @STATES = qw/ menu game /;

subtype 'GameState' => as 'Str' => where { $_ ~~ @STATES } =>
  message { 'Invalid game state' };

has 'actors' =>
  ( is => 'rw', isa => 'ArrayRef[ZT::Actor]', default => sub { [] } );
has 'world' =>
  ( is => 'rw', isa => 'Box2D::b2World', builder => '_build_world' );
has 'state' =>
  ( is => 'rw', isa => 'GameState', default => sub { return 'menu' } );

sub _build_world {

    my $vec = Box2D::b2Vec2->new( 0, 0 );
    my $world = Box2D::b2World->new( $vec, 1 );

}

1;

=pod

=head1 NAME

ZT::Control - Control for the game 

=cut 
