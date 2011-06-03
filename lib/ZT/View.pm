package ZT::View;
use Modern::Perl;
use Moose;
use SDLx::App;

has 'video' => ( is => 'rw', isa => 'SDLx::App', default => sub{ SDLx::App->new( title => "Zombie Trap", eoq => 1) } );

sub run {

	my $self = shift;

	$self->video()->run();

}

1;
