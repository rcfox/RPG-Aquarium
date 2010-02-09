package HasInventory;
use Moose::Role;

has 'inventory' =>
    (
        is => 'ro',
        isa => 'HashRef[Item]',
        default => sub{{}},
    );

sub add_item
{
    my $self = shift;
    my $item = shift;

    $self->inventory->{$item} = $item;
}

sub remove_item
{
    my $self = shift;
    my $item = shift;

    delete $self->inventory->{$item};
}

sub list_inventory
{
    my $self = shift;
    my @arr = values %{$self->inventory};
    return \@arr;
}

sub inventory_count
{
    return scalar @{shift()->list_inventory};
}

1;
