package PhysicalLocation;

use Moose::Role;
use Moose::Util::TypeConstraints;

use Container;

has 'container' =>
    (
        is => 'rw',
        isa => 'Maybe[Container]',        
    );

has 'x' =>
    (
        is => 'rw',
        isa => 'Num',
    );

has 'y' =>
    (
        is => 'rw',
        isa => 'Num',
    );

sub place
{
    my $self = shift;
    my $nx = shift;
    my $ny = shift;

    if (!$self->container->check_collision($nx,$ny))
    {
        $self->container->place_content($self,$nx,$ny);
        $self->x($nx);
        $self->y($ny);        
        return 1;
    }
    return 0;
}

sub distance
{
    my ($sx, $sy, $x, $y) = _get_coords(@_);
    return sqrt(($sx-$x)**2 + ($sy-$y)**2);
}

sub direction
{
    my ($sx, $sy, $x, $y) = _get_coords(@_);
    return ( ($x-$sx), ($y-$sy) );
}

sub _get_coords
{
    my $self = shift;
    my $sx = $self->x;
    my $sy = $self->y;
    my $x = shift;
    my $y = shift;

    match_on_type $x =>
    (
        PhysicalLocation => sub {
            my $pl = $x;
            $x = $pl->x;
            $y = $pl->y;
        },
        Num => sub{1},
    );

    return ($sx, $sy, $x, $y);
}

1;
