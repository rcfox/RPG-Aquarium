package ExperienceLevel;
use Moose::Role;

with 'Named';

has 'level' =>
    (
        is => 'rw',
        isa => 'Int',
        default => 1,
    );
has 'experience' =>
    (
        is => 'rw',
        isa => 'Int',
        default => 0,
    );

sub levelup
{
    my $self = shift;
    print $self->name.": Woohoo! Level ".$self->level."!\n";
    $self->hp($self->max_hp);
    $self->attack_power($self->attack_power+2);
    $self->level($self->level + 1);
}

sub award_experience
{
    my $self = shift;
    my $exp = shift;

    return unless $self->hp > 0;
    
    $self->experience($self->experience + $exp);

    if ($self->can_levelup)
    {
        $self->levelup;
        $self->award_experience(0);
    }
}

sub can_levelup
{
    my $self = shift;
    my $level = $self->level;
    my $exp = $self->experience;
    return ($exp >= ($level * 100));
}

1;
