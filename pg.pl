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


my $aesc = "\x1b";
my $arst = "${aesc}[0m";
my $abright = "${aesc}[1m";
my $abg  = "${aesc}[42m";
my $aby  = "${aesc}[43m";
my $abr  = "${aesc}[41m";
my $afg  = "${aesc}[32m";
my $afy  = "${aesc}[33m";
my $afr  = "${aesc}[31m";
my $aflip ="${aesc}[7m";

my $agn = "$abright$abg$afg";
my $ayn = "$abright$aby$afy";
my $arn = "$abright$abr$afr";
my $agb = "$abright$abg$afg$aflip";
my $ayb = "$abright$aby$afy$aflip";
my $arb = "$abright$abr$afr$aflip";



sub getPowerColor()
{
  my @powerlevels = (2000, 3000, 4000, 5000, 6000, 7000);
  my @powercolors = ($agn, $agb, $ayn, $ayb, $arn, $arb);
  
  my $power = shift;
  for(my $i=0; $i <= $#powerlevels; ++$i)
  {
    if($power <= $powerlevels[$i])
    {
      return $powercolors[$i];
    }
  }

  return $powercolors[$#powercolors];
}


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

    my $col = &getPowerColor($usage);

    my $ntotal =  int ($totalratio * $MC2);
    my $nzoom = int ($zoomratio * $MC2);

    printf("${arst}[%s${col}%s${arst}|${col}%s${arst}%s]"
      , ' ' x ($MC2 - $ntotal)
      , '_' x $ntotal
      , '_' x $nzoom
      , ' ' x ($MC2 - $nzoom) );

  } else {
    print "|";
  }
  print $/;

  sleep(2);
}
