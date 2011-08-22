use lib 'lib';

package ZTx::Level;
use Carp;
use Moose;
use MooseX::Storage;
with Storage( 'format' => 'JSON', 'io' => 'File' );
use namespace::autoclean;

use ZT::Util;
use ZT::Object::Wall;
use ZT::Actor::Zombie; 

use SDLx::Surface; 


has 'width'   => ( is => 'rw', isa => 'Int', required => 1);
has 'height'  => ( is => 'rw', isa => 'Int', required => 1);
has 'walls'   => ( is => 'rw', isa => 'ArrayRef[ArrayRef[Int]]' );
has 'zombies' => ( is => 'rw', isa => 'ArrayRef[ArrayRef[Int]]' );
has 'win'     => ( is => 'rw', isa => 'Int' );
has 'classes' => ( is => 'rw', isa => 'HashRef' );

# Prepared attributes
has 'surface' => ( is => 'rw', isa => 'SDLx::Surface' );
has 'prepared_walls' => (is => 'rw', isa => 'ArrayRef[ZT::Object::Wall]');
has 'prepared_zombies' => (is => 'rw', isa => 'ArrayRef[ZT::Actor::Zombie]');


sub prepare
{
    my $class = shift;
    my $file = shift;
    my $world = shift; 

    croak "Need world for ZT::Level" unless $world;

    my $self = $class->load( $file );

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

        $app->update();
 
}

__PACKAGE__->meta->make_immutable;

package main;
use strict;
use warnings;

use ZT::Util;
use Data::Dumper;
use Box2D;

use SDL;
use SDLx::App;

my $app = SDLx::App->new();

my $file = $ZT::Util::data_dir . "/level1.json";
    my $gravity = Box2D::b2Vec2->new( 0, 9.8 );
    my $world = Box2D::b2World->new( $gravity, 1 );


my $ztx_level = ZTx::Level->prepare( $file, $world );

$ztx_level->draw()

