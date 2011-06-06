use Modern::Perl;
use Test::More;

use ZT;
use ZT::Actor;
use ZT::Actor::Zombie;

my $zt = ZT->instance();
my $actor = ZT::Actor->new();

is_deeply($actor->state(), {}, "State is default" );

$actor->attach( $zt ); 

is_deeply($actor, @{($zt->control->actors())}[0], "Actor in the actors" );

is( $actor->body(), undef );

my $z = ZT::Actor::Zombie->new();

done_testing;
