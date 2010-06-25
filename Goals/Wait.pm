package Goals::Wait;
use Moose;

with 'Goal';

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;

    $owner->complete_goal;
}

__PACKAGE__->meta->make_immutable;
1;
