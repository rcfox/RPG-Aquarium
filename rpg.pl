#!/usr/bin/perl

use SDL;
use SDL::App;
use SDL::Event;
use SDL::Surface;
use SDL::Rect;
use SDL::Color;

my $app = new SDL::App(-title=>"RPG Aquarium", -width=>80, -height=>60, -depth=>16);
my $event = new SDL::Event;

my $hero_clr = new SDL::Color(-r=>0,-g=>0,-b=>255);
my $monster_clr = new SDL::Color(-r=>255,-g=>0,-b=>0);
my $big_monster_clr = new SDL::Color(-r=>255,-g=>255,-b=>0);
my $object_clr = new SDL::Color(-r=>100,-g=>100,-b=>100);
my $black = new SDL::Color(-r=>0,-g=>0,-b=>0);

use Person;
use Monster;
use Object;
use Room;

use Goals::Nothing;
use Goals::Move;
use Goals::Wander;
use Goals::Find;
use Goals::Pickup;
use Goals::Kill;

my $room = new Room(width => $app->width/4, height => $app->height/4);

my @heroes;
create_heroes(1);

my @monsters;
create_monsters(1);

my $app_rect = new SDL::Rect(-width=>640,-height=>480,-x=>0,-y=>0);
my $ticks = $app->ticks();
my $old_ticks = $ticks;

my $turns = 0;

while (1)
{
    if ($turns++ == 160)
    {
        create_heroes(1);
        create_monsters(scalar @heroes);
        foreach(@heroes)
        {
            $_->add_goal(new Goals::Find(find=>'BadGuy',
                                         and_do=>sub{new Goals::Kill(target=>shift())},
#                                         if=>sub{my $a = shift; $a->does('Targetable') && !$a->targeter}
                                       ));
        }
        foreach(@monsters)
        {
            $_->add_goal(new Goals::Find(find=>'GoodGuy',and_do=>sub{new Goals::Kill(target=>shift())}));            
        }
        $turns = 0;
    }
    
    $app->fill($app_rect,$black);
    foreach (@{$room->all_contents})
    {
        if ($_->does('Living') && $_->does('GoalOriented') && $_->hp > 0 && $_->current_goal)
        {
            $_->do_goal;
        }
        $app->fill($_->gfx_rect,$_->gfx_color);

        # Increase response time for when there are a lot of things in the room.
        check_events();
    }
    $app->update($app_rect);

    check_events();

    $old_ticks = $ticks;
    $ticks = $app->ticks;
    if ($ticks-$old_ticks < 50)
    {
        $app->delay(50 - ($ticks - $old_ticks));
    }
}

sub check_events
{
    $event->pump();
    $event->poll();
    exit if $event->type == SDL_QUIT;
}

sub create_heroes
{
    my $num_heroes = shift;
    for (1..$num_heroes)
    {
        my ($x,$y) = get_free_location();
    
        my $hero = new Person(name => 'Hero'.@heroes, x => $x, y => $y, max_hp => 100, attack_range => 2, gfx_color=>$hero_clr);
        $room->add_content($hero);
        $hero->add_goal(new Goals::Wander);
        $hero->add_goal(new Goals::Find(find=>'BadGuy',
                                        and_do=>sub{new Goals::Kill(target=>shift())},
#                                        and_do=>sub{new Goals::Pickup(target=>shift())},
#                                        if=>sub{my $a = shift; $a->does('Targetable') && !$a->targeter}
                                       ));

        push @heroes, $hero;
    }
}

sub create_monsters
{
    my $num_monsters = shift;
    for (1..$num_monsters)
    {
        my ($x,$y) = get_free_location();

        my $m = new Monster(name => 'Monster'.@monsters, x => $x, y => $y, max_hp => 40, gfx_color=>$monster_clr);
        $m->add_goal(new Goals::Nothing);
        $m->add_goal(new Goals::Find(find=>'GoodGuy',and_do=>sub{new Goals::Kill(target=>shift())}));
        $room->add_content($m);

        push @monsters, $m;
    }
}

sub get_free_location
{
    my $x;
    my $y;
    
    do
    {
        $x = int(rand($room->width));
        $y = int(rand($room->height));
    } while ($room->check_collision($x,$y));
    return ($x,$y);
}
