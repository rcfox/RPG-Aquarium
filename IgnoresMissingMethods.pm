package IgnoresMissingMethods;
use Moose::Role;
use Carp;

sub AUTOLOAD
{
    our $AUTOLOAD;
    carp "Warning: $AUTOLOAD not defined. Called";
}

1;
