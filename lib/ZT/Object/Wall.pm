package ZT::Object::Wall;
use Modern::Perl;
use Carp;
use ZT::Util;
use Data::Dumper;

sub new {
    my ($class, @args) = @_;

    my $self = bless( {@args}, $class);

    croak "Need world for wall to be in" unless $self->{world}; 
    croak "Need dims for wall" unless $self->{dims}; 

    my ( $x, $y, $w, $h ) = @{ $self->{dims} };

    my ( $hx, $hy ) = ( $w / 2.0, $h / 2.0 );

    $self->{body} =  ZT::Util::make_body( $self->{world}, $x + $hx, $y + $hy );
    $self->{shape} = ZT::Util::make_rect( $w,       $h );
    $self->{color} = 0x035307FF;
    ZT::Util::make_fixture( $self->{body}, $self->{shape} );

# Store the shape for use in the contact listener.
# b2Fixture::GetShape() could be used in the contact listener, but
# it returns a b2Shape, and a b2PolygonShape is needed.
    $self->{body}->SetUserData( { self => $self } );

    return $self;

} 

sub draw {
    my ($self, $app) = @_;
    ZT::Util::draw_polygon($app, $self);
}

1;

