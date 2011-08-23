package ZT::State::Game;
use Modern::Perl;
use Carp;
use Moose;
use BoxSDL::Controller;

# Running, Loss, Won
has 'status' => ( is => 'rw', isa => 'Str', default => 'running' );

# total score
has 'score' => (is => 'rw', isa => 'Int', default => 0 );

has 'levels' => (is => 'rw', isa => 'ArrayRef[Str]', default => sub {

        my $level_glob = $ZT::Util::data_dir."*.json";
        my @levels = glob $level_glob;
        return \@levels;

        } );

has 'level_index' => (is =>'rw', isa => 'Int', default => 0);

has 'current_level' => ( is => 'rw', isa => 'ZT::Level' );

has 'controller' => ( is => 'rw', isa => 'BoxSDL::Controller', required => 1);

sub next_level 
{
    my $self = shift;
    my $world = $self->controller->world();

    my $file =  $self->levels->[ $self->level_index ];

    return 0 unless $file;

    $self->current_level( ZT::Level->prepare( $file, $world ) );

    $self->level_index( $self->level_index+ 1 );

    return $self->current_level();
}

# Runs every frame
sub update
{
    my $self = shift;

    #If Running update Level State
    if( $self->status eq 'running')
    {
        $self->current_level->state->update();

    }

}

# Runs every 'meaning full' collisions
sub manage_state
{
    my $self = shift;


    # Check current level for dead townspeople, or converted

}


__PACKAGE__->meta->make_immutable; 
