#!/usr/bin/perl
#Bryan Gonzalez, Verigy LTD.
#use strict;      # a good idea for all non-trivial Perl scripts

#convert datalog.txt file to summary file. 


my @device= ();
my $bin1_device= 0;
my $num_test_devices= 0;
my $yield = 0;
my @lot_ary;
my $lot;
my $tester;
my $temper;
my $date;
my @site_data;

open(INFILE, "< $ARGV[0]")  || &errorMessage;
my $lineDummy = <INFILE>;
$date = <INFILE>;

while(my $line1 = <INFILE>)
{
  if($line1 =~ m{^Device}){  
     $device[$idx] =   $line1;
     $idx++;	  
  }elsif($line1 =~ m{\s+Lot:\s+}){
     $lot = $line1;
  }elsif($line1 =~ m{\s+Tester:}){
     $tester = $line1;
  }elsif($line1 =~ m{\s+Test\sTemperature:}){
     $temper = $line1;
  }
     #my $line2 = <INFILE>;
     #my @tmp = split(/Date:/,$line2);
     

}
close INFILE;
 
   
     @fmt_lot[0]  = "___________________________________________________________\n";
     @fmt_lot[1]  = "SUMMARY 		         $date\t $time\n";
     @fmt_lot[2]  = "$lot";
     @fmt_lot[3]  = "$tester";
     @fmt_lot[4]  = "$temper";
     @fmt_lot[5]  = "\t      Tester Type:  V93K\n";



foreach(@device)
{
   if($_ =~ /^Device/){
   	if($_ =~ /Bin/){
	$num_test_devices++; 
	}
   }
}

foreach(@device){
	my @tmp_array = split (/\s+/,$_);
	#print STDOUT $tmp_array[4];
	if($tmp_array[4] eq 1){ $bin1_device++;}
}

print @fmt_lot;
print " Number of devices tested: $num_test_devices";
if($bin1_device > 0 ){
	
	$yield = ($bin1_device / $num_test_devices)*100;
	
	print "\nDevice Yield = ";
	printf ("%1.3f", $yield);
	print "%\n";
}else{
	print "\n\t    Device Yield : 0\% \n";
}
print "___________________________________________________________\n";
print "BREAKDOWN";
my $b1=0;
my $b2=0;
my $b3=0;
my $b4=0;
my $b5=0;
my $b6=0;
my $b7=0;
my $b8=0;
my $b9=0;

my @hBin1;
my @hBin2;
my @hBin3;
my @hBin4;
my @hBin5;
my @hBin6;
my @hBin7;
my @hBin8;
my @hBin9;

my $siteNum;
my $softBinNum;
my $softBinNum;


foreach(@device){
	$_ =~ s/\)//g;
	$_ =~ s/\(//g;

	my @tmp_array = split (/\s+/,$_);
		
	$tmp_array[8] =~ s/\)//g;
	if($tmp_array[4] eq 1){ $b1++;push(@hBin1, $tmp_array[7].$tmp_array[8]);}
	if($tmp_array[4] eq 2){ $b2++;push(@hBin2, $tmp_array[7].$tmp_array[8]);}
	if($tmp_array[4] eq 3){ $b3++;push(@hBin3, $tmp_array[7].$tmp_array[8]);}
	if($tmp_array[4] eq 4){ $b4++;push(@hBin4, $tmp_array[7].$tmp_array[8]);}
	if($tmp_array[4] eq 5){ $b5++;push(@hBin5, $tmp_array[7].$tmp_array[8]);}
	if($tmp_array[4] eq 6){ $b6++;push(@hBin6, $tmp_array[7].$tmp_array[8]);}
	if($tmp_array[4] eq 7){ $b7++;push(@hBin7, $tmp_array[7].$tmp_array[8]);}
	if($tmp_array[4] eq 8){ $b8++;push(@hBin8, $tmp_array[7].$tmp_array[8]);}
	if($tmp_array[4] eq 9){ $b9++;push(@hBin9, $tmp_array[7].$tmp_array[8]);}
	
}
print STDOUT "\nHard Bins\t     #################################\n";
if($b1 > 0){ print STDOUT "\tHardBin 1:\t\t\t\t$b1\n";}
if($b2 > 0){ print STDOUT "\tHardBin 2:\t\t\t\t$b2\n";}
if($b3 > 0){ print STDOUT "\tHardBin 3:\t\t\t\t$b3\n";}
if($b4 > 0){ print STDOUT "\tHardBin 4:\t\t\t\t$b4\n";}
if($b5 > 0){ print STDOUT "\tHardBin 5:\t\t\t\t$b5\n";}
if($b6 > 0){ print STDOUT "\tHardBin 6:\t\t\t\t$b6\n";}
if($b7 > 0){ print STDOUT "\tHardBin 7:\t\t\t\t$b7\n";}
if($b8 > 0){ print STDOUT "\tHardBin 8:\t\t\t\t$b8\n";}
if($b9 > 0){ print STDOUT "\tHardBin 9:\t\t\t\t$b9\n";}

