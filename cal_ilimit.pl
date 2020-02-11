#!/usr/bin/perl
my $line = "DFPS\? \(\@\)";
my @line_arrray1;
my @line_arrray2;
my $file =$ARGV[0];


open TESTER, "echo '$line' | /opt/hp93000/soc/fw/bin/hpt -q |";
while ( defined( my $line = <TESTER> )  ) {

	#DFPS 22514,POS,(VDDD_DDR_1P8)
	#DFPS 22510,POS,(DDR_VREF)
	my @ans = split("POS",$line);
	#print "$ans[0]\n";
	my @arr = split(/,/,$ans[0]);
	
	my $dps_count = @arr;
	$ans[1] =~ s/,|\(|\)|\n//g;

	print "number of dps $dps_count in pin $ans[1]\n";

	push(@line_arrray1,$ans[1]);
	push(@line_arrray2,$dps_count);	
}

close TESTER;


my $sz = @line_arrray1;

if ( -e $file){
 open(OUTFILE, "> $file.log");
 open(READ, "< $file");
 	while(my $lines = <READ>)
	{
		if($lines =~ m/DPSPINS/g){
			my $ilim =0;
			print OUTFILE $lines;
			print  $lines;
			for($i=0; $i<=$sz;$i++){
				if($lines =~ m/$line_arrray1[$i]/g){
					$ilim =$line_arrray2[$i];
					print $ilim;
				}
			}
			
			while(($lines = <READ>) and ($lines !~ m{^t_ms} )){
				if($lines =~ /ilimit/){
					print $lines;
					if($ilim eq "1"){
						print OUTFILE "ilimit = 1200\n";
					}elsif($ilim eq "2"){
						print OUTFILE "ilimit = 2400\n";
					}elsif($ilim eq "3"){
						print OUTFILE "ilimit = 3500\n";
					}else{
						print $ilim;
						print OUTFILE "ilimit = 1200\n";
					}
					
					
				}else{print OUTFILE $lines;}
			
			}
		    	
		}else{print OUTFILE $lines;}
		
	}

 close READ; 
 close OUTFILE; 
}
