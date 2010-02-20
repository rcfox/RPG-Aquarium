package Goal;
use Moose::Role;

use GoalOriented;

has 'subgoal' =>
    (
        is => 'rw',
        isa => 'Goal',
    );

has 'owner' =>
    (
        is => 'rw',
        isa => 'GoalOriented',
    );

requires 'do_goal';

1;
