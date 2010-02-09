package Goals::Unload;
use Moose;
use Goals::Move;

with 'Goal';

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;

    if ($owner->distance(0,0) == 1)
    {
        my $item = $owner->list_inventory->[0];

        $owner->remove_item($item);
#        $owner->container->add_content($item);
#        $item->place($owner->x,$owner->y);
        
        print $owner->name.": dropped item.\n";
        $owner->complete_goal;
    }
    else
    {
        $owner->add_goal(new Goals::Move(x=>0,y=>0));
        $owner->current_goal->do_goal;
    }
}

 __PACKAGE__->meta->make_immutable;
1;
