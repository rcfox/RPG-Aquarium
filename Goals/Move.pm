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

    if ($self->distance($owner) < 2)
    {
        $owner->complete_goal;
    }

    my $moved = $owner->pathfind($self->x,$self->y);

    my $pi = 3.14159265;
    if (!$moved)
    {
        for(my $r = 0; $r < 10; ++$r)
        {
            for (my $theta = 0; $theta < 2*$pi; $theta += $pi/4)
            {
                my $x = $self->x + int($r*cos($theta));
                my $y = $self->y + int($r*sin($theta));
                if (!$owner->container->check_collision($x,$y))
                {
                    $owner->complete_goal;
                    $owner->add_goal(new Goals::Move(x=>$x,y=>$y));
                    return;
                }
            }
        }
    }
}

__PACKAGE__->meta->make_immutable;
1;
