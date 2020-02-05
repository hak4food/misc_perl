#!/usr/bin/perl 


my $user = $ARGV[0];

open TESTER, "ps -ef | grep $user|";
while ( defined( my $line = <TESTER> )  ) {
	  	     
	     my @tmp=split(/\s+/,$line);
	     
	     if($tmp[1] > 9999){
	     system("kill $tmp[1]\n");
     }
}

close TESTER;



###################################################################
###                  Bryan Gonzalez                             ### 
###               github.com/rbgonzalez                         ###
###	              July 23, 2018                             ###
###           gonzalez.bryan@gmail.com     	                ###
################################################################### 
