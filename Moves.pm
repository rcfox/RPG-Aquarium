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
#        print $self->name." moves to (".$self->x.",".$self->y.")\n";
        return 1;
    }

    return 0;
}

sub move_by_dir
{
    my $self = shift;
    my $dir = shift;
    my $moved = 0;
    
    if ($dir)
    {
        $moved = $self->move(-1,1)  if ($dir == 1);
        $moved = $self->move(0,1)   if ($dir == 2);
        $moved = $self->move(1,1)   if ($dir == 3);
        $moved = $self->move(-1,0)  if ($dir == 4);
        $moved = $self->move(1,0)   if ($dir == 6);
        $moved = $self->move(-1,-1) if ($dir == 7);
        $moved = $self->move(0,-1)  if ($dir == 8);
        $moved = $self->move(1,-1)  if ($dir == 9);
    }

    return $moved;
}

sub pathfind
{
    my $self = shift;
    my $x = shift;
    my $y = shift;
    my $moved = 0;

    # Set current and target position passability to 1 so that the pathfinding works.
    $self->container->map->set_passability($self->x,$self->y,1);
    $self->container->map->set_passability($x,$y,1);
    
    my $path = $self->container->map->astar($self->x,$self->y,$x,$y);

    # Reset passability
    $self->container->map->set_passability($self->x,$self->y,0);
    $self->container->map->set_passability($x,$y,0);
    
    my $dir = substr($path,0,1);

    $moved = $self->move_by_dir($dir);

    return $moved;
}

1;
