package main;
use Modern::Perl;
use SDL;
use SDL::Rect;
use SDL::Video;
use SDLx::App;
use FindBin;
use YAML::Tiny;

use SDLx::Surface;
use Box2D;
use lib 'lib';

use Wall;
use Zombie;
use Game::Util;
use BoxSDL::Controller;

my $config = YAML::Tiny->read("$FindBin::Bin/../data/level1.yaml")->[0];

my ( $map_w, $map_h ) = @$config{qw( width height )};

my $fps      = 60.0;
my $timestep = 0.1;
my $vIters   = 8;
my $pIters   = 8;

my $app = SDLx::App->new(
    width  => $map_w,
    height => $map_h,
    flags  => SDL_DOUBLEBUF | SDL_HWSURFACE,
);


my $gravity = Box2D::b2Vec2->new( 0, 9.8 );
my $world = Box2D::b2World->new( $gravity, 1 );

my @walls;
my @zombies;

sub make_wall {
    my ( $x, $y, $w, $h ) = @_;

    my ( $hx, $hy ) = ( $w / 2.0, $h / 2.0 );

    my %wall = (
        body  => Game::Util::make_body( $world, $x + $hx, $y + $hy ),
        shape => Game::Util::make_rect( $w,       $h ),
        color => 0x035307FF,
    );
    Game::Util::make_fixture( @wall{qw( body shape )} );

    # Store the shape for use in the contact listener.
    # b2Fixture::GetShape() could be used in the contact listener, but
    # it returns a b2Shape, and a b2PolygonShape is needed.
    $wall{body}->SetUserData( { self => \%wall } );

    return \%wall;
}



foreach ( @{ $config->{walls} } ) {
    my @dim = map { Game::Util::s2w($_) } split /\s+/, $_;
    push @walls, Wall->new( @dim );
}

foreach ( @{ $config->{zombies} } ) {
    my @loc =  map { Game::Util::s2w($_) } split /\s+/, $_; 
    push @zombies, Zombie->new( world=> $world, x=> $loc[0], y=> $loc[1]);
}

my $listener = Box2D::PerlContactListener->new();

$listener->SetBeginContactSub(
    sub {
        my ($contact) = @_;

        my $bodyA = $contact->GetFixtureA->GetBody();
        my $bodyB = $contact->GetFixtureB->GetBody();

        foreach ( [ $bodyA, $bodyB ], [ $bodyB, $bodyA ] ) {
            my $data = $_->[0]->GetUserData();
            my $sub = $data->{cb} if defined $data->{cb};
            $sub->( $_->[1]->GetUserData->{self} ) if ref $sub eq 'CODE';
        }
    }
);

$world->SetContactListener($listener);
my $controller = BoxSDL::Controller->new( 
    dt     => $timestep, 
	delay  => 10,
    min_t  => $timestep / 2,
    eoq    => 1,
    world  => $world,
    vIters => $vIters,
    pIters => $pIters, 
    c_f    => 1
    );

$controller->add_move_handler(
sub{
        $_->move() foreach @zombies;

}

);

$controller->add_show_handler(
    sub {
        $app->draw_rect( undef, 0x202020FF );
        $_->draw($app)   foreach @walls;
        $_->draw($app) foreach @zombies;

        $app->update();
    }
);

$controller->run();


