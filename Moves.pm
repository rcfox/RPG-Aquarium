package Moves;
use Moose::Role;

with 'PhysicalLocation';

sub move
{
    my $self = shift;
    my $dx = shift;
    my $dy = shift;
    if ($self->place($self->x + $dx,$self->y + $dy))
    {        
        print $self->name." moves to (".$self->x.",".$self->y.")\n";
        return 1;
    }

    return 0;
}

# Lame pathfinding.
sub pathfind
{
    my $self = shift;
    my $x = shift() - $self->x;
    my $y = shift() - $self->y;
    my $moved = 0;
    
    if (abs($x) > 0)
    {
        $moved = $self->move($x/abs($x),0);
    }
    elsif (abs($y) > 0)
    {
        $moved = $self->move(0,$y/abs($y));
    }

    return $moved;
}


1;
