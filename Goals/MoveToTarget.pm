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
    
    if ($owner->distance($self->target) < 2 || !$owner->container->contains_object($self->target))
    {
        $owner->complete_goal;
    }

    my $moved = $owner->pathfind($self->target->x,$self->target->y);

    my $pi = 3.14159265;
    if(!$moved)
    {
        for(my $r = 0; $r < 10; ++$r)
        {
            for (my $theta = 0; $theta < 2*$pi; $theta += $pi/4)
            {
                my $x = $self->target->x + int($r*cos($theta));
                my $y = $self->target->y + int($r*sin($theta));
                if (!$owner->container->check_collision($x,$y))
                {
                    $owner->add_goal(new Goals::Move(x=>$x,y=>$y));
                    return;
                }
            }
        }
    }
}

__PACKAGE__->meta->make_immutable;
1;
