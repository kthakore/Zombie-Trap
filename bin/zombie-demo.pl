package main;
use Modern::Perl;
use SDL;
use SDL::Rect;
use SDL::Video;
use SDLx::App;
use SDL::Event;
use SDL::Events; 
use FindBin;
use YAML::Tiny;

use SDLx::Surface;
use Box2D;
use lib 'lib';

use ZT::Object::Wall;
use ZT::Actor::Zombie;
use ZT::Util;
use ZT::Camera; 
use BoxSDL::Controller;
use Data::Dumper;

my $config = YAML::Tiny->read("$FindBin::Bin/../data/level1.yaml")->[0];

my ( $map_w, $map_h ) = @$config{qw( width height )};

my $fps      = 60.0;
my $timestep = 0.1;
my $vIters   = 8;
my $pIters   = 8;

my $camera = ZT::Camera->new();
my $app = SDLx::Surface->new(
    width  => $map_w,
    height => $map_h,
);


my $gravity = Box2D::b2Vec2->new( 0, 9.8 );
my $world = Box2D::b2World->new( $gravity, 1 );

my @walls;
my @zombies;


foreach ( @{ $config->{walls} } ) {
    my @dim = map { ZT::Util::s2w($_) } split /\s+/, $_;
    push @walls, ZT::Object::Wall->new( world => $world, dims => \@dim );
}

foreach ( @{ $config->{zombies} } ) {
    my @loc =  map { ZT::Util::s2w($_) } split /\s+/, $_; 
    push @zombies, ZT::Actor::Zombie->new( world=> $world, dims => \@loc);
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

$controller->add_event_handler(
sub { 
    my $event = shift; 

    my ($mask,$x,$y) = @{ SDL::Events::get_relative_mouse_state( ) };

    $camera->move_rel( $x, $y );

    
}

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
        $camera->update_view( $app );
    }
);

$controller->run();


