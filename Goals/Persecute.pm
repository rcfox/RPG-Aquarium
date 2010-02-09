package Goals::Persecute;
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
                  grep {$_ != $self->owner && $_->does($self->to_find)}
                  @{$owner->container->all_contents};

    if (!@choices)
    {
        $owner->complete_goal;
        return;
    }

    $owner->add_goal(new Goals::Kill(target=>$choices[0]));
    $owner->current_goal->do_goal;
}

 __PACKAGE__->meta->make_immutable;
1;
