package BoxSDL::Observable;
use Modern::Perl;
use Box2D;

use SDL; 
use SDLx::Surface;
use SDLx::Controller;

our $VERSION = 0.01;

sub new
{
	my $class = shift;

	my $self = {};

	$self = bless $self, $class;

	return $self;
}

1;

=pod 

=head1 NAME

BoxSDL::Observable - A Box2D/SDL object that can be observed using SDLx::Controller 

=head1 METHODS

=head2 new 

	my $obs = BoxSDL::Observable->new( 
										sprite        => $sdlx_surface,    		  # will be passed to callbacks 
										app           => $sdlx_app,        		  # attaches callbacks to this controller/app 
										on_contact    => $call_hash,              # attaches these callbacks on contact 
										after_contact => $call_hash,              # attaches these callbacks when contact is done 
										default 	  => $call_hash               # attaches these callbacks as soon we make observable 
									 );

C<$call_hash> is a hash_ref 

	{
		event => [ \&callback, ... ],
		move  => [ \&callback, ... ],
		show  => [ \&callback, ... ]		
	}

Each on_contact, after_contact callback will be passed the C<Box2D::b2Contact>. 
									
=head2 
