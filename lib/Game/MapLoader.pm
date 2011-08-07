package Game::MapLoader;
use Modern::Perl;
use FindBin;
use YAML::Tiny;

sub load {
    my $config = YAML::Tiny->read("$FindBin::Bin/../data/level1.yaml")->[0];
    my ( $map_w, $map_h ) = @$config{qw( width height )};


}




1;
