package ExplodesOnDeath;
use Moose::Role;

with 'Living';

after 'died' => sub
{
    print "BOOM!\n";
};

1;
