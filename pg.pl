#!/usr/bin/perl -W
#
#  
#  1699W [                         :::::::::::|:::::::::::::::::::::::             ]
#                    ^--- ratio of total available power (~35kW)     
#                           zoomed view of one tick of total power --^
#    ^-- total power consumption in watt  

use strict;

my $CMD='wget -qO - http://powerraw.shack:11111/';
my $MAX = 35000;
my $MAXCOLS = 100;
#my $MAXCOLS = 80 - 7 - 3;
my $MC2 = $MAXCOLS / 2;


while(1) {
  open(FH, "-|", "$CMD")||die("cannot read\n");
  my $usage = 0;
  while(my $line = <FH>) {
    if($line =~ /1-0:(21|41|61)\.7\.0\*255\(\+(\d+)\*W\)/) {
      $usage += $2;
    }
  }
  close(FH);

  printf("%5dW ", $usage);

  if($usage > 0)
  {
    my $totalratio = $usage / $MAX;
    $totalratio = 1 if($totalratio > 1);

    my $usagePerTick = $MAX / $MC2;
    my $zoomratio = ($usage % $usagePerTick) / $usagePerTick;

    printf("[%${MC2}s|%-${MC2}s]", ':' x ($totalratio * $MC2), ':' x ($zoomratio*$MC2));

  } else {
    print "|";
  }
  print $/;

  sleep(2);
}
