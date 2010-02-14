package Targetable;
use Moose::Role;

has 'targeter' =>
    (
        is => 'rw',
        isa => 'Maybe[Moves]',
    );

1;
