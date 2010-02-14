package Goals::Wander;
use Moose;
use Goals::Move;

with 'Goal';

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;
    my $x;
    my $y;
    do
    {
        $x = (int(rand(3))-1)*int(rand(10))+$owner->x;
        $y = (int(rand(3))-1)*int(rand(10))+$owner->y;
    } while($owner->container->check_collision($x,$y));

    $owner->add_goal(new Goals::Move(x=>$x,y=>$y));
}

__PACKAGE__->meta->make_immutable;
1;
