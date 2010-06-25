package Drawable;
use Moose::Role;

with 'PhysicalLocation';

use SDL::Rect;
use SDL::Color;

has 'gfx_rect' =>
    (
        is => 'rw',
        isa => 'SDL::Rect',
        default => sub { my $self = shift;
                         new SDL::Rect($self->x*4,$self->y*4,4,4);
                       },
    );

has 'gfx_color' =>
    (
        is => 'rw',
        isa => 'Int',
        default => -1
    );

after 'place' => sub
{
    my $self = shift;
    $self->gfx_rect->x($self->x * $self->gfx_rect->w);
    $self->gfx_rect->y($self->y * $self->gfx_rect->h);
};

1;
