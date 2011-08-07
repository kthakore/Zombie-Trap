package Zombie;
use FindBin;
use SDL::Rect;
use SDLx::Surface; 
use SDLx::Sprite::Animated;
use Game::Util;


our $width   = 16;
our $height  = 25;

our $surface = SDLx::Surface->load("$FindBin::Bin/../data/zombie.bmp");

sub _sprite {
    return SDLx::Sprite::Animated->new(
            surface         => $Zombie::surface,
            alpha_key       => 0x0000FF,
            step_x          => 63,
            step_y          => 65,
            ticks_per_frame => 10,
            sequences       => {
            left  => [ [ 0, 0 ], [ 1, 0 ], [ 2, 0 ], [ 3, 0 ] ],
            right => [ [ 0, 1 ], [ 1, 1 ], [ 2, 1 ], [ 3, 1 ] ],
            },
            rect     => SDL::Rect->new( 26, 21, $Zombie::width, $Zombie::height ),
            clip     => SDL::Rect->new( 26, 21, $Zombie::width, $Zombie::height ),
            sequence => 'right',
            );

}


sub new {
    my ($class, @args) = @_;

    my $self = bless {@args}, $self;

    croak "Need world for zombie; to be in" unless $self->{world}; 
    croak "Need dims for zombie;" unless $self->{dims}; 

    my ( $x, $y ) = @_;

    my ( $w, $h ) = map { Game::Util::s2w($_) } ( $Zombie::width, $Zombie::height );
    my ( $hx, $hy ) = ( $w / 2.0, $h / 2.0 );

    $self->{body} =
        Game::Util::make_body( $self->{world}, $x + $hx, $y + $hy, dynamic => 1, fixedRotation => 1 );
    $self->{shape}     = Game::Util::make_rect( $w, $h );
    $self->{color}     = 0xDDDDDDFF;
    $self->{direction} = 1;
    $self->{sprite}    = _sprite();
    Game::Util::make_fixture( @zombie{qw( body shape )} );

    $self->{body}->SetUserData(
            {   self => $self,

# Contact listener callback.
# Reverses the zombie's direction when appropriate.
            cb => sub {
            my ($other) = @_;

            my $zc = $self->{body}->GetWorldCenter();

# Don't reverse direction if the zombie falls on a wall.
#if ( $other{body}->GetType() == Box2D::b2_staticBody ) {
#$other{shape} = $other{body}->GetUserData();
#}
            return if Game::Util::is_above( $zc, $other );

# Don't reverse direction if the zombie is moving slowly.
            my $v = $self->{body}->GetLinearVelocity();
            return if abs( $v->x ) < 0.1;

            $self->{direction} *= -1;

            $self->{sprite}
            ->sequence( $self->{direction} == 1 ? 'right' : 'left' );
            }
            }
    );

    return $self;
}



1;
