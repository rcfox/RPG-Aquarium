package Monster;
use Moose;

with 'Living', 'Moves', 'Fighter', 'ExplodesOnDeath', 'BadGuy',
    'GoalOriented', 'Drawable';

 __PACKAGE__->meta->make_immutable;
1;
