#!/usr/bin/perl

&usage unless (@ARGV >= 1);
sub usage {
print STDOUT "\n
$0    v0.1    for 93000 SOC tester
    created by Bryan Gonzalez   -  12/15/2012
   
Purpose:
	mask pins for functional compare.  
    
Usage example:
    $0  pinname

Usage example:
    $0   DDR_CS_N 

\n";exit}


my $pinlist = $ARGV[0];

&hpt("SREC X,\(@\);SREC ACT,\($pinlist\)");


#print "SREC X,\(@\);SREC ACT,\($pinlist\)";
sub hpt (@_) { 
	my $line=shift;
	return unless (length($line));
	return (`echo '$line' | /opt/hp93000/soc/fw/bin/hpt -q`);

}
