package GoalOriented;
use Moose::Role;

use Goal;

has 'goal_stack' =>
    (
        is => 'rw',
        isa => 'ArrayRef[Goal]',
        default => sub{[]},
    );

sub add_goal
{
    my $self = shift;
    my $goal = shift;

    unshift @{$self->goal_stack}, $goal;
    $goal->owner($self);
}

sub complete_goal
{
    my $self = shift;
    shift @{$self->goal_stack};
}

sub current_goal
{
    my $self = shift;
    return $self->goal_stack->[0];
}

sub do_goal
{
    my $self = shift;
    $self->current_goal->do_goal;
}

1;
