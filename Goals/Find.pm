package Goals::Find;
use Moose;

with 'Goal';

has 'find' =>
    (
        is => 'rw',
        isa => 'Str',
        required => 1,
    );

has 'and_do' =>
    (
        is => 'rw',
        isa => 'CodeRef',
        required => 1,
    );

has 'if' =>
    (
        is => 'rw',
        isa => 'CodeRef',
        default => sub{sub{1}},
    );        

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;
    my $added = 0;

    my @choices = sort { $owner->distance($a) <=> $owner->distance($b) }
                  grep {$_ != $self->owner && $_->does($self->find) && $self->if->($_) }
                  @{$owner->container->all_contents};

    if (!@choices)
    {
        $owner->complete_goal;
        return;
    }

    $owner->add_goal($self->and_do->($choices[0]));
    $owner->current_goal->do_goal;
}

 __PACKAGE__->meta->make_immutable;
1;
