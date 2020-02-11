#!/usr/bin/perl -w

&hostname;


sub hostname{
   
   open DATA, "hostname |"   or die "Couldn't execute program: $!";
   while ( defined( my $line = <DATA> )  ) {
     chomp($line);
     system "more ~/.device_inuse_soc\@$line";
   }
   close DATA;
   print "\n";

}


###################################################################
###                  Bryan Gonzalez                             ### 
###	              March 23, 2012                                ###
################################################################### 
