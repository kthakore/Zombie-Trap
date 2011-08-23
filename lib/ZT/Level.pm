package ZT::Level;
use Modern::Perl;
use Carp;
use Moose;
use MooseX::Storage;
use Data::Dumper;
with Storage( 'format' => 'JSON', 'io' => 'File' );
use namespace::autoclean;

use ZT::Util;
use ZT::Object::Wall;
use ZT::Object::Town;
use ZT::Actor::Zombie; 
use ZT::State::Level;

use SDLx::Surface; 


has 'width'   => ( is => 'rw', isa => 'Int', required => 1);
has 'height'  => ( is => 'rw', isa => 'Int', required => 1);
has 'walls'   => ( is => 'rw', isa => 'ArrayRef[ArrayRef[Int]]' );
has 'zombies' => ( is => 'rw', isa => 'ArrayRef[ArrayRef[Int]]' );
has 'win'     => ( is => 'rw', isa => 'Int' );
has 'classes' => ( is => 'rw', isa => 'HashRef' );
has 'town'    => ( is => 'rw', isa => 'HashRef' );

# Prepared attributes
has 'surface' => ( is => 'rw', isa => 'SDLx::Surface' );
has 'prepared_walls' => (is => 'rw', isa => 'ArrayRef[ZT::Object::Wall]');
has 'prepared_zombies' => (is => 'rw', isa => 'ArrayRef[ZT::Actor::Zombie]');
has 'prepared_town' => ( is => 'rw', isa => 'ZT::Object::Town');

has 'state' => ( is => 'rw', isa => 'ZT::State::Level', default => sub{ ZT::State::Level->new() } );


sub prepare
{
    my $class = shift;
    my $name = shift;
    my $world = shift; 

    croak "Need world for ZT::Level" unless $world;

    my $self = $class->load( $name );
    # Process the loaded class into a level 

    # make the surface
    $self->surface( SDLx::Surface->new( 
        width => $self->width,
        height => $self->height
    ) );

   
    
    my @walls; 

    # prepare the walls and zombie loaders
    foreach( @{ $self->walls } )
    {
        my @dim = map { ZT::Util::s2w($_) } @$_;
        push @walls, ZT::Object::Wall->new( world => $world, dims => \@dim );
    }
    $self->prepared_walls( \@walls );

    my @zombies;

    foreach ( @{ $self->zombies } )
    {
        my @loc = map { ZT::Util::s2w($_) } @$_;
        push @zombies, ZT::Actor::Zombie->new( world=> $world, dims => \@loc);
    }

    $self->prepared_zombies( \@zombies );

    my @loc = map { ZT::Util::s2w($_) } @{$self->town->{location}}; 
    $self->prepared_town( ZT::Object::Town->new( world => $world, dims => \@loc) );

    # Setup State 

    return $self;
};

sub draw 
{
    my $self = shift; 
    my $app = $self->surface();
    my @walls = @{$self->prepared_walls};
    my @zombies = @{$self->prepared_zombies};

        $app->draw_rect( undef, 0x202020FF );
        $_->draw($app)   foreach @walls;
        $_->draw($app) foreach @zombies;

        $self->prepared_town->draw($app);

        $app->update();
 
}


# Do stuff with level that makes it change the state? 
sub update {


}

__PACKAGE__->meta->make_immutable;
