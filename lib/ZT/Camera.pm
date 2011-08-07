package ZT::Camera;
use SDL;
use SDL::Event;
use SDL::Events;
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

sub move {
    my ($self, $delta) = @_;
    my ($mask, $x, $y) = @{ SDL::Events::get_mouse_state( ) };
    
    # if mouse is in sensitive areas -> scroll in that direction
    # to left
    if( $x >= 50 && $x <= 50 + $self->{w} * 0.05 ) {
        $self->{x}    -= $delta * 10;
    }
    # to right
    elsif( $x >= 50 + $self->{w} * 0.95 && $x <= 50 + $self->{w} ) {
        $self->{x}    += $delta * 10;
    }
    
    # up
    if( $y >= 50 && $y <= 50 + $self->{w} * 0.05 ) {
        $self->{y}    -= $delta * 10;
    }
    # down
    elsif( $y >= 50 + $self->{h} - $self->{w} * 0.05 && $y <= 50 + $self->{h} ) {
        $self->{y}    += $delta * 10;
    }
}

sub update_view {
    my ($self, $map_surface) = @_;

# The camera determines offset of the surface to show on here 
    my $src_rect = [$self->{x}, $self->{y}, $self->{w}, $self->{h}];

    $self->{app}->draw_rect([50, 50 ,$self->{w}, $self->{h}], 0x000000FF);
    
    $self->{app}->blit_by( $map_surface, $src_rect, [50,50, 0, 0] );

    # "widgets" for scrolling, can be removed or made nicer
    my $scroll_area = SDLx::Surface->new( width => $self->{w}, height => $self->{h}, color => 0xFFFFFF42 );
    $scroll_area->draw_rect( [ $self->{w} * 0.05, $self->{w} * 0.05, $self->{w} * 0.90, $self->{h} - $self->{w} * 0.10 ], 0 );
    $scroll_area->draw_rect( [ 0, $self->{w} * 0.10, $self->{w}, $self->{w} * 0.01 ], 0 );
    $scroll_area->draw_rect( [ 0, $self->{h} - $self->{w} * 0.11, $self->{w}, $self->{w} * 0.01 ], 0 );
    $scroll_area->draw_rect( [ $self->{w} * 0.10, 0, $self->{w} * 0.01, $self->{h} ], 0 );
    $scroll_area->draw_rect( [ $self->{w} * 0.89, 0, $self->{w} * 0.01, $self->{h} ], 0 );
    $self->{app}->blit_by( $scroll_area, [ 0, 0, $self->{w}, $self->{h} ], [ 50, 50, 0, 0 ] );

    $self->{app}->update();
}




1;
