package Goals::Mine;
use Moose;
use Goals::Move;

with 'Goal';

has 'target' =>
    (
        is => 'rw',
        isa => 'PhysicalLocation',
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
        my $mined = $target->mine();

        if ($mined)
        {
            $owner->add_item($mined);
            print $owner->name.": mined some ore.\n";
            $owner->complete_goal;
            $owner->complete_goal;
        }
        else
        {
            print $owner->name.": mined, but got nothing.\n";
        }
    }
    else
    {
        $owner->add_goal(new Goals::MoveToTarget(target=>$target));
        $owner->current_goal->do_goal;
    }
    
}

__PACKAGE__->meta->make_immutable;
1;
