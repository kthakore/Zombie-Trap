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
    my $hud_offset     = 50;
    
    if( $y >= $hud_offset && $y <= $hud_offset + $self->{h} 
     && $x >= $hud_offset && $x <= $hud_offset + $self->{w} ) {
        
        $x = int(($x - $hud_offset) / 20);
        $y = int(($y - $hud_offset) / 20);
    
        # up + left
        if( ($x == 0 && $y <= 1) || ($x <= 1 && $y == 0) ) {
            $self->{x} -= $delta * ($self->{w} / 40);
            $self->{y} -= $delta * ($self->{w} / 40);
        }
        
        # up + right
        elsif( ($x == 19 && $y <= 1) || ($x >= 18 && $y == 0) ) {
            $self->{x} += $delta * ($self->{w} / 40);
            $self->{y} -= $delta * ($self->{w} / 40);
        }
        
        # down + left
        elsif( ($x == 0 && $y >= 13) || ($x <= 1 && $y == 14) ) {
            $self->{x} -= $delta * ($self->{w} / 40);
            $self->{y} += $delta * ($self->{w} / 40);
        }
        
        # down + right
        elsif( ($x == 19 && $y >= 13) || ($x >= 18 && $y == 14) ) {
            $self->{x} += $delta * ($self->{w} / 40);
            $self->{y} += $delta * ($self->{w} / 40);
        }
        
        # left
        elsif( $x == 0 ) {
            $self->{x} -= $delta * ($self->{w} / 40);
        }
        
        # up
        elsif( $y == 0 ) {
            $self->{y} -= $delta * ($self->{w} / 40);
        }
        
        # right
        elsif( $x == 19 ) {
            $self->{x} += $delta * ($self->{w} / 40);
        }
        
        # down
        elsif( $y == 14 ) {
            $self->{y} += $delta * ($self->{w} / 40);
        }
    }
}

sub update_view {
    my ($self, $map_surface) = @_;

# The camera determines offset of the surface to show on here 
    my $src_rect = [$self->{x}, $self->{y}, $self->{w}, $self->{h}];

    my $hud_offset = 50;
    $self->{app}->draw_rect([$hud_offset, $hud_offset ,$self->{w}, $self->{h}], 0x000000FF);
    
    $self->{app}->blit_by( $map_surface, $src_rect, [$hud_offset,$hud_offset, 0, 0] );

    # "widgets" for scrolling, can be removed or made nicer
    my $scroll_area = SDLx::Surface->new( width => $self->{w}, height => $self->{h}, color => 0xFFFFFF20 );
    $scroll_area->draw_rect( [ $self->{w} * 0.05, $self->{w} * 0.05, $self->{w} * 0.90, $self->{h} - $self->{w} * 0.10 ], 0 );
    $scroll_area->draw_rect( [ 0, $self->{w} * 0.10, $self->{w}, $self->{w} * 0.01 ], 0 );
    $scroll_area->draw_rect( [ 0, $self->{h} - $self->{w} * 0.11, $self->{w}, $self->{w} * 0.01 ], 0 );
    $scroll_area->draw_rect( [ $self->{w} * 0.10, 0, $self->{w} * 0.01, $self->{h} ], 0 );
    $scroll_area->draw_rect( [ $self->{w} * 0.89, 0, $self->{w} * 0.01, $self->{h} ], 0 );
    $scroll_area->draw_line( [ $self->{w} * 0.015, $self->{h} / 2 ],
                             [ $self->{w} * 0.025, $self->{h} / 2 - $self->{w} * 0.01 ], 0xFFFFFFAA, 0 );
    $scroll_area->draw_line( [ $self->{w} * 0.015, $self->{h} / 2 ],
                             [ $self->{w} * 0.025, $self->{h} / 2 + $self->{w} * 0.01 ], 0xFFFFFFAA, 0xff );
    $scroll_area->draw_line( [ $self->{w} * 0.015 + $self->{w} * 0.01, $self->{h} / 2 ],
                             [ $self->{w} * 0.025 + $self->{w} * 0.01, $self->{h} / 2 - $self->{w} * 0.01 ], 0xFFFFFFAA, 0 );
    $scroll_area->draw_line( [ $self->{w} * 0.015 + $self->{w} * 0.01, $self->{h} / 2 ],
                             [ $self->{w} * 0.025 + $self->{w} * 0.01, $self->{h} / 2 + $self->{w} * 0.01 ], 0xFFFFFFAA, 0 );
    $self->{app}->blit_by( $scroll_area, [ 0, 0, $self->{w}, $self->{h} ], [ $hud_offset, $hud_offset, 0, 0 ] );

    $self->{app}->update();
}




1;
