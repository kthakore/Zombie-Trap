package ZT::State::Level;
use Modern::Perl;
use Carp;
use Moose;
use SDL;

has 'zombies' => ( is => 'rw', isa => 'Int' );
has 'townspeople' => ( is => 'rw', isa => 'Int' ); 
has 'town_health' => ( is => 'rw', isa => 'Int', default => 100 );
has 'start_time' => ( is => 'rw', isa => 'Int', default => SDL::get_ticks() );
has 'current_time' => ( is => 'rw', isa => 'Int', default => SDL::get_ticks() );


sub update
{
    my $self = shift;

   $self->current_time( SDL::get_ticks() );
}

__PACKAGE__->meta->make_immutable;
