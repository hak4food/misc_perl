#!/usr/bin/perl

&usage unless (@ARGV >= 1);
sub usage {
print STDOUT "\n
$0    v0.1    for 93000 SOC tester
    Created by Bryan Gonzalez  -  5/23/2010
   
Purpose:
    Checks timing file for un-used wavetables. The scripts looks at defined
    wavetables and cross checks the SPECIFICATIONS then outputs 
    the un-used ones.. 
    
    
Usage example:
    $0  <Orignal.tim> 
     
Usage example:
    $0   BRCMXXXX.tim > 2

Example Output: 

Un-used wavetables:
 SCAN_wav
 pJTAG debug wavetable
 debug wavetable

	  
\n";exit}



my $wavetable;
my $spec_wavetable;
my $file = $ARGV[0];


	open(READ, "< $file") || die;
		while(my $line = <READ>){
			
		 	if($line =~ "EQSP TIM,WVT"){
			
				while (defined ($line = <READ>) and ($line !~ m{@} ))
	  			{
				 if($line =~ /WAVETBL/){
					chomp($line);
					$line =~ s/"//g;
					$line =~ s/WAVETBL//g;
					#print $line."\n";
					push(@wavetable,$line);
				 }	
					
				}
			 }		
		
		}
		
close READ;




	open(READ, "< $file");
		while(my $line = <READ>){
		 	if($line=~ /EQSP TIM,SPS/){
				while (defined ($line = <READ>) and ($line !~ m{@} ))
	  			{
				 if($line =~ /WAVETBL/){
					chomp($line);
					$line =~ s/"//g;
					$line =~ s/WAVETBL//g;
					#print $line."\n";
					push(@spec_wavetable,$line);
				 }	
					
				}
			 }		
		
		}
		
close READ;

print "\nWAVETABLES DEFINED:\n";
my %hash1   = map { $_ => 1 } @wavetable;
my @unique_wavetable = keys %hash1;
foreach(@unique_wavetable) {print $_."\n";}

print "\nWAVETABLES CALLED IN SPEC CALLED :\n";
my %hash   = map { $_ => 1 } @spec_wavetable;
my @unique_spec_wavetable = keys %hash;
foreach(@unique_spec_wavetable) {print $_."\n";}



		
my @isect = ( );
my @diff  = ( );
my %count = ( );
my $item;

foreach $item (@unique_spec_wavetable, @unique_wavetable) { $count{$item}++;}

foreach $item (keys %count) {
    if ($count{$item} == 2) {
        push @isect, $item;
    } else {
        push @diff, $item;
    }
}

print "\nUn-used wavetables:\n";
foreach(@diff){

print $_."\n";
}
