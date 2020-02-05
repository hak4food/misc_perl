#!/usr/bin/perl

use File::Find;
use strict;


&usage unless (@ARGV >= 1);

open PWD, "pwd|";
	my @mytemp = split(/\s+/,<PWD>);
close PWD;


my $dir = $ARGV[0];
my $size;
find(sub{ -f and ( $size += -s ) }, $dir );
$size = sprintf("%.02f",$size / 1024 / 1024);
print "Directory '$dir' contains $size MB\n";

sub usage {
print STDOUT "\n
$0    v1.1    for linux
    created by Bryan Gonzalez Verigy LTD -  3/12/2013
   
Purpose:
    Analyze file directory size.
	 
Usage example:
    $0  </full_path/> 
    
Usage output:
Directory '/projects/bryang' contains 27081.63 MB

	  
\n";exit}
