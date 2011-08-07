package ZT::Camera;
use SDL;
use SDL::Video;
use SDLx::App; 

sub new {

    my $self = bless { x=> 0, y => 0, w=>400, h=> 300, c_x => 200, c_y => 150 }, $_[0];

    $self->{app}  = SDLx::App->new(
            width  => $self->{w}+100,
            height => $self->{h}+100,
            flags  => SDL_DOUBLEBUF | SDL_HWSURFACE,
            );


    return $self; 
}

sub scroll {
    my ($self, $m_x, $m_y ) = @_;

# Get the direction and just keep moving that way
    my( $x, $y ) = (0, 0);

    if( $m_x > ($self->{w}/2) ) { $x = 1 } else{ $x = -1 }
    if( $m_y > ($self->{h}/2) ) { $y = 1 } else{ $y = -1 }

    my $mag = 1;
    return $self->move_rel( $x * $mag, $y * $mag);

}

sub move_rel {
    my ($self, $m_x, $m_y ) = @_;

    return $self->move_to( $self->{c_x} + $m_x, $self->{c_y} + $m_y );
}

sub move_to {
    my ($self, $m_x, $m_y ) = @_;

    $self->{x} = $m_x - $self->{w}/2; 
    $self->{y} = $m_y - $self->{h}/2; 

    $self->{c_x} = $m_x;
    $self->{c_y} = $m_y;
    return $self;

}

sub update_view {
    my ($self, $map_surface) = @_;

# The camera determines offset of the surface to show on here 
    my $src_rect = [$self->{x}, $self->{y}, $self->{w}, $self->{h}];

    $self->{app}->draw_rect([50, 50 ,$self->{w}, $self->{h}], 0x000000FF);
    $self->{app}->blit_by( $map_surface, $src_rect, [50,50, $self->{w}, $self->{h}] );

    $self->{app}->update();
}




1;
