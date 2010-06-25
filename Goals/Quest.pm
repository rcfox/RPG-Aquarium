package Goals::Quest;
use Moose;

with 'Goal';

has 'giver' =>
    (
        is => 'rw',
        isa => 'Person',
        required => 1,
    );

has 'stage' =>
    (
        is => 'rw',
        isa => 'Int',
        default => 1,
    );

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;

    if ($owner->distance($self->giver) < 2)
    {
        if ($self->stage == 1)
        {
            $self->stage(2);
            $owner->add_goal(new Goals::CreateItem);
        }
        elsif ($self->stage == 2)
        {
            $self->stage(1);
            $owner->add_goal(new Goals::Find(find=>'BadGuy',
                                             and_do=>sub{new Goals::Kill(target=>shift())},
                                             or_else=>sub{new Goals::Wander()},
                                             times=>3));
        }
    }
    else
    {
        $owner->add_goal(new Goals::MoveToTarget(target=>$self->giver));
    }
}

1;
