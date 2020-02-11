#!/usr/bin/perl

&usage unless (@ARGV << 2);
sub usage {
print STDOUT "\n
$0    v1.0    for 93000 SOC tester
    
    Bryan Gonzalez  -  8/6/2007
   
Purpose:
    Creates alias from .cmd file to *.bv. 
    
Usage example:
    $0  <infile.cmd> <infile.bv> 

Usage example:
    $0    <infile.cmd> <infile.bv>
    
Usage output:
     infile.bv_alias
	  
\n";exit}

my $infile  = $ARGV[0];
print STDOUT "\nReading *.cmd file: $infile\n";
my $infile2 = $ARGV[1];
my $outfile = $ARGV[1] . "_alias";
print STDOUT "Writing file :$outfile\n";

my @alias;
my $alias_count =0;


open(FILEREAD, "< $infile") || &errorMessage;

while (my $line = <FILEREAD>)
{
	if ($line =~ /^ALIAS/ )
	{
	  while (defined ($line = <FILEREAD>) and  ($line !~ m{^end;} )) 
	  {
	  
	  	$alias[$alias_count] = $line;
		$alias_count++;
	  }
	}
}

foreach my $tmp (@alias)
{
			 $tmp=~ s/,//;
			 $tmp=~ s/;//;
			 $tmp=~s/\s+//;
			 $tmp=~s/\s+//;
			 $tmp=~s/\s+//;
			 $tmp=~s/end//;
			 chomp $tmp;

}
my $size_alias = @alias;

if( $size_alias == 0)
{
	print "Error: *.cmd file could not be read\n";
	exit;
	 
}
close FILEREAD;

print STDOUT @alias;
open(FILEWRITE, "> $outfile") || &errorMessage;
open(FILEREAD, "< $infile2") || &errorMessage;
my @tmp_array;
while (my $line = <FILEREAD>)
{
 if ($line =~ /\/\/\swidth\s\d+/)
 {
 print FILEWRITE $line;
 	while(defined ($line = <FILEREAD>) and  ($line !~ m{end} ))
	{
		my $flag1=0;
		my $tmp_lin = $line;
		$line =~ s/\/\/\spindef\s//;
		
		@tmp_array = split(/\:/, $line);
		print "tmp_array[0] $tmp_array[0]\n";
		
		$tmp_array[0] =~ s/\s+//;
		foreach my $tmp (@alias)
		{
			my @ha = split (/=/,$tmp);
			
			
			if ($tmp_array[0] eq $ha[0])
			{
			print FILEWRITE "\/\/ pindef $ha[1] :$tmp_array[1] :$tmp_array[2] :$tmp_array[3] :$tmp_array[4] :$tmp_array[5] :$tmp_array[6]";
			$flag1=1;
			}
		}
		
		if($flag1 == 0)
		{
		print FILEWRITE $tmp_lin;
		}
		
	}
	print FILEWRITE $line;	
	
 }else
 {
 print FILEWRITE $line;
 }
}

close FILEREAD;
close FILEWRITE;



sub errorMessage{
	print STDOUT "\n"."\t \a ERROR: file can not be found or does not exist.\n";
	exit;
}


