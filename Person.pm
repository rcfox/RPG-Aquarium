package Person;
use Moose;

with 'Living', 'Moves', 'ExperienceLevel', 'Fighter', 'GoodGuy',
    'GoalOriented', 'Drawable';

1;
