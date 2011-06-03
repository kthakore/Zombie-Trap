package ZT;
use Modern::Perl;
use ZT::View;
use ZT::Control;
use Moose; 
use Data::Dumper;

our $VERSION = '0.01';

has 'view' => ( is => 'rw', isa => 'ZT::View', default => sub{ ZT::View->new() });
has 'control' => ( is => 'rw', isa => 'ZT::Control', default => sub{ ZT::Control->new() });

sub start {

my $self = shift;

	$self->view->run();

}

1;