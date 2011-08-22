package ZTx::Level;
use Moose;
use MooseX::Storage;
with Storage( 'format' => 'JSON', 'io' => 'File' );

has 'width'   => ( is => 'rw', isa => 'Int' );
has 'height'  => ( is => 'rw', isa => 'Int' );
has 'walls'   => ( is => 'rw', isa => 'ArrayRef[ArrayRef[Int]]' );
has 'zombies' => ( is => 'rw', isa => 'ArrayRef[ArrayRef[Int]]' );
has 'win'     => ( is => 'rw', isa => 'Int' );
has 'classes' => ( is => 'rw', isa => 'HashRef' );

__PACKAGE__->meta->make_immutable;

package main;
use strict;
use warnings;

use lib 'lib';
use ZT::Util;
use Data::Dumper;

my $file = $ZT::Util::data_dir . "/level1.json";

my $ztx_level = ZTx::Level->load( $file );

warn Dumper $ztx_level;
