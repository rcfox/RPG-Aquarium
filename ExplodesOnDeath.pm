package ExplodesOnDeath;
use Moose::Role;

with 'Living';

after 'died' => sub
{
    my $self = shift;
    
    print "BOOM!\n";
    foreach(grep { $_->does('Living') && $self->distance($_) <= $self->max_hp/10 } @{$self->container->all_contents})
    {
        print $_->name." is damaged by the explosion!\n";
        $_->injure($self->max_hp/20);
    }
};

1;
