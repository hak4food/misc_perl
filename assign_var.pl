#!/usr/bin/perl 
use warnings;
use strict;

my $assigned_var = "\t\t\@BINNING = 0;\n";   

&usage unless (@ARGV == 1);
sub usage {
print "\n
$0    v1.0    for 93000 SOC tester
    created by Bryan Gonzalez - -  5/1/2008
    
Purpose:
    Gives report on testfunctions, testmethods, and userprocedures used
    Ignores any testsuites that are not actually in the testflow.
    
Usage example:
    $0  testflow


";
exit;}

open (OUTFILE, "> $ARGV[0].tmp") or die "ERROR: Cannot open file for writing:  $ARGV[0].tmp\n\n";
open (INFILE, "< $ARGV[0]") or die "ERROR: Cannot open file for reading:  $ARGV[0]\n\n";   

while (my $line = <INFILE> ) {
    if ( $line =~ m{^test_flow} ) {
     print OUTFILE $line;
     $line = <INFILE> ;
        while (defined ($line = <INFILE>) and ($line !~ m{^end} )) {
                if($line =~ "stop_bin" && $line !~ "\"1\"")
	        {
		    print OUTFILE $assigned_var;
		    print OUTFILE $line;
		
	        }else{print OUTFILE $line;}
        }
	print OUTFILE $line;
     }else {print OUTFILE $line;}
}
close OUTFILE;
close INFILE;
