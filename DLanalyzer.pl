#!/usr/bin/perl
#use warnings;
#use strict;
#NOTICE: PLEASE READ CAREFULLY:  PROVIDES THIS SOFTWARE TO YOU ONLY UPON
#YOUR ACCEPTANCE OF ADVANTEST\u2019S TERMS OF USE. THE SOFTWARE IS PROVIDED \u201cAS IS\u201d
#WITHOUT WARRANTY OF ANY KIND \u2019S LIABILITY FOR SUCH SOFTWARE LIMITED
#TO THE FULLEST EXTENT PERMITTED UNDER THE LAW.


require Getopt::Long;    # process command line options

#####Global Variables
my @site1;#data array
my $site1_count=0;#count
my @site2;#data array
my $site2_count=0;#count
my @holder_array;#holders
my @holder_array2;#holders
my $line;#holders
my $site2_flag = 0;#detects for site2 is in file1

#input argv
my $inputfile = $ARGV[0];
my $inputfile2 = $ARGV[1];
my $outputfile = $inputfile."_diff";
my $numberOfArgs = @ARGV;

#Information on script
if($numberOfArgs == 0){&usage;}

#print statements
print "\n";
print "######################\n";
print "#  Data Analyzer.pl  #\n";
print "######################\n"; 
print "\tProcessing file: $inputfile"."\n";
if($numberOfArgs==2){ print "\tProcessing file: $inputfile2"."\n";}
print "\tWriting differences to $outputfile\n";

########################  Main program   ###############################
open(OUTFILE, "> $outputfile")  || &errorMessage;
print OUTFILE "Datalog Analyzer v1.0 by Bryan Gonzalez, Verigy LTD.\n";
#seperates site information data
open(INFILE, "< $inputfile") || &errorMessage;
	 #pulled information by site
	 print OUTFILE "INPUT FILE:  $inputfile:\n";
	 while ($line=<INFILE>){

		 @holder_array = split(/\s+/,$line);

		 foreach my $tmp (@holder_array)
		 {
		   if($tmp eq "Site:1")
		   {
	  		 $site1[$site1_count]=$line;
			 $site1_count++;
		   }elsif($tmp eq "Site:2")
		   {
	  		 $site2[$site2_count]=$line;
			 $site2_count++;
			 @site2_flag = 1;
		   }
		 }

	 }
close INFILE;
#seperates site information data for second file.
if($numberOfArgs==2){
open(INFILE, "< $inputfile2") || &errorMessage;
	 #pulled information by site
	 while ($line=<INFILE>){

		 @holder_array = split(/\s+/,$line);

		 foreach my $tmp (@holder_array)
		 {
		   if($tmp eq "Site:1")
		   {
	  		 $site1_file2[$site1_count_file2]=$line;
			 $site1_count_file2++;
		   }elsif($tmp eq "Site:2")
		   {
	  		 $site2_file2[$site2_count_file2]=$line;
			 $site2_count_file2++;
		   }
		 }

	 }
close INFILE;
}

#call of subs
&check_test_numbers(@site1);#check_test_numbers

if(@site2_flag == 1){&check_test_numbers(@site2);}#check_test_numbers for site 2

if(@site2_flag == 1){&site_to_site_check;}# checks site to site for missing /mismatched tests. 

#run of second datalog is given
if($numberOfArgs==2){&match_two_dl_testnumbers;} #compares the two datalogs for mismatched testnumbers.

if($numberOfArgs==2){&match_two_dl_testnames;}

if($numberOfArgs==2){&match_two_dl_limits;}

print OUTFILE "\nEND OF FILE";
close OUTFILE;
exit;
######################  End of Main program   ###########################

###########################################################################
###########################   SUBROUTINES  ################################
###########################################################################

##################Checks two datalogs for limit differences
sub match_two_dl_limits{
	my $match=0;
	my $match_count=0;
	
	print OUTFILE "\nNote: Please Fix any test-number problems first.";
	print OUTFILE "\n      As this may give a false positives.";
	print OUTFILE "\nLIMITS MISMATCH FROM $inputfile TO $inputfile2\n";
	
	foreach my $tmp (@site1)
	{
		$match=0;
	   	@holder_array = split(/</, $tmp);
  		my @hold = split(/\s+/, $holder_array[0]);
		$holder_array[0] =~ s/\d+\s+//;
		$holder_array[0] =~ s/(\w)\s(\w)/$1_$2/g; 
		my @lower_limit = split(/\s+/,$holder_array[0]);
	
	     foreach my $tmps (@site1_file2)
	     {
	     			     	
		@holder_array2 = split(/</, $tmps);
    		my @hold2 = split(/\s+/, $holder_array2[0]);
		$holder_array2[0] =~ s/\d+\s+//;
    		$holder_array2[0] =~ s/(\w)\s(\w)/$1_$2/g; 
   		my @lower_limit2 = split(/\s+/,$holder_array2[0]);
	
		if($lower_limit[1] eq $lower_limit2[1] and $hold[0] eq $hold2[0])
		{
			$match =1;
		}
	     }
	     if($match == 0)
	     { 
	    	$match_count++;
	    	print OUTFILE $tmp;
	     }
	}
	foreach my $tmp (@site2)
	{
		$match=0;
	   	@holder_array = split(/</, $tmp);
  		my @hold = split(/\s+/, $holder_array[0]);
		$holder_array[0] =~ s/\d+\s+//;
		$holder_array[0] =~ s/(\w)\s(\w)/$1_$2/g; 
		my @lower_limit = split(/\s+/,$holder_array[0]);
	
	     foreach my $tmps (@site2_file2)
	     {
	     			     	
		@holder_array2 = split(/</, $tmps);
    		my @hold2 = split(/\s+/, $holder_array2[0]);
		$holder_array2[0] =~ s/\d+\s+//;
    		$holder_array2[0] =~ s/(\w)\s(\w)/$1_$2/g; 
   		my @lower_limit2 = split(/\s+/,$holder_array2[0]);
	
		if($lower_limit[1] eq $lower_limit2[1] and $hold[0] eq $hold2[0])
		{
			$match =1;
		}
	     }
	     if($match == 0)
	     { 
	    	$match_count++;
	    	print OUTFILE $tmp;
	     }
	}
	
	print OUTFILE "\tTotal unmatched: $match_count\n\n";

}

