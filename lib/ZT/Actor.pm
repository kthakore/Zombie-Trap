package ZT::Actor;
use Modern::Perl;
use Moose;

has 'state' => ( is => 'rw', isa => 'HashRef', default => sub { {} } );

sub attach {
	my $self = shift;
	my $zt = shift;

	push (@{$zt->control->actors()}, $self );
}


1;

=pod 

=head1 NAME

ZT::Actor - Actor Class to hold states of objects

=head1 METHODS

=head2 attach

Attach the actor to ZT::Actor

	my $zt = ZT->new();
	$actor->attach($zt);

=cut 
