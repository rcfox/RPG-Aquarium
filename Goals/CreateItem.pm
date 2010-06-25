package Goals::CreateItem;
use Moose;

use Goals::Mine;

with 'Goal';

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;
    my @ores = grep { $_->isa('Ore') } @{$owner->list_inventory};
    my $ores_needed = 30;

    if (@ores >= $ores_needed)
    {
        foreach(1..$ores_needed)
        {
            $owner->remove_item(shift(@ores));
        }
        $owner->add_item(new Object(x=>1,y=>1));
        print $owner->name.": created a thing!\n";
        $owner->complete_goal;
    }
    else
    {
        $owner->add_goal(new Goals::Find(find=>'Mineable',
                                         and_do=>sub{new Goals::Mine(target=>shift())},
                                         or_else=>sub{new Goals::Wander()}));

        $owner->current_goal->do_goal;
    }
}

__PACKAGE__->meta->make_immutable;
1;
