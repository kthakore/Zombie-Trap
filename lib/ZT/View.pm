package ZT::View;
use Modern::Perl;
use Moose;
use SDL;
use SDLx::App;
use SDL::Video;
use Carp;

has 'app' => (
    is      => 'rw',
    isa     => 'SDLx::App',
    builder => '_build_app'
);

sub _build_app {
    my $self = shift;

    my $app = SDLx::App->new(
        title => "Zombie Trap",
        eoq   => 1,
        flags => SDL_HWSURFACE | SDL_DOUBLEBUF
    );

    croak "Cannot start video " . SDL::get_error unless $app;

    return $app;
}

sub run {

    my $self = shift;

    $self->app()->run();

}

1;

=pod 

=head1 NAME

ZT::View - SDL View handler for ZT

=head1 METHOD

=head2 run

Running the SDLx::App

=cut 