##################Checks two datalogs for un matched testnames
sub match_two_dl_testnames{
	
	my $match=0;
	my $match_count=0;
	print OUTFILE "\nUNMATCHING TESTSUITE NAMES FROM $inputfile TO $inputfile2\n";
	
	foreach my $tmp (@site1)
	{
	     $match=0;
	     @holder_array = split(/</, $tmp);
	     $holder_array[0] =~ s/\d+\s+//;#removes the testnumbers
	     $holder_array[0] =~ s/(\w)\s(\w)/$1_$2/g;#connects testname dashes
	     	     
	     foreach my $tmps (@site1_file2)
	     {
	     	@holder_array2 = split(/</, $tmps);
	        $holder_array2[0] =~ s/\d+\s+//;#removes the testnumbers
	        $holder_array2[0] =~ s/(\w)\s(\w)/$1_$2/g;#connects testname dashes
	     
		if($holder_array[0] eq $holder_array2[0])
		{
			$match =1;
		}
	     }
	     if($match == 0)
	     { 
	    	$match_count++;
	    	print OUTFILE $tmp;
	     }
	}
	
	foreach my $tmp (@site2)
	{
	     $match=0;
	     @holder_array = split(/</, $tmp);
	     $holder_array[0] =~ s/\d+\s+//;#removes the testnumbers
	     $holder_array[0] =~ s/(\w)\s(\w)/$1_$2/g;#connects testname dashes
	     foreach my $tmps (@site2_file2)
	     {
	     	@holder_array2 = split(/</, $tmps);
	        $holder_array2[0] =~ s/\d+\s+//;#removes the testnumbers
	        $holder_array2[0] =~ s/(\w)\s(\w)/$1_$2/g;#connects testname dashes
	     	
		if($holder_array[0] eq $holder_array2[0])
		{
			$match =1;
		}
	     }
	     if($match == 0)
	     { 
	     	$match_count++;
	     	print OUTFILE $tmp;
	     }
	}
	print OUTFILE "\tTotal unmatched: $match_count\n\n";
}

##################Checks two datalogs for un matched test numbers
sub match_two_dl_testnumbers{
	
	my $match=0;
	my $match_count=0;
	print OUTFILE "UNMATCHING TESTNUMBERS FROM $inputfile TO $inputfile2\n";
	
	foreach my $tmp (@site1)
	{
	$match=0;
	     @holder_array = split(/\s+/, $tmp);
	     foreach my $tmps (@site1_file2)
	     {
	     	@holder_array2 = split(/\s+/, $tmps);
	      	if($holder_array[0] == $holder_array2[0])
		{
			$match =1;
		}
	     }
	    if($match == 0)
	    { 
	    	$match_count++;
	    	print OUTFILE $tmp;
	    }
	}
	
	foreach my $tmp (@site2)
	{
	$match=0;
	     @holder_array = split(/\s+/, $tmp);
	     foreach my $tmps (@site2_file2)
	     {
	     	@holder_array2 = split(/\s+/, $tmps);
	      	if($holder_array[0] == $holder_array2[0])
		{
			$match =1;
		}
	     }
	     if($match == 0)
	     { 
	     	$match_count++;
	     	print OUTFILE $tmp;
	     }
	}
	print OUTFILE "\tTotal unmatched: $match_count\n";
}

#############################Check test numbers
sub check_test_numbers{

my(@site) = @_;
my $repeats=0;
print OUTFILE "\nTESTNUMBER COLLISION:\n";	

    @testnumber = sort @site;
  #  print @testnumber;
    my $sizearray= @testnumber;

	for(my $i =0;$i<=$sizearray;$i++)
	{
		 if($testnumber[$i] == $testnumber[$i+1])
	 	 {
			print OUTFILE $testnumber[$i];
			print OUTFILE $testnumber[$i+1];
			$repeats ++;
		 }
	}
print OUTFILE "\t$repeats TOTAL COLLISION\n\n";
}

