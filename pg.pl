#!/usr/bin/perl -W
use strict;

my $CMD='wget -qO - http://powerraw.shack:11111/';
my $MAX = 10000;
my $MAXCOLS = 80;

while(1) {
  open(FH, "-|", "$CMD")||die("cannot read\n");
  my $usage = 0;
  while(my $line = <FH>) {
    if($line =~ /1-0:(21|41|61)\.7\.0\*255\(\+(\d+)\*W\)/) {
      $usage += $2;
    }
  }
  close(FH);

  if($usage > 0)
  {
    my $ratio = $usage / $MAX;
    $ratio = 1 if($ratio > 1);
    my $cols = int($MAXCOLS * $ratio);
    print '=' x $cols;
  } else {
    print "|";
  }

  print " $usage$/";
  sleep(1);
}
