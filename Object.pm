package Object;
use Moose;

with 'PhysicalLocation';

has 'name' =>
    (
        is => 'rw',
        isa => 'Str',
    );

1;
