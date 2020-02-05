#!/usr/bin/perl

my $line;
&whoami;

sub whoami{

   open DATA, "whoami |"   or die "Couldn't execute program: $!";
   while ( defined($line = <DATA> )  ) {
     
     chomp($line);
     system("rm /home/$line/.mozilla/firefox/*default/lock");
     system("rm /home/$line/.mozilla/firefox/*default/.parentlock");
     system("mv /home/$line/.mozilla/firefox/*default/places.sqlite /home/$line/.mozilla/firefox/*default*/places.sqlite.old");
     system("mv /home/$line/.mozilla/firefox/*default/places.sqlite-journal /home/$line/.mozilla/firefox/*default*/places.sqlite-journal.old");
     print $line;
     
   }
   print $line;
   close DATA;

}

###################################################################
###                  Bryan Gonzalez                             ### 
###               github.com/rbgonzalez                         ###
###	              July 23, 2008                             ###
###           gonzalez.bryan@gmail.com     	                ###
################################################################### 
