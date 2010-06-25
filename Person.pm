package Person;
use Moose;

with 'Living', 'Moves', 'ExperienceLevel', 'Fighter', 'GoodGuy', 'GoalOriented', 'HasInventory', 'Drawable', 'CanSee';

 __PACKAGE__->meta->make_immutable;
1;
