#!/usr/bin/perl
use strict;
use warnings;

my $debug=1;

&usage unless (@ARGV>=2);

my $input_hex = shift(@ARGV);
my $input_inst = shift(@ARGV);
my ($op_code, $sr,$tr,$dr,$shift_amt,$funct);
my %instructions;

&read_instr;
&anal_instr;

sub anal_instr{

	open(INFILE, "< $input_hex") || &errorMessage;
		 while (my $line=<INFILE>){
			$line=~s/0x//g;
			my ($bin) = unpack('B32',pack('H*',$line)); 
			my @bin_a =split(//,$bin);
			
			$funct  = $bin_a[26].$bin_a[27].$bin_a[28].$bin_a[29].$bin_a[30].$bin_a[31];
			$shift_amt = $bin_a[21].$bin_a[22].$bin_a[23].$bin_a[24].$bin_a[25];
			$dr = $bin_a[16].$bin_a[17].$bin_a[18].$bin_a[19].$bin_a[20];
			$tr = $bin_a[11].$bin_a[12].$bin_a[13].$bin_a[14].$bin_a[15];
			$sr =$bin_a[6].$bin_a[7].$bin_a[8].$bin_a[9].$bin_a[10];
			$op_code =$bin_a[0].$bin_a[1].$bin_a[2].$bin_a[3].$bin_a[4].$bin_a[5];
			
			if($debug){
				print "Hex value: ".$line."Binary: ".$bin."\n";
				print "\topcode: \t".$op_code."\n"."\tsrc reg: \t".$sr."\n";
				print "\ts src reg: \t".$tr."\n"."\tdes reg: \t".$dr."\n";
				print "\tshift amt: \t".$shift_amt."\n"."\tfunc: \t\t".$funct."\n\n";
			}
		 }
	close INFILE;
	
}
sub errorMessage{
	print STDOUT "\n"."\t \a ERROR: file can not be found or does not exist.\n";
	exit;
}

sub read_instr{
	my @tmp;
	open(INFILE, "< $input_inst") || &errorMessage;
		while (my $line=<INFILE>){
			push(@tmp, split(/\s+/,$line));	
		}
		%instructions=@tmp;
	close INFILE;
	
	foreach my $item (sort keys (%instructions)) {
	  if($debug) { print $item . " = " . $instructions{$item} . "\n"; }
	}
}

sub usage{

print STDOUT "\n
$0    v1.1    
    created by Bryan Gonzalez  -  2/9/2014
   
Purpose:
  Calculate total CPU time required in cycles and nanoseconds
	 
Usage example:
    $0  <trace.txt> <instruction.txt> "; 
exit;
}

__END__
###################################################################
###                  Bryan Gonzalez                             ### 
###	               Feb 4, 2014                              ###
###              gonzalez.bryan@gmail.com                       ###
################################################################### 
