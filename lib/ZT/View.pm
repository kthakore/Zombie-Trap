package ZT::View;
use Modern::Perl;
use Moose;
use SDLx::App;
use SDL::Video;

has 'video' => (
    is      => 'rw',
    isa     => 'SDLx::App',
    builder => '_build_video'
);

sub _build_video {
    my $self = shift;

    my $app = SDLx::App->new(
        title => "Zombie Trap",
        eoq   => 1,
        flags => SDL_HWSURFACE | SDL_DOUBLEBUF
    );

    return $app;
}

sub run {

    my $self = shift;

    $self->video()->run();

}

1;
