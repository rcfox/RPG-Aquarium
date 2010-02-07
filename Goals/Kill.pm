package Goals::Kill;
use Moose;
use Goals::Move;

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

    if ($owner->distance($target) <= $owner->attack_range)
    {
        $owner->attack($target);
    }
    else
    {
        $owner->add_goal(new Goals::Move(x=>$target->x,y=>$target->y));
        $owner->current_goal->do_goal;
    }

    if ($target->hp <= 0)
    {
        $owner->complete_goal;
    }
}

1;