########################Checks for missing test site to site
sub site_to_site_check{
 #compare for site1 data
 my $mis_match1=0;

 print OUTFILE "\nMISSING/ MISMATCH TESTS FROM SITE1 TO SITE 2:\n";

 foreach my $site1_tmp(@site1)
 {
         my $flag =0;
	 @holder_array = split(/\s+/, $site1_tmp);

	 foreach my $site2_tmp (@site2)
	 {

	    my @holder_array2 =  split(/\s+/, $site2_tmp);
		print $holder_array[0];
	    if($holder_array[0] eq $holder_array2[0] and $holder_array[1]  eq $holder_array2[1])
	    {
	      $flag =1;
	     }
	 }

	 if( $flag ==0)
	 {
	       print OUTFILE "\t$site1_tmp";
	       $mis_match1++;
	 }

 }

 print OUTFILE "\tTotal differences:  $mis_match1\n\n\n";
 print OUTFILE "MISSING/ MISMATCH TESTS FROM SITE2 TO SITE 1:\n";
 #compare for site2 data
 my $mis_match2=0;
 foreach my $site2_tmp(@site2)
 {
         my $flag =0;
	 my @holder_array2 = split(/\s+/, $site2_tmp);

	 foreach my $site1_tmp (@site1)
	 {

	    my @holder_array =  split(/\s+/, $site1_tmp);

	    if($holder_array2[0] eq $holder_array[0] and $holder_array2[1]  eq $holder_array[1])
	    {
	      $flag =1;
	     }
	 }

	 if( $flag ==0)
	 {
	       print OUTFILE "\t$site2_tmp";
	       $mis_match2 ++;
	 }

 }

 print OUTFILE "\tTotal differences:  $mis_match2\n\n\n";
 
}

################ Usage information
sub usage {
print STDOUT "\n
$0    v1.1    for 93000 SOC tester
    created by Bryan Gonzalez Verigy LTD -  8/9/2007
   
Purpose:
    Analyze datalog for:
    	Test-number collisions
	Missing test from site to site
	
    Compares two datalogs for:
	Mismatched test-numbers
	Mismatched test-names
	Mismatched test limits
	 
Usage example:
    $0  <Datalog1.data> <Datalog2.Data> 

Usage output:
     Datalog1.data_diff
 
Sample Output:
    Datalog Analyzer v1.0 by Bryan Gonzalez, Verigy LTD.
INPUT FILE:  bcm6348A2_Jul_30.data:

TESTNUMBER COLLISION:
1000   extloop                           0.500      <        0      <    1.500       Site:1 (F)
1000   t_178_tvx                         0.500      <        0      <    1.500       Site:1 (F)
	2 TOTAL COLLISION

TESTNUMBER COLLISION:
1000   extloop                           0.500      <        0      <    1.500       Site:2 (F)
1000   t_178_tvx                         0.500      <        0      <    1.500       Site:2 (F)
	2 TOTAL COLLISION

MISSING/ MISMATCH TESTS FROM SITE1 TO SITE 2:
	218    vreg1 2.5v 100mA                  2.300 V   <=        0 V   <=    2.700 V     Site:1 (F)
	219    vreg2 1.2v 100mA                  1.000 V   <=        0 V   <=    1.300 V     Site:1 (F)
	Total differences:  2

MISSING/ MISMATCH TESTS FROM SITE2 TO SITE 1:
	202    vreg1 2.5v 200mA                  2.300 V   <=        0 V   <=    2.700 V     Site:2 (F)
	203    vreg2 1.2v 200mA                  1.000 V   <=        0 V   <=    1.300 V     Site:2 (F)
	Total differences:  2

UNMATCHING TESTNUMBERS FROM bcm6348A2_Jul_30.data TO bcm6348.data
2      IO_CONT                           1.000     <=        1     <=    1.000       Site:1
2      IO_CONT                           1.000     <=        1     <=    1.000       Site:2
10     1.2v Power                        0.000 mW  <= 198.2845 mW  <=  450.000 mW    Site:2
	Total unmatched: 3

UNMATCHING TESTSUITE NAMES FROM bcm6348A2_Jul_30.data TO bcm6348.data
14     leakage_pu                        1.000     <=        1     <=    1.000       Site:1
22     emac_4                            0.500      <        0      <    1.500       Site:2 (F)
	Total unmatched: 2

Note: Please Fix any test-number problems first.
      As this may give a false positive.
LIMITS MISMATCH FROM bcm6348A2_Jul_30.data TO bcm6348.data
7      PLL current                     -10.000 mA  <= 31.6751 mA  <=   80.000 mA    Site:1
	Total unmatched: 1

END OF FILE 
	  
\n";exit}


sub errorMessage{
	print STDOUT "\n"."\t \a ERROR: file can not be found or does not exist.\n";
	exit;
}
###################################################################
###                  Bryan Gonzalez                             ### 
###                github.com/rbgonzalez                        ###
###	               Aug 7, 2007                              ###
###           gonzalez.bryan@gmail.com            	        ###
################################################################### 
