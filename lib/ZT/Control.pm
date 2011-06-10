package ZT::Control;
use Modern::Perl;
use Moose;
use Moose::Util::TypeConstraints;
use ZT;
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
  ( is => 'rw', isa => 'GameState', default => sub { 'game' } );
has 'data' => 
  ( is => 'rw', isa => 'HashRef', default => sub { {} } );

sub _build_world {

    my $vec = Box2D::b2Vec2->new( 0, 0 );
    my $world = Box2D::b2World->new( $vec, 1 );

}

sub switch_board {
	my $self = shift;
	my $app  = shift;

	given ( $self->state )
	{
		warn "Show the menu" when /^menu$/;
		warn "Run the game"	 when /^game$/;

	}

}

sub load_data {
	my $self = shift;
	my $zt = ZT->instance(); 

	#load image globs
}

1;

=pod

=head1 NAME

ZT::Control - Control for the game 

=head1 METHODS

=head2 switch_board

Switches between game states

=head2 load_data 

Load data and update the view 

=cut 
