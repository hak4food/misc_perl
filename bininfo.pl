#!/usr/bin/perl
#Bryan Gonzalez.

my $numberOfArgs = @ARGV;
#Information on script
if($numberOfArgs == 0){&usage;}

if ($ARGV[1] eq "-all"){my $print_all=1;}
else{my $print_all=0;}

my $inputfile=$ARGV[0];
my $idx =0;

open(INFILE, "< $inputfile")  || &errorMessage;
while($line = <INFILE>)
{
  if($line=~ /^test_flow/){
          while (defined ($line = <INFILE>) and ($line !~ m{^end} ))
	  {
	  	                       #stop_bin "5", "CONTINUITY", , bad,noreprobe,red, 5, over_on;
		  if ( $line =~ m{^\s+(stop_bin)\s(.*),\s\"(.*)\"(.*)} ) 
		  {
		  	$bin_array[$idx] = $line;
			$idx++;
		  }

	  }	  
   }
}   
close INFILE;

print "SB_#\t\tBin_type\t\t Bin_Name\t HW_Bin\n";

if($print_all){
   foreach my $tmp_k (@bin_array)
   {
	   my @tmp_print = split(',',$tmp_k);
	   #example
	   # @tmp_print[0] = stop_bin "12"; 
	   # @tmp_print[1] =  "FAIL_SCAN";
	   # @tmp_print[2] = ;
	   # @tmp_print[3] = bad;
	   # @tmp_print[4] = noreprobe;
	   # @tmp_print[5] = red;
	   # @tmp_print[6] = 3;
	   # @tmp_print[7] = over_on;
	   my @new_tmp = split (" ",$tmp_print[0]);

   }
}
if(!$print_all){
foreach  (@bin_array)
{
  $_ =~ s/\s+//;
  my @tmp_print = split(',',$_);
  my @new_tmp = split (" ",$tmp_print[0]);
  $new_tmp[1] =~ s/\"//g;
  $tmp_print[1] =~ s/\"//g;
  my $length = length ($tmp_print[1]);
  if($length < 8){$_ = "$new_tmp[1]\t\t$new_tmp[0]\t\t$tmp_print[1]\t\t$tmp_print[6]\n";}
  else
  {
  	$_ = "$new_tmp[1]\t\t$new_tmp[0]\t\t$tmp_print[1]\t$tmp_print[6]\n";
  }
}
   
   @bin_array=sort(@bin_array);
   $idx = @bin_array;
  
  for($i=0; $i<$idx; $i=$i+1)
  {
   if($bin_array[$i] ne $bin_array[$i+1] )
   {
   	print $bin_array[$i];
   }
  } 
}   
		    
sub errorMessage{
	print STDOUT "\n"."\t \a ERROR: file can not be found or does not exist.\n";
	exit;
}
sub usage {
print STDOUT "\n
$0    v1.0    for 93000 SOC tester
    created by Bryan Gonzalez  -  10/10/2007
    
Purpose:
   Gets binning information from the testflow. 
    	 
Usage example:
    $0  testflow.ttf 
	  
\n";exit}

###################################################################
###                  Bryan Gonzalez                             ### 
###	               Oct. 10, 2007                                ###
################################################################### 
