#!/usr/bin/perl


### VARS ### 
my $sz_argv;
my $dir;
my @vectors_arrary;
$sz_argv =@ARGV;

my $pin_config = $ARGV[0];
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
    $0   /path/filename.pin /path/vector

Example output:   
	
\n";exit}

### MAIN ###
if(-e "/opt/93000/aif/converter/bin/conv_vector"){

}else{

	print "Please install the AIF tool!";
	print "/projects/OPSLIB/BCM_SmarTest_TOOLS/93ksw/AIF/5.4.12/aif_5.4.12-1-0.el5.i386.rpm";
	exit;

}

if(0){
#  &pwd;
}else{
		  print "Do you want to convert $ARGV[1] directory and it's sub-directories? \t\n\t>";
		  my $answer = <STDIN>;
		  chomp $answer;
       		  	if($answer eq "yes" ||$answer eq "Yes" || $answer eq "YES" || $answer eq "y" || $answer eq "Y"){

			}else{ exit; }
			
					  print "Did you make a back up of the directory? \t\n\t>";
		  $answer = <STDIN>;
		  chomp $answer;
       		  	if($answer eq "yes" ||$answer eq "Yes" || $answer eq "YES" || $answer eq "y" || $answer eq "Y"){

			}else{ exit; }
		$dir =$ARGV[1];
}

&populate_arrray_directory;

foreach(@vectors_arrary){
#print $_."\n";
}


foreach(@vectors_arrary){
	
	my $label= $_;
	if(defined){
		my $valid_pattern =0;
		my $flag_gz =0;
		
		if($_ =~ /\.gz/g){
			print "uncompressing: \t$_\n\n";
			$flag_gz =1;
			print "\ngunzip $_\n\n";
			
			
			open PIPE, "gunzip $_ |" || die;
			while ( defined( my $li = <PIPE> )  ) {
				print "closed\n";
			
			}
			close PIPE; 
			
			sleep 1;
			
			$_=~ s/\.gz//g;
			$label=~ s/\.gz//g;
			
			
			
		}
		
		open(INFILE, "< $label");
		while($line = <INFILE>)
		{
			
			
			if($line =~ /hp93000,vector/g){ 
				$line = <INFILE>;
				if($line =~ /DMAS/){
					$line = <INFILE>;
					if($line =~ /^SQLB/){
					
						if($line =~ /,BRST,/g){
							$valid_pattern =0;
							last;
						}else{$valid_pattern =1;}
					
					}
					$line = <INFILE>;
					if($line =~ /^SQLB/){
					
						if($line =~ /,BRST,/g){
							$valid_pattern =0;
							last;
						}else{$valid_pattern =1; last;}
					
					}
					#print "pattern is valid\n\n";
					;
				}
			
			
			}
			
		
		}
		if($valid_pattern == 1 ){
			print "Converting $label to UMM"."\n";
			
			print "\t\/opt\/93000\/aif\/converter\/bin\/conv_vector \-p $pin_config \-target UMM $label $label.UMM\n";
			
			system("\/opt\/93000\/aif\/converter\/bin\/conv_vector \-p $pin_config \-target UMM $label $label.UMM");
			sleep 5;
			system("mv $label.UMM $label");
			print "\nmoving $label.UMM $label\n";
			sleep 1;
		
		}

		if($flag_gz ==1){
			print "gzip $label\n\n";
			open PIPE, "gzip $label |" || die;
			while ( defined( my $li = <PIPE> )  ) {
				print "closed\n";
			
			}
			close PIPE; 
			sleep 1;
			
		}

	}
	
}


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
			
				push(@vectors_arrary,"$dir/$line");
			
		
		}
		
	close PING;
	    &clean_list;
	    print @vectors_arrary;
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

