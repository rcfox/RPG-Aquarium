package Goals::MoveToTarget;
use Moose;

with 'Goal', 'PhysicalLocation';

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
    
    if ($owner->distance($self->target) < 2 || !$owner->container->contains_object($self->target))
    {
        $owner->complete_goal;
        return;
    }

    my $moved = $owner->pathfind($self->target->x,$self->target->y);
    if (!$moved)
    {
        my ($x,$y) = $self->find_alternate();
        $owner->complete_goal;
        $owner->add_goal(new Goals::Move(x=>$x,y=>$y));
    }
}

sub find_alternate
{
    my $self = shift;
    my $owner = $self->owner;
    my $pi = 3.14159265;

    my @possibilities;
    
    for (my $r = 0; $r < 10; ++$r)
    {
        for (my $theta = 0; $theta < 2*$pi; $theta += $pi/4)
        {
            my $x = $self->target->x + int($r*cos($theta));
            my $y = $self->target->y + int($r*sin($theta));
            if (!$owner->container->check_collision($x,$y))
            {
                push @possibilities, [$x,$y];
            }
        }
        last if (@possibilities);
    }

    @possibilities = sort { $owner->distance($a->[0],$a->[1]) <=> $owner->distance($b->[0],$b->[1]) } @possibilities;

    return @{$possibilities[0]};
}

__PACKAGE__->meta->make_immutable;
1;
