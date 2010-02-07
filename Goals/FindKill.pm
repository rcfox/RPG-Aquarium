package Goals::FindKill;
use Moose;
use Goals::Kill;

with 'Goal';

has 'to_find' =>
    (
        is => 'rw',
        isa => 'Str',
        required => 1,
    );

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;
    my $added = 0;

    my @choices = sort { $owner->distance($a) <=> $owner->distance($b) }
                  grep {$_->does($self->to_find) && $_->hp > 0}
                  @{$owner->container->all_contents};

    if (!@choices)
    {
        $owner->complete_goal;
        return;
    }

    $owner->add_goal(new Goals::Kill(target=>$choices[0]));

    # foreach (@{$owner->container->all_contents})
    # {
    #     if ($_->does($self->to_find) && $_->hp > 0)
    #     {
    #         $owner->add_goal(new Goals::Kill(target=>$_));
    #         print $owner->name.": target acquired: ".$_->name.".\n";
    #         ++$added;
    #         last;
    #     }
    # }

    # if ($added == 0)
    # {
    #     $owner->complete_goal;
    # }
}

1;
