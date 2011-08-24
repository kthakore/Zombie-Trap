package ZT::State::Level;
use Modern::Perl;
use Carp;
use Moose;
use SDL;
use ZT::Util;
use Data::Dumper;

has 'zombies' => ( is => 'rw', isa => 'Int' );
has 'townspeople' => ( is => 'rw', isa => 'Int' ); 
has 'start_time' => ( is => 'rw', isa => 'Int', default => SDL::get_ticks() );
has 'current_time' => ( is => 'rw', isa => 'Int', default => SDL::get_ticks() );


sub update
{
    my $self = shift;

    my $level = ZT::Util::game_state->current_level();
    
    if( $level->prepared_town->health() < 0 )
    {
        warn "Town Defeated!!!";
        
        ZT::Util::game_state->next_level( );
        ZT::Util::game_state->controller->stop();
    }

   $self->current_time( SDL::get_ticks() );
}

__PACKAGE__->meta->make_immutable;
