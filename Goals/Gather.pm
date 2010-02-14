package Goals::Gather;
use Moose;
use Goals::Pickup;

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
                  grep {$_ != $self->owner && $_->does('Targetable') && !$_->targeter && $_->does($self->to_find)}
                  @{$owner->container->all_contents};

    if (!@choices)
    {
        $owner->complete_goal;
        return;
    }

    my $target = $choices[0];
    $target->targeter($owner);
    $owner->add_goal(new Goals::Pickup(target=>$target));
    $owner->current_goal->do_goal;
}

 __PACKAGE__->meta->make_immutable;
1;
