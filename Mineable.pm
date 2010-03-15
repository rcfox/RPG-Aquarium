package Mineable;
use Moose::Role;

use Ore;

with 'PhysicalLocation';

has 'content' =>
    (
        is => 'rw',
        isa => 'ArrayRef[TradeGood]',
        default => sub{ my @arr; foreach(1..int(rand(10)+2)){ push @arr, new Ore;} \@arr; },
    );

has 'delay' =>
    (
        is => 'rw',
        isa => 'Int',
        default => sub { shift()->_next_delay; },
    );

has 'delay_count' =>
    (
        is => 'rw',
        isa => 'Int',
        default => 0,
    );


sub mine
{
    my $self = shift;
    if ($self->delay_count < $self->delay)
    {
        $self->delay_count($self->delay_count + 1);
        return undef;
    }
    $self->delay_count(0);
    $self->_next_delay();
    
    my $toreturn = shift @{$self->content};
    if (@{$self->content} == 0)
    {
        $self->container->remove_content($self);
    }
    return $toreturn;
}

sub _next_delay
{
    my $self = shift;
    $self->delay(int(rand(5)));
}

1;
