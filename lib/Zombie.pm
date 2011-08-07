package Zombie;
use FindBin;
use SDLx::Surface; 
use SDLx::Sprite::Animated;


our $width   = 16;
our $height  = 25;

our $surface = SDLx::Surface->load("$FindBin::Bin/../data/zombie.bmp");



1;
