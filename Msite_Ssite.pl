#!/usr/bin/env perl      
#use warnings;
use strict;
require Getopt::Long;    # process command line options
my $av=@ARGV;
my $infile = $ARGV[0];
print "Infile: ".$infile."\n";
my $pals_site = $ARGV[1];
print "Covering Site $pals_site to Primary Site"."\n";
my $outfile = $infile . ".singleSite$ARGV[1]";

&usage unless (@ARGV >= 1);
sub usage {
print STDOUT "\n
$0    v1.1    for 93000 SOC tester
    Created by Bryan Gonzalez -  7/23/2007
   
Purpose:
    Generates single site pin configution file from a multi-site pin configuation file. 
    Option: strip
    
Usage example:
    $0  <Orignal.pin> <PALS site to be converted> 
    $0  <Orignal.pin> strip
     
Usage example:
    $0   BRCMXXXX.pin 2

    Note: This will create a new pin config file that will but site 2 as single site config file.
	  
\n";exit}

# Banner
print "\n";
print "####################\n";
print "#  Msite_Ssite.pl  #\n";
print "####################\n\n";


if($pals_site eq "strip"){
	$outfile = $infile . ".stripped";
	open( "INFILE", "< $infile" ) or die "ERROR: Cannot open file for reading:  $infile\n\n";
	open( "OUTFILE", "> $outfile" ) or die "ERROR: Cannot open file for writing:  $outfile\n\n";
	while ( my $line = <INFILE> ) {
        	if($line =~ /^hp93000/){
	 		print OUTFILE $line;
		}elsif($line =~ /^DFPN/){
			print OUTFILE $line;
		}elsif($line =~ /^PSTE/){
			#print OUTFILE $line;
		}elsif($line =~ /^CONF/){
			print OUTFILE $line;
		}elsif($line =~ /^RDIV/){
			print OUTFILE $line;
		}
	
	
	
	}
	print "New configuation file is: $outfile \n\n";
	exit;
}	
#opening input and output files.
open( "INFILE", "< $infile" ) or die "ERROR: Cannot open file for reading:  $infile\n\n";
open( "OUTFILE", "> $outfile" ) or die "ERROR: Cannot open file for writing:  $outfile\n\n";

my @Pals_data;
my @PALS;
my $pals_count =0;




#read in physical waveforms
if($pals_site != 1)
{
	while ( my $line = <INFILE> ) {
   	 if ( $line =~ /^PALS/ ) {
     	   my $tmp_line =  $line;
    		@Pals_data = split/\s+/,$line;
		if ($Pals_data[1] == $pals_site )
		{
		        my @tmp_array = split(/,/,$tmp_line);
			
			my $Asize =@tmp_array;
			
			if ($Asize == 4)
			{
			#removes null
			chomp($tmp_array[3]);
		
			$tmp_line = $tmp_array[3];
			$PALS[$pals_count] = $tmp_line;
			$pals_count++;
		
			$tmp_line =$tmp_array[1];
			$PALS[$pals_count] = $tmp_line;
			$pals_count++;
			}
			if($Asize == 6)
			{
			chomp($tmp_array[5]);
		
			$tmp_line = $tmp_array[5];
			$PALS[$pals_count] = $tmp_line;
			$pals_count++;
		        
			my $nz = "$tmp_array[1],$tmp_array[2],$tmp_array[3]";
			$tmp_line =$nz;
			$PALS[$pals_count] = $tmp_line;
			$pals_count++;
			}
		}
    	 }
	}

	#Size of Array;
	my $fkp = @PALS;
	my @holder_a;

	close INFILE;

	open( "INFILE", "< $infile" ) or die "ERROR: Cannot open file for reading:  $infile\n\n";

	while ( my $line = <INFILE> ) {
 
	 if($line =~ /^DFPN/)
	 {
        
		$line =~ s/DFPN\s//;#13105,"B7 ",(mode_2)
		@holder_a = split(/,/,$line);#13105|"B7 "|(mode_2)
	
		#cleans extra spaces
		$holder_a[1] =~ s/\s+//;#"B7"
		$holder_a[2] =~ s/\s+//;#(mode_2)
		chomp $holder_a[2];#removes null
		
 		for(my $kxi=0;$kxi <= $fkp; $kxi++)
 		{
 		
			if($PALS[$kxi] eq $holder_a[2])
			{
			 print OUTFILE "DFPN $PALS[$kxi+1],$holder_a[1],$PALS[$kxi]\n";
			}
 		}	
	 }
	 elsif($line =~ /^DFPS/)
	 {
	 	#$line = DFPS 13,POS,(VDD_1P2)
		@holder_a=split(/ /,$line);#DFPS|13,POS,(VDD_1P2)
		@holder_a = split(/,/,$holder_a[1]);#13|POS|(VDD_1P2)
		chomp $holder_a[2];;#removes null
	
		for(my $kxi=0;$kxi <= $fkp; $kxi++)
 		{
 		
			if($PALS[$kxi] eq $holder_a[2])
			{
				 print OUTFILE "DFPS $PALS[$kxi+1],$holder_a[1],$PALS[$kxi]\n";
			}
 		}
	
 	}
 	elsif($line =~ /^DFUT/)
 	{
  		#$line = DFUT 110,RW,(K2)
		@holder_a=split(/ /,$line);#DFUT|110,RW,(K2)
		@holder_a = split(/,/,$holder_a[1]);#110|RW|(K2)
		chomp $holder_a[2];#removes null
	
		for(my $kxi=0;$kxi <= $fkp; $kxi++)
 		{
 			
			if($PALS[$kxi] eq $holder_a[2])
			{
				 print OUTFILE "DFUT $PALS[$kxi+1],$holder_a[1],$PALS[$kxi]\n";
			}
 		}
 	}
	elsif($line =~ /^DFAN/)
	{
		
		#DFAN "MCB231,9,o","",(EPHY_WDD)
		@holder_a=split(/ /,$line);#DFAN|"MCB231,9,o","",(EPHY_WDD)
		@holder_a = split(/,/,$holder_a[1]);#110|RW|(K2)
		chomp $holder_a[4];#removes null
	
		for(my $kxi=0;$kxi <= $fkp; $kxi++)
 		{
 			
			if($PALS[$kxi] eq $holder_a[4])
			{
				 print OUTFILE "DFAN $PALS[$kxi+1],\"\",$PALS[$kxi]\n";
			}
 		}
	}
 	elsif($line =~ /^PALS/)
 	{
 		#do nothing to remove PALS
 	}
	 elsif($line =~ /^PSTE/)
 	{
 		#do nothing to remove PSTE
 	}
	 else
 	{
 	 	print OUTFILE $line;
 	}
 
      }  
}else
{
	open( "INFILE", "< $infile" ) or die "ERROR: Cannot open file for reading:  $infile\n\n";

	while ( my $line = <INFILE> ) {
 
	 	if($line =~ /^PALS/)
 		 {
 			#do nothing to remove PALS
		 }
 		elsif($line =~ /^PSTE/)
 		{
 			#do nothing to remove PSTE
 		}
 		else
		{
  			print OUTFILE $line;
 		}	

	}
}	

print "New configuation file is: $outfile \n\n";

close OUTFILE;
close INFILE;

########################FIX NOTES#################################
#1.0 First release
#1.1 Fixed DFAN problem 
#1.2 Added strip option.
###################################################################
###                  Bryan Gonzalez                             ### 
###                    github.com/rbgonzalez                    ###
###	              July 23, 2007                             ###
###           gonzalez.bryan@gmail.com                      	###
################################################################### 
