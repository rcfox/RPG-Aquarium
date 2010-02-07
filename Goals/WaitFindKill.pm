package Goals::WaitFindKill;
use Moose;
use Goals::Kill;

with 'Goal';

has 'to_find' =>
    (
        is => 'rw',
        isa => 'Str',
        required => 1,
    );

has 'max_distance' =>
    (
        is => 'rw',
        isa => 'Int',
        required => 1,
    );

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;
    my $added = 0;

    my @choices = sort { $owner->distance($a) <=> $owner->distance($b) }
                  grep {$_->does($self->to_find) && $owner->distance($_) <= $self->max_distance}
                  @{$owner->container->all_contents};

    if (!@choices)
    {
        return;
    }

    $owner->add_goal(new Goals::Kill(target=>$choices[0]));
}

 __PACKAGE__->meta->make_immutable;
1;
