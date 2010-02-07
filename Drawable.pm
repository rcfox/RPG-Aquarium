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
                         new SDL::Rect(-height=>16,-width=>16,-x=>$self->{x}*16,-y=>$self->{y}*16);
                       },
    );

has 'gfx_color' =>
    (
        is => 'rw',
        isa => 'SDL::Color',
        default => sub { new SDL::Color(-r=>255,-b=>255,-g=>255) },
    );

after 'x' => sub
{
    my $self = shift;
    $self->gfx_rect->x($self->{x} * $self->gfx_rect->width);
};

after 'y' => sub
{
    my $self = shift;
    $self->gfx_rect->y($self->{y} * $self->gfx_rect->height);
};

1;
