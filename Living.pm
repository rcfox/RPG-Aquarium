package Living;
use Moose::Role;

with 'Named', 'PhysicalLocation';

has 'max_hp' =>
    (
        is => 'rw',
        isa => 'Int',
        default => 100,
    );

has 'hp' =>
    (
        is => 'rw',
        isa => 'Int',
        lazy => 1,
        default => sub { shift()->max_hp },
    );

sub injure
{
    my $self = shift;
    my $damage = shift;
    $self->hp($self->hp - $damage);

    if ($self->check_dead)
    {
        $self->died;
        return 1;
    }
    return 0;
}

sub check_dead
{
    my $self = shift;
    return ($self->hp <= 0);
}

sub died
{
    my $self = shift;
    print $self->name.": Oh no, I died!\n";
    $self->container->remove_content($self);
}

1;
