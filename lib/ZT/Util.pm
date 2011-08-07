package ZT::Util;
use Modern::Perl; 
use Box2D;
use SDL::GFX::Primitives; 

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
    my ($app, $polygon) = @_;

    my ( $body, $shape, $color ) = @$polygon{qw( body shape color )};

    my @verts = map { $body->GetWorldPoint( $shape->GetVertex($_) ) }
        ( 0 .. $shape->GetVertexCount() - 1 );

    my @vx = map { ZT::Util::w2s( $_->x ) } @verts;
    my @vy = map { ZT::Util::w2s( $_->y ) } @verts;

    SDL::GFX::Primitives::filled_polygon_color( $app, \@vx, \@vy,
        scalar @verts, $color );
}


1;
