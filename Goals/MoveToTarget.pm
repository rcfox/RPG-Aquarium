package Goals::MoveToTarget;
use Moose;

with 'Goal', 'PhysicalLocation';

has 'target' =>
    (
        is => 'rw',
        isa => 'Living',
        required => 1,
    );

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;
    my $moved = $owner->pathfind($self->target->x,$self->target->y);

    if (!$moved || $self->target->hp <= 0 || $owner->distance($self->target) == 1)
    {
        $owner->complete_goal;
    }
}

__PACKAGE__->meta->make_immutable;
1;
