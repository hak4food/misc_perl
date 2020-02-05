#!/usr/bin/perl

my $inputfile = $ARGV[0];
$ui=200 ; #ps
$samples=16384 ; 
$prbs_len=127;
$prbs_captures=2;
my $firstrun =0;

$ttl_time = $ui * $prbs_len * $prbs_captures ;   #ps
$s_ui = $ttl_time /$samples ; 

print "ttl time of capture = $ttl_time ps\n";
print "effective sampling rate = $s_ui ps\n";

$discard = $ui/$s_ui ; 
print "$discard\n";

my $startpoint;
my $minpoint;
$i=1;
$toggle=0;
open(INFILE, "< $inputfile") || die;
open(OUTFILE, "> tmp.txt")  || die;
while (<INFILE>) { 

if ($_ =~ "-0" && $firstrun == 0){ $firstrun =1; $startpoint=$i; print "start point: $startpoint $_ ";}
if($i == $startpoint+32){ 
 print $_+1;

	if($_ =~ /^0/ ){ print OUTFILE "1\n";}
	if($_ =~ /^-/ ){ print OUTFILE "0\n";}
	$minpoint=$i;
}

if($i == $minpoint+64){ 
#$toggle = ~ $toggle;
	#print "Mid point: $minpoint\n";
	if($_ =~ /^0/){ print OUTFILE "1\n";}
	if($_ =~ /^-/){ print OUTFILE "0\n";}
	$minpoint+=64;
	
}

$i++;
	

}
close INFILE;
close OUTFILE;


###################################################################
###                  Bryan Gonzalez                             ### 
###               github.com/rbgonzalez                         ###
###	              July 23, 2008                             ###
###           gonzalez.bryan@gmail.com     	                ###
################################################################### 
