#!/usr/bin/perl
use strict;
use warnings;

my @in = split(/\n/,`grep -R '^with' *`);

print "digraph G {\n";
foreach(@in)
{
    $_ ~~ s/'//g;
    $_ ~~ s/\//::/g;
    $_ ~~ /^(.*?)\.pm:with (.*);/;
    my $name = $1;
    my @roles = split(/,\s?/,$2);
    foreach(@roles)
    {
        print "\"$name\"->\"$_\";\n";
    }
}
print "}\n";
