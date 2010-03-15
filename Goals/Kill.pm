package Goals::Kill;
use Moose;
use Goals::MoveToTarget;

with 'Goal';

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
    my $target = $self->target;

    if (!$owner->container->contains_object($target) || $target->hp <= 0)
    {
        $owner->complete_goal;
        $owner->current_goal->do_goal;
        return;
    }

    if ($owner->distance($target) <= $owner->attack_range)
    {
        $owner->attack($target);
    }
    else
    {
        $owner->add_goal(new Goals::MoveToTarget(target=>$target));
        $owner->current_goal->do_goal;
    }
}

 __PACKAGE__->meta->make_immutable;
1;
