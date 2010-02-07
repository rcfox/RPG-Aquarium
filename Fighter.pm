package Fighter;
use Moose::Role;

with 'Named';

has 'attack_power' =>
    (
        is => 'rw',
        isa => 'Int',
        default => 10,
    );

has 'attack_range' =>
    (
        is => 'rw',
        isa => 'Int',
        default => 1,
    );

sub attack
{
    my $self = shift;
    my $victim = shift;

    die unless ($victim->does('Living'));

    if ($self->distance($victim) <= $self->attack_range)
    {
        my $dmg = int(rand($self->attack_power));
        print $self->name." does $dmg damage to ".$victim->name."\n";
        my $killed = $victim->injure($dmg);
        
        if ($killed)
        {
            $self->award_experience($victim->max_hp*5);
        }
    }
    else
    {
        print $self->name." swings at ".$victim->name." but misses.\n";
    }
}

1;
