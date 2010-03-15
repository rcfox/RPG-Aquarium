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
            my $x = $self->x + int($r*cos($theta));
            my $y = $self->y + int($r*sin($theta));
            if (!$owner->container->check_collision($x,$y))
            {
                push @possibilities, [$x,$y];
            }
        }
    }

    @possibilities = sort { $owner->distance($a->[0],$a->[1]) <=> $owner->distance($b->[0],$b->[1]) } @possibilities;

    return @{$possibilities[0]};
}

__PACKAGE__->meta->make_immutable;
1;
