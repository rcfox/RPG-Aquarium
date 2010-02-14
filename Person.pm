package Person;
use Moose;

with 'Living', 'Moves', 'ExperienceLevel', 'Fighter', 'GoodGuy',
    'GoalOriented', 'HasInventory', 'Drawable';

 __PACKAGE__->meta->make_immutable;
1;
