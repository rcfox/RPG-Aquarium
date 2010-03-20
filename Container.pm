package Container;
use Moose::Role;

use AI::Pathfinding::AStar::Rectangle;
use Algorithm::QuadTree;

has 'quad_tree' =>
    (
	is => 'rw',
	isa => 'Algorithm::QuadTree',
	lazy => 1,
	default => sub
	{
	    my $self = shift;
	    Algorithm::QuadTree->new(-xmin=>0,-ymin=>0,-xmax=>$self->width,-ymax=>$self->height,-depth=>1);
	},
    );

has 'objrefs' =>
    (
	is => 'rw',
	isa => 'Int',
	default => 0,
    );

has 'objmap' =>
    (
	is => 'rw',
	isa => 'HashRef[Int]',
	default => sub{{}},
    );

has 'width' =>
    (
        is => 'rw',
        isa => 'Int',
        required => 1,
    );

has 'height' =>
    (
        is => 'rw',
        isa => 'Int',
        required => 1,
    );

has 'map' =>
    (
        is => 'rw',
        isa => 'Any',
        lazy => 1,
        default => sub
        {
            my $self = shift;
            AI::Pathfinding::AStar::Rectangle->new({width=>$self->width, height=>$self->width});            
        },
    );

sub BUILD
{
    my $self = shift;
    for(my $p = 1; $p < $self->width-1; ++$p)
    {
        for(my $q = 1; $q < $self->height-1; ++$q)
        {
            $self->map->set_passability($p,$q,1);
        }
    }
}

sub add_content
{
    my $self = shift;
    my $toadd = shift;

    $self->objmap->{$toadd} = $self->objrefs;
    $self->objmap->{$self->objrefs} = $toadd;
    
    $self->quad_tree->add($self->objrefs,$toadd->x,$toadd->y,$toadd->x,$toadd->y);
    $self->map->set_passability($toadd->x,$toadd->y,0);

    $toadd->container($self);
    $self->objrefs($self->objrefs+1);
}

sub remove_content
{
    my $self = shift;
    my $toadd = shift;

    $self->map->set_passability($toadd->x,$toadd->y,1);    
    $self->quad_tree->delete($self->objmap->{$toadd});
}

sub all_contents
{
    my $self = shift;
    my @transformed = map { $self->objmap->{$_} } @{$self->quad_tree->getEnclosedObjects(0,0,$self->width,$self->height)};
    return \@transformed;
}

sub contains_object
{
    my $self = shift;
    my $object = shift;
    my @arr = grep { $_ == $object } @{$self->all_contents};

    return scalar @arr;
}

sub place_content
{
    my $self = shift;
    my $content = shift;
    my $nx = shift;
    my $ny = shift;

    $self->map->set_passability($content->x,$content->y,1);
    $self->quad_tree->delete($self->objmap->{$content});
    $self->quad_tree->add($self->objmap->{$content},$nx,$ny,$nx,$ny);
    $self->map->set_passability($nx,$ny,0);
}

sub check_collision
{
    my $self = shift;
    my $x = shift;
    my $y = shift;

    return 1 if ($x < 0 || $x > $self->width-1 || $y < 0 || $y > $self->height-1);

    my @val = @{$self->quad_tree->getEnclosedObjects($x,$y,$x,$y)};
    if (@val == 1)
    {
	return 1;
    }
    elsif (@val > 1)
    {
	for(@val)
	{
	    my $obj = $self->objmap->{$_};
	    return 1 if ($obj->x == $x && $obj->y == $y);
	}
    }
    return 0;
}

1;
