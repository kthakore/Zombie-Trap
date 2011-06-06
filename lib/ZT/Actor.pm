package ZT::Actor;
use Modern::Perl;
use Moose;

has 'state' => ( is => 'rw', isa => 'HashRef', default => sub { { } } );

1;

=pod 

=head1 NAME

ZT::Actor - Actor Class to hold states of objects

=cut 
