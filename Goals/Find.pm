package Goals::Find;
use Moose;
use Goals::Wait;

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

has 'or_else' =>
    (
        is => 'rw',
        isa => 'CodeRef',
        default => sub{sub{new Goals::Wait()}},
    );

has 'if' =>
    (
        is => 'rw',
        isa => 'CodeRef',
        default => sub{sub{1}},
    );

has 'times' =>
    (
	    is => 'rw',
	    isa => 'Int',
	    default => 1,
	);

sub do_goal
{
    my $self = shift;
    my $owner = $self->owner;
    my $added = 0;

    if($self->times == 0)
    {
	    $owner->complete_goal;
    }

    my @choices = sort { $owner->distance($a) <=> $owner->distance($b) }
                  grep {$_ != $self->owner && $_->does($self->find) && $self->if->($_) }
                  $owner->look();

    if (!@choices)
    {
	    $owner->add_goal($self->or_else->());
	    $owner->current_goal->do_goal;
        return;
    }

    $owner->add_goal($self->and_do->($choices[0]));
    $owner->current_goal->do_goal;

    $self->times($self->times-1);
}

 __PACKAGE__->meta->make_immutable;
1;
