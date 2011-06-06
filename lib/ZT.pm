package ZT;
use Modern::Perl;
use MooseX::Singleton;

use ZT::View;
use ZT::Control;

our $VERSION = '0.01';

has 'view' =>
  ( is => 'rw', isa => 'ZT::View', default => sub { ZT::View->new() } );
has 'control' =>
  ( is => 'rw', isa => 'ZT::Control', default => sub { ZT::Control->new() } );

sub start {

    my $self = shift;

    $self->view->run();

}

1;

=pod 

=head1 NAME

ZT - Game initializer 

=head1 METHOD

=head2 start

	my $new = ZT->new();
	ZT->start();

Running the code.

=cut 
