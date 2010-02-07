package Container;
use Moose::Role;

has 'contents' =>
    (
        is => 'rw',
        isa => 'HashRef[PhysicalLocation]',
        default => sub{{}},
    );

sub add_content
{
    my $self = shift;
    my $toadd = shift;

    $self->contents->{$toadd->x}->{$toadd->y} = $toadd;

    $toadd->container($self);
}

sub remove_content
{
    my $self = shift;
    my $toadd = shift;

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

sub place_content
{
    my $self = shift;
    my $content = shift;
    my $nx = shift;
    my $ny = shift;

    delete($self->contents->{$content->x}->{$content->y});
    $self->contents->{$nx}->{$ny} = $content;
}

sub check_collision
{
    my $self = shift;
    my $x = shift;
    my $y = shift;

    my $val = $self->contents->{$x}->{$y};
    return (defined($val));
}

1;
