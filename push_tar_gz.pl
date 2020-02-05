#!/usr/bin/perl
use warnings;
use strict;

my $FullPathInputFile = $ARGV[0];
my @InputFileName     = split(/\//,$FullPathInputFile);
my $FileName 	      =  $InputFileName[-1];
my $FullPathPmf       = $ARGV[1];
my $FullPathVector  = &findDirectory("vectors");

my @BASENAME  = split(/\./,$FullPathInputFile);
my $sz = @BASENAME;

if($sz > 2){
	&errorMessage("Invalid Inputfile. Contains too many dots in name\n");
	exit;
}
my $tar_file;


my $file1;
my $file2;
my $t =  localtime;



my $SWITCH;

 if ($BASENAME[1] =~ /tar\.gz/){
 	$SWITCH = 1;
 }else{
 	$SWITCH = 0;
	$tar_file = $InputFileName; 
 }



if($SWITCH == 1){
	&moveAndCopy;
	print "pushing to pmf: $FullPathPmf\n";
	&append2pmf;
	&cleanup;
}else{
	&copyBinl;
	&append2pmf;

}

sub copyBinl(){
	if(-d $location){
	  	
	}else{
		&errorMessage("directory does not exisit"."\n");
	}
	if(-e $inputFile){
		system ("cp $BASENAME[0]\.binl $location/");
		
		if( -e "$pmf_path[0]/readme.txt"){
			&readMeNotes;
		 }else{
		  	system("touch $FullPathPmf[0]/readme.txt");
			&readMeNotes;
		 }
	}
}



sub readMeNotes{
	open(OUTFILE, ">> $FullPathPmf[0]/readme.txt");
	print OUTFILE "$inputFile added $t\n";
	close OUTFILE;
}

sub moveAndCopy{

	  if(-d $location){
	  	
	  }else{
	  	print "directory does not exisit"."\n"; exit;
	  }
	  if(-e $tar_file){
		
		  if( -e "$pmf_path[0]/readme.txt"){
		  
			&readMeNotes;
		  }else{
		  	system("touch $pmf_path[0]/readme.txt");
			&readMeNotes;
			
		  }
		  if(-e $tar_file){
			  my $cmd = "tar -xvzf $tar_file";
			  print $cmd."\n";
			  system($cmd);
		  }else{
			  &errorMessage("tar file does not exisit"."\n");
		  }

		  if(-e "$BASENAME[0]\@burst"){
			  system ("cp $BASENAME[0]\@burst $location/" );
			  $file1 = "$BASENAME[0]\@burst";
			  $BASENAME[0] =~ s/MPB_//;
			  system ("cp $BASENAME[0]\.binl $location/");
			  $file2 = "$BASENAME[0]\.binl";
	  }


	  }else{
		  &errorMessage("file does not exisit: $tar_file"."\n"); 
	  }
}

sub cleanup{
	print "Cleaning up directory... \n";
	system("rm -rf *\@port_fref_1");
	system("rm -rf *\@port_fref_2");
	system("rm -rf *\@port_data");
	system("rm -rf *.patlist");
	system("rm -rf MPT_port_fref_1_6_4ns.binl");
	system("rm -rf MPT_port_fref_2_6_4ns.binl");

}


sub append2pmf{
	
	open(OUTFILE, ">> $my_pmf")  || &errorMessage("$my_pmf");
	
	print OUTFILE "\n\n-- = = = = = = = = = = = = = = = = = = = = = = = = \n";
	print OUTFILE "-- 		UNSORTED - Specific\n";
	print OUTFILE "--	Added: $t\n";
	print OUTFILE "-- = = = = = = = = = = = = = = = = = = = = = = = = \n\n";
	print OUTFILE "path:\n";
	print OUTFILE "../vectors$pmf_path[1]\n\n";

	if($SWITCH){
		print OUTFILE "files:\n";
		print OUTFILE $file1."\n";
		print OUTFILE $file2."\n\n";
	}else{
		print OUTFILE "FileName:\n";
	
	}
	
	close OUTFILE;

}

sub errorMessage(){
	my ($text) = @_;
	print "ERROR:\t$text\n";
	die;

}

 sub findDirectory(){
  	my ($text) = @_;
 	my @path_device = split( /\//,$FullPathPmf);
 	my $c=0;
	my $d = 0;
 
 	foreach(@path_device){
 		if($_ =~ /$text/){
			$c++;
			last;		
		}else{
 			$c++;
		}
 	}
 
	my $devicePath = "";
	foreach(@path_device){
		if($d < $c){
	 		$devicePath = $devicePath."/".$_;
		 	$d++;
		}else{
	 		last;
		}
	}
	
	return $devicePath;
}


###################################################################
###                  Bryan Gonzalez                             ### 
###               github.com/rbgonzalez                         ###
###	              July 23, 2008                             ###
###           gonzalez.bryan@gmail.com     	                ###
################################################################### 