if(my $c = @hBin2 !=0){
	print STDOUT "\nSoftBin in HardBin 2 ################################# \n";
	my ($temp, $count) = ("@hBin2", 0);
	($count = $temp =~ s/($_)//g) and printf "\tfailCount:%3d: SoftBin:%s\n", $count, $_ for @hBin2;
}

if(my $c = @hBin3 !=0){
	print STDOUT "\nSoftBin in HardBin 3 #################################\n";
	my ($temp, $count) = ("@hBin3", 0);
	($count = $temp =~ s/($_)//g) and printf "\tfailCount:%3d: SoftBin:%s\n", $count, $_ for @hBin3;
}

if(my $c = @hBin4 !=0){
	print STDOUT "\nSoftBin in HardBin 4 #################################\n";
	my ($temp, $count) = ("@hBin4", 0);
	($count = $temp =~ s/($_)//g) and printf "\tfailCount:%3d: SoftBin:%s\n", $count, $_ for @hBin4;
}

if(my $c = @hBin5 !=0){
	print STDOUT "\nSoftBin in HardBin 5 #################################\n";
	my ($temp, $count) = ("@hBin5", 0);
	($count = $temp =~ s/($_)//g) and printf "\tfailCount:%3d: SoftBin:%s\n", $count, $_ for @hBin5;
}
if(my $c = @hBin6 !=0){
	print STDOUT "\nSoftBin in HardBin 6 #################################\n";
	my ($temp, $count) = ("@hBin6", 0);
	($count = $temp =~ s/($_)//g) and printf "\tfailCount:%3d: SoftBin:%s\n", $count, $_ for @hBin6;
}

if(my $c = @hBin7 !=0){
	print STDOUT "\nSoftBin in HardBin 7 #################################\n";
	my ($temp, $count) = ("@hBin7", 0);
	($count = $temp =~ s/($_)//g) and printf "\tfailCount:%3d: SoftBin:%s\n", $count, $_ for @hBin7;
}

if(my $c = @hBin8 !=0){
	print STDOUT "\nSoftBin in HardBin 8 #################################\n";
	my ($temp, $count) = ("@hBin8", 0);
	($count = $temp =~ s/($_)//g) and printf "\tfailCount:%3d: SoftBin:%s\n", $count, $_ for @hBin8;
}

if(my $c = @hBin9 !=0){
	print STDOUT "SoftBin in HardBin 9 #################################\n";
	my ($temp, $count) = ("@hBin9", 0);
	($count = $temp =~ s/($_)//g) and printf "\tfailCount:%3d: SoftBin:%s\n", $count, $_ for @hBin9;
}


#for(@hBin4){
#	print STDOUT $_."\n";
#}

sub errorMessage{
	print STDOUT "\n"."\t \a ERROR: file can not be found or does not exist.\n";
	exit;
}


###################################################################
###                  Bryan Gonzalez                             ### 
###               github.com/rbgonzalez                         ###
###	              July 13, 2018                             ###
###           gonzalez.bryan@gmail.com     	                ###
################################################################### 
