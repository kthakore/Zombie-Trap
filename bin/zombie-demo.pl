use Modern::Perl;
use SDL;
use SDL::Rect;
use SDL::Video;
use SDLx::App;
use SDLx::Sprite::Animated;
use SDLx::Surface;
use Box2D;
use FindBin;
use YAML::Tiny;

my $config = YAML::Tiny->read("$FindBin::Bin/../data/level1.yaml")->[0];

my ( $width, $height ) = @$config{qw( width height )};

my $ppm = 15.0;
my $mpp = 1.0 / $ppm;

my $fps      = 60.0;
my $timestep = 1.0 / $fps;
my $vIters   = 10;
my $pIters   = 10;

my $app = SDLx::App->new(
    width  => $width,
    height => $height,
    dt     => $timestep,
    min_t  => $timestep / 2,
    flags  => SDL_DOUBLEBUF | SDL_HWSURFACE,
    eoq    => 1,
);

my $gravity = Box2D::b2Vec2->new( 0, 9.8 );
my $world = Box2D::b2World->new( $gravity, 1 );

my $zombieSurface = SDLx::Surface->load( "$FindBin::Bin/../data/zombie.bmp" );

my @walls;
my @zombies;

foreach ( @{ $config->{walls} } ) {
    push @walls, make_wall( map { s2w($_) } split /\s+/, $_ );
}

foreach ( @{ $config->{zombies} } ) {
    push @zombies, make_zombie( map { s2w($_) } split /\s+/, $_ );
}

my $listener = Box2D::PerlContactListener->new();

$listener->SetBeginContactSub(
    sub {
        my ($contact) = @_;

        my $bodyA = $contact->GetFixtureA->GetBody();
        my $bodyB = $contact->GetFixtureB->GetBody();

        foreach ( [ $bodyA, $bodyB ], [ $bodyB, $bodyA ] ) {
            my $sub = $_->[0]->GetUserData();
            $sub->( body => $_->[1] ) if ref $sub eq 'CODE';
        }
    }
);

$world->SetContactListener($listener);

$app->add_show_handler(
    sub {
        $world->Step( $timestep, $vIters, $pIters );

        $app->draw_rect( undef, 0x000000FF );

        move_zombie($_) foreach @zombies;

        draw_wall($_)   foreach @walls;
        draw_zombie($_) foreach @zombies;

        $app->update();
    }
);

$app->run();

# screen to world
sub s2w { return $_[0] * $mpp }

# world to screen
sub w2s { return $_[0] * $ppm }

sub make_wall {
    my ( $x, $y, $w, $h ) = @_;

    my ( $hx, $hy ) = ( $w / 2.0, $h / 2.0 );

    my %wall = (
        body  => make_body( $x + $hx, $y + $hy ),
        shape => make_rect( $w,       $h ),
        color => 0x00FF00FF,
    );
    make_fixture( @wall{qw( body shape )} );

    # Store the shape for use in the contact listener.
    # b2Fixture::GetShape() could be used in the contact listener, but
    # it returns a b2Shape, and a b2PolygonShape is needed.
    $wall{body}->SetUserData( $wall{shape} );

    return \%wall;
}

sub make_zombie {
    my ( $x, $y ) = @_;

    my ( $w, $h ) = map { s2w($_) } ( 10, 30 );
    my ( $hx, $hy ) = ( $w / 2.0, $h / 2.0 );

    my %zombie = (
        body =>
            make_body( $x + $hx, $y + $hy, dynamic => 1, fixedRotation => 1 ),
        shape     => make_rect( $w, $h ),
        color     => 0xDDDDDDFF,
        direction => 1,
        sprite    => make_zombie_sprite(),
    );
    make_fixture( @zombie{qw( body shape )} );

    # Contact listener callback.
    $zombie{body}->SetUserData(

        # Reverse the zombie's direction when appropriate.
        sub {
            my (%other) = @_;

            my $zc = $zombie{body}->GetWorldCenter();

            # Don't reverse direction if the zombie falls on a wall.
            if ( $other{body}->GetType() == Box2D::b2_staticBody ) {
                $other{shape} = $other{body}->GetUserData();
                return if is_above( $zc, \%other );
            }

            # Don't reverse direction if the zombie is moving slowly.
            my $v = $zombie{body}->GetLinearVelocity();
            return if abs( $v->x ) < 0.1;

            $zombie{direction} *= -1;
        }
    );

    return \%zombie;
}

sub make_body {
    my ( $x, $y, %args ) = @_;
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

# Apply an impulse the zombie when it's moving slowly.
sub move_zombie {
    my ($zombie) = @_;
    my $v = $zombie->{body}->GetLinearVelocity();
    if ( abs( $v->x ) < 1.0 && abs( $v->y ) < 0.01 ) {
        my $vx = $zombie->{direction} * (rand() * 2.0 + 2.0);
        my $i = Box2D::b2Vec2->new( $vx, 0.0 );
        my $p = $zombie->{body}->GetWorldCenter();
        $zombie->{body}->ApplyLinearImpulse( $i, $p );
    }
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

sub make_zombie_sprite {
    return SDLx::Sprite::Animated->new(
        surface => $zombieSurface,
        alpha_key => 0x0000FFFF,
        step_x => 63,
        step_y => 65,
        ticks_per_frame => 10,
        sequences => {
            left  => [ [0, 0], [1, 0], [2, 0], [3, 0] ],
            right => [ [0, 1], [1, 1], [2, 1], [3, 1] ],
        },
        rect => SDL::Rect->new( 16, 21, 16, 25 ),
    );
}

sub draw_wall {
    my ($wall) = @_;

    draw_polygon($wall);
}

sub draw_zombie {
    my ($zombie) = @_;

    draw_polygon($zombie);
}

sub draw_polygon {
    my ($polygon) = @_;

    my ( $body, $shape, $color ) = @$polygon{qw( body shape color )};

    my @verts = map { $body->GetWorldPoint( $shape->GetVertex($_) ) }
        ( 0 .. $shape->GetVertexCount() - 1 );

    my @vx = map { w2s( $_->x ) } @verts;
    my @vy = map { w2s( $_->y ) } @verts;

    SDL::GFX::Primitives::filled_polygon_color( $app, \@vx, \@vy,
        scalar @verts, $color );
}
