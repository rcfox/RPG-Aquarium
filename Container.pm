package Container;
use Moose::Role;

use AI::Pathfinding::AStar::Rectangle;

has 'contents' =>
    (
        is => 'rw',
        isa => 'HashRef[PhysicalLocation]',
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

    $self->contents->{$toadd->x}->{$toadd->y} = $toadd;
    $self->map->set_passability($toadd->x,$toadd->y,0);

    $toadd->container($self);
}

sub remove_content
{
    my $self = shift;
    my $toadd = shift;

    $self->map->set_passability($toadd->x,$toadd->y,1);
    delete($self->contents->{$toadd->x}->{$toadd->y});
}

sub all_contents
{
    my $self = shift;
    my @c;

    use Data::Dumper;
    
    foreach my $x (keys %{$self->contents})
    {        
        foreach my $y (keys %{$self->contents->{$x}})
        {
            push @c, $self->contents->{$x}->{$y};
        }
    }

    return \@c;
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
    delete($self->contents->{$content->x}->{$content->y});
    $self->contents->{$nx}->{$ny} = $content;
    $self->map->set_passability($nx,$ny,0);
}

sub check_collision
{
    my $self = shift;
    my $x = shift;
    my $y = shift;

    return 1 if ($x < 0 || $x > $self->width-1 || $y < 0 || $y > $self->height-1);

    my $val = $self->contents->{$x}->{$y};
    return ($val ? 1 : 0);
}

1;
