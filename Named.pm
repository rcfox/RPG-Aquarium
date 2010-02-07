package Named;
use Moose::Role;

with 'IgnoresMissingMethods';

has 'name' =>
    (
        is => 'rw',
        isa => 'Str',
        default => 'Noname',
    );

1;
