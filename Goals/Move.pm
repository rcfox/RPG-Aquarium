package Goals::Move;
use Moose;

with 'Goal', 'PhysicalLocation';

has 'x' =>
    (
        is => 'rw',
        isa => 'Int',
        required => 1,
    );

has 'y' =>
    (
        is => 'rw',
        isa => 'Int',
        required => 1,
    );

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;
    my $moved = $owner->pathfind($self->x,$self->y);

    if (!$moved || $self->distance($owner) == 1)
    {
        $owner->complete_goal;
    }
}

1;
