package Goals::Unload;
use Moose;
use Goals::Move;

with 'Goal';

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;

    if ($owner->distance(2,2) < 2)
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
        $owner->add_goal(new Goals::Move(x=>2,y=>2));
        $owner->current_goal->do_goal;
    }
}

 __PACKAGE__->meta->make_immutable;
1;
