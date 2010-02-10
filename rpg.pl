#!/usr/bin/perl
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
my $black = new SDL::Color(-r=>0,-g=>0,-b=>0);

use Person;
use Monster;
use Object;
use Room;

use Goals::Gather;
use Goals::Persecute;
use Goals::Nothing;

my $room = new Room;

my @heroes;
for(1..30)
{
    my $x;
    my $y;

    do
    {
        $x = int(rand(160));
        $y = int(rand(120));
    } while($room->check_collision($x,$y));
    
    my $hero = new Person(name => 'Hero'.$_, x => $x, y => $y, max_hp => 100, attack_range => 2, gfx_color=>$hero_clr);
    $room->add_content($hero);
    $hero->add_goal(new Goals::Gather(to_find=>'BadGuy'));
    push @heroes, $hero;
}

my @monsters;
for(1..100)
{
    my $x;
    my $y;

    do
    {
        $x = int(rand(160));
        $y = int(rand(120));
    } while($room->check_collision($x,$y));

    my $m = new Monster(name => 'Monster'.$_, x => $x, y => $y, max_hp => 40, gfx_color=>$monster_clr);
    $m->add_goal(new Goals::Nothing);
#    $m->add_goal(new Goals::Persecute(to_find=>'GoodGuy'));
    $room->add_content($m);
}

my $app_rect = new SDL::Rect(-width=>640,-height=>480,-x=>0,-y=>0);
my $ticks = $app->ticks();
my $old_ticks = 0;

while(grep{$_->hp > 0 && @{$_->goal_stack}} @heroes)
{
    $app->fill($app_rect,$black);
    foreach(@{$room->all_contents})
    {
        if ($_->hp > 0 && $_->current_goal)
        {
            $_->current_goal->do_goal;
            $app->fill($_->gfx_rect,$_->gfx_color);
        }
    }
    $app->update($app_rect);

    $event->pump();
    $event->poll();
    exit if $event->type == SDL_QUIT;

    $old_ticks = $ticks;
    $ticks = $app->ticks;
    print "Ticks: ".($ticks - $old_ticks)."\n";
    if ($ticks-$old_ticks < 50)
    {
        $app->delay(50 - ($ticks - $old_ticks));
    }
}

foreach(@heroes)
{
    print $_->name;
    if ($_->hp > 0)
    {
        print " -> HP: ".$_->hp." Level: ".$_->level."\n";
    }
    else
    {
        print " -> Dead\n";
    }
}
