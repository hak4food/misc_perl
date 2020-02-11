#!/usr/bin/perl


### VARS ### 
my $sz_argv;
my $dir;
my @vectors_arrary;
$sz_argv =@ARGV;

my $pin_config = $ARGV[0];
my $label = $ARGV[1];

&usage unless (@ARGV >= 1);
sub usage {
print STDOUT "\n
$0    v0.1    for 93000 SOC tester
    created by Bryan Gonzalez -  6/11/2011
   
Purpose:
	Converts directory to UMM.  
    
Usage example:
    $0  <pinconfiguration> <dir>

Usage example:
    $0   /path/filename.pin /path/vector/label

Example output:   
	
\n";exit}

### MAIN ###
if(-e "/opt/93000/aif/converter/bin/conv_vector"){

}else{

	print "Please install the AIF tool!";
	print "/projects/aif_5.4.12-1-0.el5.i386.rpm";
	exit;

}




		my $valid_pattern =0;
		my $flag_gz =0;
		
		if($label =~ /gz/){
			print "uncompressing: \t".$label;
			$flag_gz =1;
			system("gunzip $label");
			$label=~ s/\.gz//g;
			print "\n".$label;
		}
		
		open(INFILE, "< $label") ;
		while($line = <INFILE>)
		{
			
			if($line =~ /hp93000,vector,0.1/){ 
				$line = <INFILE>;
				if($line =~ /DMAS/){
					$valid_pattern =1;
					last;
				}
			
			
			}
			
		
		}
		
		if($valid_pattern == 1){
		
		print "Converting $_ to UMM"."\n";
		print "\t\/opt\/93000\/aif\/converter\/bin\/conv_vector \-p $pin_config \-target UMM $label $label.UMM\n";
		system("\/opt\/93000\/aif\/converter\/bin\/conv_vector \-p $pin_config \-target UMM $label $label.UMM"); #or die "Convertion failed at $_ \n";
		sleep 1;
		print "mv $label.UMM $label\n";
		system("mv $label.UMM $label");
		sleep 1;


		}
		
		if($flag_gz ==1){
			sleep 1;
			system("gzip $label");
			sleep 1;
		}	

exit;
### sub routines#### 
sub pwd{
    open PING, "pwd |";
 	while ( defined( my $line = <PING> )  ) {
		  chomp($line);
		  print "Do you want to convert $line directory and it's sub-directories? \t\n\t>";
		  my $answer = <STDIN>;
		  chomp $answer;
       		  	if($answer eq "yes" ||$answer eq "Yes" || $answer eq "YES" || $answer eq "y" || $answer eq "Y"){
			$dir =$line;

			}else{ exit; }
			
	}
	
    close PING;	

	
	
} 

sub populate_arrray_directory{
	#print $dir."#####################################";
	open PING, "ls $dir |";
		while ( defined( my $line = <PING> )  ) {
			chomp($line);
			if($line =~ /pmf/){
				push(@vectors_arrary,"$dir/$line");
			}
		
		}
		
	close PING;
	    &clean_list;
}

sub clean_list{	
	my $size  = @vectors_arrary;
	
	for(my $i=0; $i < $size;$i++){
			
			 my $file = "$vectors_arrary[$i]";
		if (-f $file) {
	 		#print $vectors_arrary[$i]."here1";
		}
		if(-d $file){
			#print $vectors_arrary[$i]."\n";
			$dir = $vectors_arrary[$i];
			#print $dir."#####################################";
			undef $vectors_arrary[$i];
			&populate_arrray_directory;

		}
	
	}
}

