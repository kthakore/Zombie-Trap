package ZT::Util;
use Modern::Perl; 
use Box2D;
use FindBin;
use SDL::GFX::Primitives; 
use SDL;
use SDL::Video;
use SDLx::App;
use Data::Dumper;
use ZT::State::Game;

our $data_dir = "$FindBin::Bin/../data/";

my $ppm = 15.0;
my $mpp = 1.0 / $ppm;


#TODO refactor this to a util sub 
sub make_body {
    my ($world, $x, $y, %args ) = @_;
    my $bodyDef = Box2D::b2BodyDef->new();
    $bodyDef->type(Box2D::b2_dynamicBody) if $args{dynamic};
    $bodyDef->fixedRotation(1) if $args{fixedRotation};
    $bodyDef->position->Set( $x, $y );
    return $world->CreateBody($bodyDef);
}

sub make_rect {
    my ( $w, $h ) = @_;
    my $rect = Box2D::b2PolygonShape->new();
    $rect->SetAsBox( $w / 2, $h / 2 );
    return $rect;
}

sub make_fixture {
    my ( $body, $shape ) = @_;
    my $fixtureDef = Box2D::b2FixtureDef->new();
    $fixtureDef->shape($shape);
    $fixtureDef->friction(0.2);
    $fixtureDef->density(1.0);
    return $body->CreateFixtureDef($fixtureDef);
}

# Is the vector above the object?
sub is_above {
    my ( $vec, $obj ) = @_;

    my ( $body, $shape ) = @$obj{qw( body shape )};

    my @verts = map { $body->GetWorldPoint( $shape->GetVertex($_) ) }
        ( 0 .. $shape->GetVertexCount() - 1 );

    foreach (@verts) {
        return 0 if $vec->y > $_->y;
    }

    return 1;
}


# screen to world
sub s2w { return $_[0] * $mpp }

# world to screen
sub w2s { return $_[0] * $ppm }

sub draw_polygon {
    my ( $app, $self) = @_;

    my ( $body, $shape, $color ) = @$self{qw( body shape color )};

    my @verts; my @vx; my @vy;
    unless( $self->{poly_dat} )
    {
        @verts = map { $body->GetWorldPoint( $shape->GetVertex($_) ) }
            ( 0 .. $shape->GetVertexCount() - 1 );

        @vx = map { ZT::Util::w2s( $_->x ) } @verts;
        @vy = map { ZT::Util::w2s( $_->y ) } @verts;
        $self->{poly_dat} = { verts => \@verts, vx => \@vx, vy => \@vy };
    }
    else
    {
        my $pd = $self->{poly_dat};
        @verts = @{$pd->{verts}};
        @vx = @{$pd->{vx}};
        @vy = @{$pd->{vy}};

    }
    
        SDL::GFX::Primitives::filled_polygon_color( $app, \@vx, \@vy,
            scalar @verts, $color );

}

my $app;
sub app {
    unless( $ZT::Util::app )
    {
           $ZT::Util::app = SDLx::App->new(
            width  => 800,
            height => 640,
            flags  => SDL_DOUBLEBUF | SDL_HWSURFACE,
            );
    }

    return $ZT::Util::app ;
}


my $game_state;
sub game_state {

    unless ( $ZT::Util::game_state )
    {

        $ZT::Util::game_state = ZT::State::Game->new();        

    }

    return $ZT::Util::game_state;

}


1;
