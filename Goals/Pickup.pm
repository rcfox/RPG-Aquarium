package Goals::Pickup;
use Moose;
use Goals::MoveToTarget;
use Goals::Unload;

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

    if (!$owner->container->contains_object($target))
    {
        $owner->complete_goal;
        $owner->current_goal->do_goal;
    }

    if ($owner->distance($target) < 2)
    {
        $owner->add_item($target);
        $target->container->remove_content($target);
        print $owner->name.": picked up target.\n";
        $owner->complete_goal;

        $owner->add_goal(new Goals::Unload);
        $owner->current_goal->do_goal;
    }
    else
    {
        $owner->add_goal(new Goals::MoveToTarget(target=>$target));
        $owner->current_goal->do_goal;
    }
}

 __PACKAGE__->meta->make_immutable;
1;
