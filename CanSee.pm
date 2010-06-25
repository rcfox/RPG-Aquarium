package CanSee;
use Moose::Role;

#with 'PhysicalLocation';

has 'sight_range' =>
    (
        is => 'rw',
        isa => 'Int',
        default => 10,
    );

sub look
{
    my $self = shift;

    return grep { $self->distance($_) <= $self->sight_range } @{$self->container->all_contents};
}

1;
