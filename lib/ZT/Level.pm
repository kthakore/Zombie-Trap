package ZT::Level;
use Modern::Perl;
use FindBin;
use YAML::Tiny;
use SDLx::Surface; 
use Carp;

use ZT::Util;
use ZT::Object::Wall;
use ZT::Actor::Zombie;

sub load {
    my ( $class, @args ) = @_;
    my $self = bless {@args}, $class;

    croak "Need world for ZT::Level" unless $self->{world};
    croak "Need name for ZT::Level" unless $self->{name};

    $self->{config} = YAML::Tiny->read("$FindBin::Bin/../data/".$self->{name}.".yaml")->[0];

    croak "Couldn't load ".$self->{name}." from $FindBin::Bin/../data/".$self->{name}.".yaml : $!" unless $self->{config};

    $self->{surface} = SDLx::Surface->new(
            width => $self->{config}->{width},
            height => $self->{config}->{height}
            );

    my @walls;
    my @zombies;


    foreach ( @{ $self->{config}->{walls} } ) {
        my @dim = map { ZT::Util::s2w($_) } split /\s+/, $_;
        push @walls, ZT::Object::Wall->new( world => $self->{world}, dims => \@dim );
    }

    foreach ( @{ $self->{config}->{zombies} } ) {
        my @loc =  map { ZT::Util::s2w($_) } split /\s+/, $_; 
        push @zombies, ZT::Actor::Zombie->new( world=> $self->{world}, dims => \@loc);
    }

    $self->{walls} = \@walls;
    $self->{zombies} = \@zombies; 

    return $self;
}

sub surface {

    $_[0]->{surface}

}

sub walls {

    $_[0]->{walls}

}

sub zombies {

    $_[0]->{zombies}

}


sub draw {
    my $self = shift;
    my $app = $self->{surface};
    my @walls = @{$self->{walls}};
    my @zombies = @{$self->{zombies}};

        $app->draw_rect( undef, 0x202020FF );
        $_->draw($app)   foreach @walls;
        $_->draw($app) foreach @zombies;

        $app->update();
    
    
}



1;
