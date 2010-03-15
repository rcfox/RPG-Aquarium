#!/usr/bin/perl

use strict;
use warnings;

use SDL;
use SDL::App;
use SDL::Event;
use SDL::Surface;
use SDL::Rect;
use SDL::Color;

my $app = new SDL::App(-title=>"RPG Aquarium", -width=>640, -height=>480, -depth=>16);
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
use Goals::Mine;
use Goals::CreateItem;

use Goals::Quest;

use OreDeposit;

my $room = new Room(width => $app->width/4, height => $app->height/4);

my $quest_guy = create_hero();
$quest_guy->add_goal(new Goals::Nothing);

my @heroes;
for(1..1)
{
    my $h = create_hero();
    $h->add_goal(new Goals::Quest(giver=>$quest_guy));
    push @heroes, $h
}

my @monsters;
for(1..1)
{
    push @monsters, create_monster();
}

for(1..100)
{
    create_ore_deposit();
}

my $app_rect = new SDL::Rect(-width=>$app->width,-height=>$app->height,-x=>0,-y=>0);
my $ticks = $app->ticks();
my $old_ticks = $ticks;

my $turns = 0;

while (1)
{
    if ($turns++ == 100)
    {
        push @monsters, create_monster();
        $turns = 0;
    }
    $app->fill($app_rect,$black);
    foreach (@{$room->all_contents})
    {
        if ($_->does('GoalOriented') && $_->current_goal)
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
    if ($event->type == SDL_MOUSEBUTTONDOWN)
    {
        use Data::Dumper;
        $Data::Dumper::Maxdepth = 2;
        print Dumper($heroes[0]->goal_stack);
    }
}

sub create_ore_deposit
{
    my ($x,$y) = get_free_location();
    my $od = new OreDeposit(x=>$x,y=>$y);
    $room->add_content($od);
    return $od;
}

sub create_hero
{
    my $goal = new Goals::Find(find=>'Mineable',
                               and_do=>sub{new Goals::Mine(target=>shift())});
    
    my ($x,$y) = get_free_location();
    
    my $hero = new Person(name => 'Hero'.@heroes, x => $x, y => $y, max_hp => 100, attack_range => 2, gfx_color=>$hero_clr);
    $room->add_content($hero);
    $hero->add_goal(new Goals::Wander);
    $hero->add_goal(new Goals::CreateItem);

    return $hero;
}

sub create_monster
{
    my ($x,$y) = get_free_location();
    
    my $m = new Monster(name => 'Monster'.@monsters, x => $x, y => $y, max_hp => 40, gfx_color=>$monster_clr);
    $m->add_goal(new Goals::Nothing);
    #        $m->add_goal(new Goals::Find(find=>'GoodGuy', and_do=>sub{new Goals::Kill(target=>shift())}));
    $room->add_content($m);

    return $m;
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

