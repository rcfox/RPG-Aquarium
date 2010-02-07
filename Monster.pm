package Monster;
use Moose;

with 'Living', 'Moves', 'Fighter', 'ExplodesOnDeath', 'BadGuy',
    'GoalOriented', 'Drawable';

1;
