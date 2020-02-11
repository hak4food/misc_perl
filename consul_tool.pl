#!/usr/bin/perl

use Gtk;
use Net::FTP;
use strict;

init Gtk;
set_locale Gtk;

my $false = 0;
my $true = 1;


my $result_dir = "/tmp/consul_tool";
###ftp Server info
 my $ftp_server = "server_name";
 my $ftp_username = "username";
 my $ftp_password = "password";
###filesize maximum diagnostic
   my $filesize1 = "50000000";
###filesize maximum calibration
   my $filesize2 = "50000000";
####gtk display variables
my $scrolled_window; 
my $window;
my $window1;
my $button;
my $table;
my $entry;
my $label;
#####variables for displayed data
my $uname;
my $df_text;
my $redhat;
my $smartest;
my $model;
my $host_text;
my $resolv_text;
my $free_text;
my $vmstat_text;
my @rpm;
####for storing fileread information
my $line; 
####for combo widget comparison
my $comp;
###testprogram/testflow variables
my $numclicked = "0";
my $numclicked1 = "0";
my $file;
my $prog;
my $prog1;
my $current;
####Filename varibles
my $workstation; 
my $date;
####associated with the testprogram/testflow
   my $device;
   my $testflow_testprog;
   my $pin;
   my $levels;
   my $timing;
   my $vector;
   my $attrib;
   my $analog;
   my $waveform;
   my $routing;



###########get current folder directory#############


###########
##scroll##
##########

# Create a new dialog window for the scrolled window to be
# packed into.
$window = new Gtk::Dialog();
$window->signal_connect( "destroy", sub { Gtk->exit( 0 ); } );
$window->set_title( "Consul Tool V 1.0" );
$window->border_width( 0 );
$window->set_usize( 780, 500 );
$window->set_policy ( $true, $true, $true);

$scrolled_window = new Gtk::ScrolledWindow( "", "" );
$scrolled_window->border_width( 0 );

# the policy is one of "automatic", or "always".  "automatic" will
# automatically decide whether you need scrollbars, whereas "always"
# will always leave the scrollbars there.  The first one is the
# horizontal scrollbar, the second one is the vertical scrollbar.
$scrolled_window->set_policy( "automatic", "always" );

# The dialog window is created with a vbox packed into it
$window->vbox->pack_start( $scrolled_window, $true, $true, 0 );
$scrolled_window->show();
$table = new Gtk::Table( 60, 11, $false );
$table->set_row_spacings( 0 );
$table->set_col_spacings( 0 );
    
# pack the table into the scrolled window
$scrolled_window->add_with_viewport( $table );
$table->show();
############
##scrolled##
############




#####################################
################Verigy logo##########
#####################################
my @xpm_data = ( '199 68 143 2',
'   c #EFBA38',
'.  c #F1BF2A',
'X  c #F7BD2B',
'o  c #F8BD23',
'O  c #FDBF20',
'+  c #FDBC2A',
'@  c #FEBD2F',
'#  c #F6BD3C',
'a,  c #F8BD31',
'%  c #FDB934',
'&  c #FFBF3B',
'*  c #F7BD4A',
'=  c #FEBC41',
'-  c #EAC62A',
';  c #E6C23A',
':  c #E7C03D',
'>  c #EAC433',
',  c #EFC032',
'<  c #EFC630',
'1  c #F4C422',
'2  c #F2C52A',
'3  c #F6C52A',
'4  c #FDC323',
'5  c #FEC329',
'6  c #F7C532',
'7  c #F0C53B',
'8  c #F6C53A',
'9  c #F2CB3F',
'0  c #FEC434',
'q  c #FEC33B',
'w  c #EAC543',
'e  c #EEC140',
'r  c #EEC341',
't  c #EFC34A',
'y  c #E5CA55',
'u  c #EAC75F',
'i  c #EFCA55',
'p  c #ECCB5A',
'a  c #F6C042',
's  c #F6C544',
'd  c #F7C749',
'f  c #F0CF4A',
'g  c #FFC542',
'h  c #F1C451',
'j  c #F7C951',
'k  c #F0C859',
'l  c #F4CB5F',
'z  c #F7CC59',
'x  c #F3D35A',
'c  c #EDC661',
'v  c #EDD97A',
'b  c #F7CD77',
'n  c #F0D061',
'm  c #F2D762',
'M  c #F0D069',
'N  c #F6D36B',
'B  c #F8D168',
'V  c #F0D174',
'C  c #F3D672',
'Z  c #F7D673',
'A  c #F5DD71',
'S  c #F7DE7B',
'D  c #FED374',
'F  c #F8D57B',
'G  c #A7A7A7',
'H  c #A7A6AB',
'J  c #A9A8AD',
'K  c gray68',
'L  c #AEADB3',
'P  c #B1B0B5',
'I  c gray71',
'U  c #B6B5BB',
'Y  c gray74',
'T  c #BEBDC2',
'R  c #C5BDC5',
'E  c #EED789',
'W  c #EDDB85',
'Q  c #EEDD8B',
'!  c #F1D486',
'~  c #F6DD8B',
'^  c #F9D78D',
'/  c #F8DD86',
'(  c #F1DF9D',
')  c #F6DD9A',
'_  c #FADE94',
'`  c #EEDDA5',
"'  c #F6DBAC",
']  c #F1E196',
'[  c #F6E29D',
'{  c #F6EB9B',
'}  c #F2E1A9',
'|  c #F9E0A7',
' . c #F8E6A6',
'.. c #F8E5AD',
'X. c #F7E7B4',
'o. c #FCE1B6',
'O. c #F9E6BE',
'+. c #FEE7BB',
'@. c #FCEFB8',
'#. c #FAF0BD',
'b, c #FDF1BF',
'%. c #C5C5C5',
'&. c #C7C6CB',
'*. c gray80',
'=. c #D0CFD4',
'-. c #D2D2D0',
';. c gray84',
':. c #D9D8DD',
'>. c #DAD9DE',
',. c gray87',
'<. c #E0DFE4',
'1. c #F6EBCF',
'2. c #F9EDC3',
'3. c #FCEFCD',
'4. c #FEEEDE',
'5. c #FEF4C3',
'6. c #FEF0C9',
'7. c #F7F6D7',
'8. c #F9F2D6',
'9. c #F8F4D1',
'0. c #F8F3DF',
'q. c #FCF2D9',
'w. c #FEF5D8',
'e. c #FCF4DD',
'r. c #E2E1E6',
't. c #E4E4E2',
'y. c #E7E7E7',
'u. c #E8E7EC',
'i. c #EFEFEF',
'p. c #F0EFF4',
'a. c #FFF8E6',
's. c #FFF9EF',
'd. c #FDFFEA',
'f. c #FFFEEF',
'g. c gray97',
'h. c #F7FFFF',
'j. c #F8FFF7',
'k. c #FEFAF7',
'l. c #FEFFF7',
'z. c #F9F8FD',
'x. c #FFF8FF',
'c. c gray100',
'v. c None',
#/* pixels */
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.,.*.*.t.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.%.K K ;.z.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.%.K K ;.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.%.K K ;.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.%.K K ;.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.&.L L ;.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.p.;.i.c.c.c.c.c.c.c.c.c.c.c.c.c.&.L L ;.c.c.c.c.c.c.c.c.c.c.c.c.c.z.,.g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.i.%.J &.z.c.c.c.c.c.c.c.c.c.c.c.c.%.L L ;.c.c.c.c.c.c.c.c.c.c.c.c.z.-.K %.i.z.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.-.G I K -.g.g.c.c.c.c.c.c.c.c.c.c.%.L L ;.c.c.c.c.c.c.c.c.c.c.c.c.-.J L G :.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.p.*.G L L -.c.c.c.c.c.c.c.c.c.c.c.%.L L ;.c.c.c.c.c.c.c.c.c.c.c.*.K K K ;.g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.g.T G K K ,.c.c.c.c.c.c.c.c.c.c.%.L L ;.c.c.c.c.c.c.c.c.c.c.;.K P K %.z.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.g.T K K K ,.c.c.c.c.c.c.c.c.c.%.L L ;.c.c.c.c.c.c.c.c.c.;.P P J Y p.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.i.Y K K I t.c.c.c.c.c.c.c.c.%.K K ;.c.c.c.c.c.c.c.c.y.L L L U u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.i.U P K I u.c.c.c.c.c.c.c.%.K K ;.c.c.c.c.c.c.c.i.Y P L I u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.t.K K K T i.c.c.c.c.c.c.;.%.%.,.c.c.c.c.c.c.p.T J J I r.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.-.K K K Y g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.g.&.K P P :.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.:.P K K -.z.c.c.c.c.c.c.c.c.c.c.c.c.g.&.J L U <.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.-.G I y.c.c.c.c.c.c.c.c.c.c.c.c.c.c.r.P L =.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.g.;.t.g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.u.;.g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.h.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.k.k.k.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.7.Q Q ] ] ] ] ] ( ] ] } e.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.a...( ( ` ( ( ( ( ( ( Q 1.c.c.c.c.c.,.:.:.:.:.:.:.:.:.:.:.:.:.:.:.:.;.r.c.c.c.c.c.c.c.c.c.:.;.;.;.;.=.=.=.=.=.=.=.;.,.u.p.c.c.c.c.c.c.c.c.c.c.c.c.c.c.g.,.:.:.:.:.:.:.g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.z.u.<.=.&.&.R R R &.&.*.;.<.i.g.c.c.c.c.c.t.;.:.:.:.:.,.g.c.c.c.c.c.c.c.c.c.c.c.p.:.:.:.:.:.;.i.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.8.y - 7 : : < < r < -    .l.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.j. .r < < # , , 7 7 7 , i +.c.c.c.c.g.Y L L L L L L L L L L L L L L L J %.z.c.c.c.c.c.c.c.c.U K P P P P L L L L L L L L P U %.;.p.c.c.c.c.c.c.c.c.c.c.c.g.Y K P P P P U p.c.c.c.c.c.c.c.c.c.c.c.c.c.c.y.*.Y P L L L L L L L L L L L P P Y ,.c.c.c.c.;.L L L L I I ;.c.c.c.c.c.c.c.c.c.c.c.;.J L L L L T i.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.k.E . . . . . 0 0 3 1 . F l.l.l.l.l.c.c.c.c.c.c.c.c.c.c.c.c.d.Z o o 6 6 5 5 2 2 4 . ! a.c.c.c.c.g.U P P P P P P P P P P P P P P P L %.z.c.c.c.c.c.c.c.c.I G P P P P P P P P P P P P P P P J T i.c.c.c.c.c.c.c.c.c.c.g.Y P P P P K P p.c.c.c.c.c.c.c.c.c.c.c.c.p.=.I L L L L P P P P P P P P P L L L I t.c.c.c.c.p.T K K P L L U g.c.c.c.c.c.c.c.c.c.g.U P P P P P r.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.+.a a g q q q q q 6 6 l a.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.h.7.t o 0 & & & & & 0 4 8 ..l.c.c.c.c.g.Y P P P P P P P P P P P P P P P L R z.c.c.c.c.c.c.c.c.T K I I I I P P P P P P P P P P P P J U u.c.c.c.c.c.c.c.c.c.g.Y L P P P P U g.c.c.c.c.c.c.c.c.c.c.c.i.Y K K I I I I I I P P P P P P P P P P Y g.c.c.c.c.c.=.L L I P P P <.c.c.c.c.c.c.c.c.c.-.L P P P J Y g.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.a.N & & 6 6 q q q 3 3 r } l.l.c.c.c.c.c.c.c.c.c.c.c.c.c.c.O.. OO gg 0 q q = @ . p a.c.c.c.c.c.g.Y P P P P K L L L L L L L L L L J %.g.c.c.c.c.c.c.c.c.Y K P P P P P U U U U L L L P U P P P P T g.c.c.c.c.c.c.c.c.g.U L P P P P I g.c.c.c.c.c.c.c.c.c.c.p.Y G L U P P P P P P P P P P P K K K K K -.z.c.c.c.c.c.g.T P P P P P R z.c.c.c.c.c.c.c.p.U L L L P L :.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.[ 8 5 8 8 8 8 8 8 8 C C a.h.h.h.h.l.c.c.c.c.c.c.c.c.c.l.~ X X 6 q 6 6 6 q 0   ) l.l.c.c.c.c.g.Y P P P P P =.,.,.,.,.,.,.,.,.,.:.r.z.c.c.c.c.c.c.c.c.Y K I P P K &.g.g.g.p.:.T K K P P P P P K ,.c.c.c.c.c.c.c.c.g.U L P P P P I g.c.c.c.c.c.c.c.c.c.g.%.J P P P P P K K Y =.y.i.i.i.t.;.&.U K K y.c.c.c.c.c.c.c.,.P P P P P J <.c.c.c.c.c.c.c.,.J L P P P T g.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.l.l.l.6.d 5 q q 8 8 8 8 8 h h 8.h.h.h.h.h.c.c.c.c.c.c.c.c.c.0.c & 8 8 & 0 0 0 5 5 p 5.l.l.c.c.c.c.z.Y P P P P P u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I P L J *.c.c.c.c.c.g.,.Y L P P P P K *.c.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.c.c.c.;.J L L P P P J T :.g.c.c.c.c.c.c.c.g.i.,.-.g.c.c.c.c.c.c.c.g.Y L P P P J %.c.c.c.c.c.c.c.*.J P P P K ,.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.k.k.s.C 6 q 8 8 8 8 8 & & O O.c.c.c.c.c.c.c.c.c.c.c.c.c.c.s.N o 0 6 6 6 6 6 * X t 6.c.j.j.j.c.c.z.Y P P P P P u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K P P P J *.c.c.c.c.c.c.c.;.K P P P P P Y c.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.c.c.y.I K K P P P J %.g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.:.P P P P P P u.c.c.c.c.c.p.U L P P P U p.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.} ; 6 s < < 8 q q 0 X / k.h.l.l.h.c.c.c.c.c.c.c.c.s.N o 0 6 6 6 6 6 * X t 6.c.j.j.j.c.c.c.g.Y P P P P P u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K P P P L *.c.c.c.c.c.c.c.p.U L I I I I I z.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.c.g.%.J P P P P P -.z.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.z.%.J P P P P %.g.c.c.c.c.=.L P P P J =.z.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.9.n 6 # , , s s 0 0 0 l a.h.j.j.j.c.c.c.c.c.h.h.h.6.d 6 6 6 6 6 6 6 6   F a.c.c.c.c.c.c.c.z.Y P P P P P u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I I I L =.c.c.c.c.c.c.c.g.T J P P P P Y z.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.c.y.P P P P P K Y g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.,.K P P P P P r.c.c.c.u.P P P P L Y i.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.j.j.z.s.~ , , 6 6 8 q q 8 6 t 2.h.h.c.c.c.c.c.c.c.c.c.c.[ a 6 6 6 6 6 6 6 5 a ..l.l.l.l.l.c.c.c.z.U P P P P P u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I P P L =.c.c.c.c.c.c.c.g.Y L P P P P Y z.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.c.;.K P P P P P ,.l.l.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.p.U K P P P P &.c.c.c.=.L P P P J :.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.b,t X 5 8 8 8 8 8 3 # Q l.l.l.l.l.l.l.l.l.l.h.j.M 7 7 6 6 6 6 6 6 1 z a.h.l.c.c.c.c.c.c.g.U P P P P P u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I I I J *.c.c.c.c.c.c.c.i.U P P P U P %.c.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.z.T L P P P P Y g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.*.K P P P P U g.c.i.U P P P L U p.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.F # 0 0 6 6 6 8 2 0 s 9.h.c.c.j.c.l.l.l.l.l.2., 6 6 6 6 6 6 6 6 . ^ l.h.l.l.c.c.c.c.c.z.U P P P L L <.z.g.g.g.g.g.g.g.g.i.g.c.c.c.c.c.c.c.c.c.Y K I P P L =.c.c.c.c.c.z.c.y.K P P P P P &.z.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.i.I P P P P L &.z.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.g.U L L U L L :.c.*.L P P P J ;.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.| a 0 0 0 0 8 8 8 0 - X.l.l.x.j.j.l.l.l.l.l.[ o 6 6 6 6 6 6 6 6 6 ..c.c.c.c.c.c.c.c.c.z.U P P P P P U U U U U U U I I I I t.c.c.c.c.c.c.c.c.c.Y K P P P L *.c.c.c.c.c.c.g.*.L P P P L J :.c.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.u.P P P P P J *.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.=.L L P L L *.p.U L U P P U g.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.w.l 6 6 6 q q 8 8 0 X ~ l.l.l.l.l.l.l.l.l.f.V + 0 0 0 6 6 6 6 X f 8.c.c.c.c.c.c.c.c.c.z.U P P P P P P L L L P P P P P K K t.c.c.c.c.c.c.c.c.c.Y K I I I J =.c.c.c.c.c.g.*.L P P P P J Y g.c.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.r.P P P P P J ;.c.c.c.c.c.c.c.c.c.c.c.c.z.p.g.g.g.g.g.g.c.c.c.c.c.c.c.c.c.i.U L L L L U &.P L P P J ;.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.h.l._ 6 6 a a 6 8 8 0 0 z e.h.d.c.c.h.h.l.l.2.s @ q 6 6 6 6 6 6 X A k.k.k.c.c.c.c.c.c.c.z.U P P P P P P P P P P P P P P P P t.c.c.c.c.c.c.c.c.c.Y K I P P L *.t.,.,.;.*.T L P P P P L U u.c.c.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.r.P P P P P J ;.c.c.c.c.c.c.c.c.c.c.c.c.p.T T T T T T u.c.c.c.c.c.c.c.c.c.c.;.L P P P P P P P P P T p.z.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.e.c 3 0 a 8 8 8 8 8 8 [ h.k.k.k.h.h.h.c.S S 6 0 0 0 q q q q 3 6.6.6.c.c.c.c.c.c.c.c.z.U P P P P P P P P P P P P P P P P ,.c.c.c.c.c.c.c.c.c.Y K I I I L =.;.H K K K K P P U L J &.p.c.c.c.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.r.I P P P P J =.c.c.c.c.c.c.c.c.c.c.c.c.i.L J K K K K r.c.c.c.c.c.c.c.c.c.c.g.T K K I P P P P P P y.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.k.) 6 6 6 6 6 8 8 & o V k.h.h.c.c.c.c.a.z % g 6 6 g g 8 8 2 W c.c.c.c.c.c.c.c.c.c.c.z.U P P P P K *.;.-.-.-.-.-.-.-.-.-.u.c.c.c.c.c.c.c.c.c.Y K P P P J =.c.Y L P P P P P T *.:.z.c.c.c.c.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.u.P P P P P J *.c.c.c.c.c.c.c.c.c.c.c.c.p.I L P P P P y.c.c.c.c.c.c.c.c.c.c.c.;.J P P P P P P K T z.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.@.d 5 0 8 8 8 8 & u u 7.h.h.h.c.c.c.2.  0 8 8 8 8 8 8 6 7 ..c.c.c.c.c.c.c.c.c.c.c.z.U P P P P P u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I I I L =.c.:.L P P P P P *.x.c.c.c.c.c.c.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.p.U P P P P L T g.c.c.c.c.c.c.c.c.c.c.c.p.I P P P P P y.c.c.c.c.c.c.c.c.c.c.c.p.U L P P P P P J ;.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.j.j.a.F 5 5 q q q 6 6 6 w { x.x.l.x.x.x.[ X 0 8 8 8 8 8 5 5 b a.c.c.c.c.c.c.c.c.c.c.c.z.U P P P P P y.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I I I J =.c.z.T L P P P P P ;.c.c.c.c.c.c.c.c.c.c.c.c.c.g.U L P P P K I g.c.c.c.c.c.c.z.Y P P P P P I u.c.c.c.c.c.c.c.c.c.c.c.i.I L P P P P r.c.c.c.c.c.c.c.c.c.c.c.c.,.J P P L P L U p.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.h.h.c...  5 q q q 6 6 q < m a.c.k.k.h.l.D @ 3 8 8 8 8 8 0 6 o.h.h.c.c.c.c.c.c.c.c.c.c.z.U P P P P P y.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I I I K =.c.c.,.L P P P P P P u.c.c.c.c.c.c.c.c.c.c.c.c.g.Y L P P P K I g.c.c.c.c.c.c.c.=.L I P P P K -.z.c.c.c.c.c.c.c.c.c.c.i.P L P P P P r.c.c.c.c.c.c.c.c.c.c.c.c.g.P L P P P K &.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.h.h.h.3.r 5 0 q q q 6 q 6 f 3.c.c.c.c.a.z @ 6 8 8 8 3 0 a d 4.c.c.c.c.c.c.c.c.c.c.c.c.z.U P P P P K y.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I I I K =.c.c.g.%.K P P P P P %.g.c.c.c.c.c.c.c.c.c.c.c.g.Y L P P P K I g.c.c.c.c.c.c.c.u.I P P P P P P y.c.c.c.c.c.c.c.c.c.c.i.I P P P P P r.c.c.c.c.c.c.c.c.c.c.c.c.c.U L P P P L *.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.s.V , 0 a 0 0 0 0 0 < _ c.k.k.k. .q q 6 8 8 8 8 0 a ^ k.k.c.c.c.c.c.c.c.c.c.c.c.z.U P P P P K u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I I I K =.c.c.c.i.P L P P P P J ;.c.c.c.c.c.c.c.c.c.c.c.g.Y L P P P K I g.c.c.c.c.c.c.c.z.%.J P P P P K %.i.c.c.c.c.c.c.c.c.c.i.I L P P P P r.c.c.c.c.c.c.c.c.c.c.c.c.c.Y L P P P L *.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.X.w 3 a q q q 6 & x x k.k.h.s.x & & 6 6 6 6 q q j 3.c.c.c.c.c.c.c.c.c.c.c.c.c.z.U P P P P P y.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I I I K =.c.c.c.c.:.L P P P P L I t.c.c.c.c.c.c.c.c.c.c.g.Y L P P P K I g.c.c.c.c.c.c.c.c.y.P P P P P P P U u.z.c.c.c.c.c.c.c.p.I L P P P P r.c.c.c.c.c.c.c.c.c.c.c.c.c.U L P P P L *.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.l.h.a.M 3 0 q q q 6 & @ 9 a.h.h.9.8 8 8 8 8 8 8 8 X F s.h.h.h.c.c.c.c.c.c.c.c.c.c.z.U P P P P P u.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.Y K I I I K =.c.c.c.c.c.&.L P P P P K Y g.c.c.c.c.c.c.c.c.c.g.Y L P P P K I g.c.c.c.c.c.c.c.c.c.=.J L L I I I K U ;.g.c.c.c.c.c.c.i.I L P P P P t.c.c.c.c.c.c.c.c.c.c.c.c.c.U L P P P L =.c.c.c.c.c.c.c.c.c.c.',
"c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.k.k.k.h.c.) , 5 8 8 8 8 @ @ r O.h.h.'   8 8 8 8 8 8 8 8 ..x.j.j.c.c.c.c.c.c.c.c.c.c.c.z.U P P P P P ,.i.i.g.g.g.g.g.g.g.g.p.z.c.c.c.c.c.c.c.c.Y K I I I K =.c.c.c.c.c.y.I P P P P P K ;.c.c.c.c.c.c.c.c.c.g.Y L L I I K I g.c.c.c.c.c.c.c.c.c.p.T K P P P P P K K Y *.r.i.u.u.:.%.P P P P P P t.c.c.c.c.c.c.c.c.c.c.c.c.c.U L P P P L =.c.c.c.c.c.c.c.c.c.c.",
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.l.l.l.2.h X a a 6 6 # 6 7 _ h.s.V X 8 8 8 8 8 8 3 z q.c.j.j.c.c.c.c.c.c.c.c.c.c.c.z.U P P P P P U U U I I I I I I I K %.g.c.c.c.c.c.c.c.c.Y K I I I K *.c.c.c.c.c.c.=.L P P P P K I y.c.c.c.c.c.c.c.c.g.Y K P P P K I g.c.c.c.c.c.c.c.c.c.c.u.Y K P P P P P P P L L L I P P P L P P P P P t.c.c.c.c.c.c.c.c.c.c.c.c.c.U L P P P L =.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.l.l.l.2.h X a a 6 6 # 6 7 _ h.s.V X 8 8 8 8 8 8 3 z q.c.j.j.c.c.c.c.c.c.c.c.c.c.c.z.U P P P P P U U U I I I I I I I K %.g.c.c.c.c.c.c.c.c.Y K I I I K *.c.c.c.c.c.c.c.=.L P P P K I y.c.c.c.c.c.c.c.c.g.Y K P P P K I g.c.c.c.c.c.c.c.c.c.c.c.u.Y K P P P P P P L L L I P P P L P P P P P t.c.c.c.c.c.c.c.c.c.c.c.c.c.U L P P P L =.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.l.#.* 0 0 0 0 8 # # h 1.[ 7 3 q a 6 6 6 4 > X.h.h.l.c.c.c.c.c.c.c.c.c.c.c.c.z.Y P P P P P P P P P P P P P P P K %.g.c.c.c.c.c.c.c.c.T K P P P K *.c.c.c.c.c.c.c.,.K I I I I I I y.c.c.c.c.c.c.c.g.Y K P P P K U g.c.c.c.c.c.c.c.c.c.c.c.c.u.T L L L I P P P P P P U U L P U U P K K y.c.c.c.c.c.c.c.c.c.c.c.c.z.Y L P P P L =.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.a.N 3 3 q q q q q a v n , , a a 6 a 8 . n q.h.l.l.c.c.c.c.c.c.c.c.c.c.c.c.p.U K L L L L L L L L L K K K K K G Y g.c.c.c.c.c.c.c.c.Y J J K K G &.c.c.c.c.c.c.c.g.U J L K K K K %.g.c.c.c.c.c.c.p.U K K K K K I g.c.c.c.c.c.c.c.c.c.c.c.c.c.g.;.Y I P P P P P P P P P L L L L I I &.p.c.c.c.c.c.c.c.c.c.c.c.c.g.Y J L L L H *.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.l.l.l.l.l.c.c.X.7 3 6 # 6 6 6 6 7 7 7 7 7 7 7 7 6 r  .l.l.l.l.c.c.c.c.c.c.c.c.c.c.c.c.g.=.%.&.&.&.&.&.&.&.&.&.&.&.%.%.%.%.-.g.c.c.c.c.c.c.c.c.-.%.%.%.%.%.:.c.c.c.c.c.c.c.c.r.%.*.*.%.%.%.%.<.c.c.c.c.c.c.g.-.%.%.%.%.%.*.g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.i.;.*.Y I L L L L I I T *.:.u.g.c.c.c.c.c.c.c.c.c.c.c.c.c.c.z.=.%.%.%.%.%.:.c.c.c.c.c.c.c.c.c.c.',
'c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.l.l.l.l.l.l.l.0.l . 5 q 6 6 8 8 3 q q q q q s 8 . k w.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.p.u.r.r.r.r.u.i.z.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.c.'
);

my $style;
my $pixmap;
my $mask;
my $pixmapwid;
my $window4;
$window4 = new Gtk::Window( "toplevel" );
$window4->signal_connect( "delete_event", sub { $window4->hide; } );
$window4->border_width( 10 );
$window4->show();
$style = $window4->get_style()->bg( 'normal' );
( $pixmap, $mask ) = Gtk::Gdk::Pixmap->create_from_xpm_d( $window4->window,
							  $style,
							  @xpm_data );

# a pixmap widget to contain the pixmap
$pixmapwid = new Gtk::Pixmap( $pixmap, $mask );
 $table->attach_defaults( $pixmapwid, 3, 10, 0, 3 );
$pixmapwid->show();
$window4->hide();
#############
###info.txt##
#############

			####uname -a#####
my $FILENAME100 = "/tmp/consul_tool_error1.txt";
my $FILENAME101 = "$result_dir/consul_tool_error.txt";
system ("mkdir $result_dir 2>$FILENAME100");
system ("rm $FILENAME100");
 my $FILENAME = "$result_dir/uname.txt";
   
   system( "/bin/uname -a > $result_dir/uname.txt" );

   open(FILEREAD, "< $FILENAME") || die "file: $FILENAME did not open $!";
   	while (chomp( $line = <FILEREAD>)){
   		my @lin = split(/\s+/, $line);
   		$uname = $lin[2];
		$workstation = $lin[1];		
   	}
   close FILEREAD;
   if (!$uname)
    {
    print "****************************************************************\n";
    print "ERROR: uname and workstation, check to see if /bin/uname exists \n";
    print "****************************************************************\n";
    }
 
   system( "rm $result_dir/uname.txt");
   #make label and entry for workstation name and linux version
    $entry = new Gtk::Entry( 50);
    $entry->set_text($workstation);
    $entry->set_editable( $false );
    $table->attach_defaults( $entry, 1, 3, 5, 6 );
    $entry->show();
    $label = new Gtk::Label( "Workstation Name: ");
    $table->attach_defaults( $label, 0, 1, 5, 6 );
    $label->show();
    
    $entry = new Gtk::Entry( 50 );
    $entry->set_text($uname);
    $entry->set_editable( $false );
    $table->attach_defaults( $entry, 1, 3, 7, 8 );
    $entry->show();
    $label = new Gtk::Label( "Linux Version: " );
    $table->attach_defaults( $label, 0, 1, 7, 8 );
    $label->show();
   
####################Display Date######################

    $date = `date '+%Y_%m_%d_%H-%M-%S'`;
    my $chr = chop($date);
    $label = new Gtk::Label("Title (Hostname-Year_Month_Date_Time): $workstation-$date");
    $table->attach_defaults( $label, 0, 5, 4, 5 );
    $label->show();

	####################Linux Revision####################
	system ("rpm -q --all |grep mysql |grep RHEL  |grep devel > $result_dir/rhel");
	open (FILEREAD, "< $result_dir/rhel");
	my $line = <FILEREAD>;
	 my @lin = split('\.', $line);
	my $rhel = "$lin[3].$lin[4]";
	close FILEREAD;
	my $extra = chop ($rhel);
	$entry = new Gtk::Entry( 30);
	$entry->set_text($rhel);
	$entry->set_editable($false);
	$table->attach_defaults($entry, 1, 3, 6, 7);
	$entry->show();	
   $label = new Gtk::Label( "Linux Revision:" );
   $table->attach_defaults( $label, 0, 1, 6, 7 );
   $label->show();	
			####redhat cat /etc/redhat-release####
   my $FILENAME1 = "$result_dir/redhat.txt";
   
   system( "/bin/cat /etc/redhat-release > $result_dir/redhat.txt" ); 
   
   open(FILEREAD, "< $FILENAME1") || die "file: $FILENAME1 did not open $!";
   	while (chomp( my $line = <FILEREAD>))
	{
   		my @lin = split(/\s+/, $line);
  		$redhat = "$lin[7] $lin[9]";
   	}
   close FILEREAD;
	
   if (!$redhat)
    {
    print "****************************************************************\n";
    print "ERROR: redhat, check to see if /bin/cat exists \n";
    print "****************************************************************\n";
    }    
   system( "rm $result_dir/redhat.txt"); 
    $entry = new Gtk::Entry( 50 );
    $entry->set_text($redhat);
    $entry->set_editable( $false );
    # Insert Redhat info on Program
    $table->attach_defaults( $entry, 1, 3, 8, 9 );
    $entry->show();
   $label = new Gtk::Label( "Redhat Version:" );
   $table->attach_defaults( $label, 0, 1, 8, 9 );
   $label->show();
   
   			############Smartest Revision##############
my $FILENAME17 = "$result_dir/smartest_revision";
system ("ls -al /opt/hp93000/soc > $result_dir/smartest_revision");
   open(FILEREAD, "< $FILENAME17") || die "file: $FILENAME17 did not open $!";
   	while (chomp( my $line = <FILEREAD>))
	{
   		my @lin = split('/', $line);
  		$smartest = "$lin[$#lin]";
   	}
   close FILEREAD;
   if (!$smartest)
    {
    print "****************************************************************\n";
    print "ERROR: smartest, check to see if /opt/hp93000/soc exists \n";
    print "****************************************************************\n";
    }
    
   system( "rm $result_dir/smartest_revision"); 
    $entry = new Gtk::Entry( 50 );
    $entry->set_text($smartest);
    $entry->set_editable( $false );
    # Insert smartest revision info on Program
    $table->attach_defaults( $entry, 1, 3, 9, 10 );
    $entry->show();
   $label = new Gtk::Label( "Smartest Revision:" );
   $table->attach_defaults( $label, 0, 1, 9, 10 );
   $label->show();
   
   ###########Modelfile name################
   
system ("ls -al /etc/opt/hp93000/soc_common/model > $result_dir/model_d");
   open(FILEREAD, "< $result_dir/model_d") || die "file: result_dir/model_d did not open $!";
   	while (chomp( my $line = <FILEREAD>))
	{
   		my @lin = split('/', $line);
  		$model = "$lin[$#lin]";
   	}
   close FILEREAD;
   if (!$model)
    {
    print "****************************************************************\n";
    print "ERROR: model, check to see if /etc/opt/hp93000/soc_common/model exists \n";
    print "****************************************************************\n";
    }
  
   			####testflow information###

############setup labels
  $label = new Gtk::Label( "Testflow: " );
  $table->attach_defaults( $label, 0, 1, 15, 16 );
  $label->show();

  $label = new Gtk::Label( "Pins: " );
  $table->attach_defaults( $label, 0, 1, 16, 17 );
  $label->show();
  
  $label = new Gtk::Label( "Levels:" );
  $table->attach_defaults( $label, 0, 1, 17, 18 );
  $label->show();
  
  $label = new Gtk::Label( "Timing:" );
  $table->attach_defaults( $label, 0, 1, 18, 19 );
  $label->show();
  
  $label = new Gtk::Label( "Vector:" );
  $table->attach_defaults( $label, 0, 1, 19, 20 );
  $label->show();
  
  $label = new Gtk::Label( "Attribute:" );
  $table->attach_defaults( $label, 0, 1, 20, 21 );
  $label->show();
  
  $label = new Gtk::Label( "Analog Control:" );
  $table->attach_defaults( $label, 0, 1, 21, 22 );
  $label->show();
  
  $label = new Gtk::Label( "Waveform:" );
  $table->attach_defaults( $label, 0, 1, 22, 23 );
  $label->show();
  
  $label = new Gtk::Label( "Routing:" );
  $table->attach_defaults( $label, 0, 1, 23, 24 );
  $label->show();
  #########make blank entries
      $entry = new Gtk::Entry( 20 );
    $table->attach_defaults( $entry, 1, 4, 15, 16 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $table->attach_defaults( $entry, 1, 4, 16, 17 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $table->attach_defaults( $entry, 1, 4, 17, 18 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $table->attach_defaults( $entry, 1, 4, 18, 19 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $table->attach_defaults( $entry, 1, 4, 19, 20 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $table->attach_defaults( $entry, 1, 4, 20, 21 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $table->attach_defaults( $entry, 1, 4, 21, 22 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $table->attach_defaults( $entry, 1, 4, 22, 23 );
    $entry->show();	
  
    $entry = new Gtk::Entry( 20 );
    $table->attach_defaults( $entry, 1, 4, 23, 24 );
    $entry->show();
 			####df info####
   my $FILENAME2 = "$result_dir/df.txt";
   system( "/bin/df > $result_dir/df.txt" ); 
   
   open(FILEREAD, "< $FILENAME2") || die "file: $FILENAME2 did not open $!";
   	
	chomp( my @line = <FILEREAD>);
	$df_text = "$line[0] \n $line[1] \n $line[2] \n $line[3] \n $line[4] \n $line[5]"; 
   close FILEREAD;
   if (!$df_text)
    {
    print "****************************************************************\n";
    print "ERROR: df, check to see if /bin/df exists \n";
    print "****************************************************************\n";
    }
      system( "rm $result_dir/df.txt");
         		
			####/etc/hosts file####
   my $FILENAME3 = "$result_dir/hosts";
   system( "cp /etc/hosts $result_dir/" ); 
   
   open(FILEREAD, "< $FILENAME3") || warn "file: $FILENAME3 did not open $! move perl file to /tool/";
	chomp( my @line = <FILEREAD>);
	$host_text = "$line[0] \n $line[1] \n $line[2] \n $line[3] \n $line[4] \n $line[5]";
   close FILEREAD;
      if (!$host_text)
    {
    print "****************************************************************\n";
    print "ERROR: hosts, check to see if /etc/hosts exists \n";
    print "****************************************************************\n";
    }
   system( "rm $result_dir/hosts");
   
   			####/etc/resolv.conf file####
  my $FILENAME4 = "$result_dir/resolv.conf";
   system( "cp /etc/resolv.conf $result_dir/" ); 
   
   open(FILEREAD, "< $FILENAME4") || warn "file: $FILENAME4 did not open $! move perl file to /tool/";
   	chomp( my @line = <FILEREAD>);
	$resolv_text = "$line[0] \n $line[1] \n $line[2] \n $line[3] \n $line[4] \n $line[5]";	 
   close FILEREAD;
   if (!$resolv_text)
    {
    print "****************************************************************\n";
    print "ERROR: resolv.conf, check to see if /etc/resolv.conf exists \n";
    print "****************************************************************\n";
    }
   system( "rm $result_dir//resolv.conf"); 

			####free command info ####
   my $FILENAME5 = "$result_dir/free.txt";
   system( "/usr/bin/free > $result_dir/free.txt" ); 
   
   open(FILEREAD, "< $FILENAME5") || die "file: $FILENAME5 did not open $!";
	chomp( my @line = <FILEREAD>);
	$free_text = "$line[0] \n $line[1] \n $line[2] \n $line[3] \n $line[4] \n $line[5]"; 
   close FILEREAD;
  if (!$free_text)
    {
    print "****************************************************************\n";
    print "ERROR: free, check to see if /usr/bin/free exists \n";
    print "****************************************************************\n";
    }
   system( "rm $result_dir/free.txt"); 

		####vmstat command info####
   my $FILENAME6 = "$result_dir/vmstat.txt";
   system( "/usr/bin/vmstat > $result_dir/vmstat.txt" ); 
   
   open(FILEREAD, "< $FILENAME6") || die "file: $FILENAME6 did not open $!";
	chomp( my @line = <FILEREAD>);
	$vmstat_text = "$line[0] \n $line[1] \n $line[2] \n $line[3] \n $line[4] \n $line[5]"; 
   close FILEREAD;
   if (!$vmstat_text)
    {
    print "****************************************************************\n";
    print "ERROR: vmstat, check to see if /usr/bin/vmstat exists \n";
    print "****************************************************************\n";
    }
   system( "rm $result_dir/vmstat.txt");    
#################
####info.txt#####
#################
   
###################
###Pulldown menu###
###################
$label = new Gtk::Label( "Please have 'Smaretest Online' running before selecting a Class Type");
$table->attach_defaults( $label, 0, 4, 24, 25 );
$label->show();
########pulldown2
$label = new Gtk::Label( "Severity:" );
$table->attach_defaults( $label, 0, 1, 25, 26 );
$label->show();
my $severity_combo;
my $combo2 = new Gtk::Combo();
my @class1 = ( "Low", "Medium", "Serious", "Critical" );
$combo2->set_popdown_strings( @class1 );
$combo2->entry->set_text( "Please Specify" );
$combo2->entry->signal_connect( "changed", sub{
					my $severity = $combo2->entry;
					 $severity_combo = $severity->get_text;
					});

$table->attach_defaults( $combo2, 1, 3, 25, 26 );
$combo2->show();

########pulldown3
$label = new Gtk::Label( "Priority:" );
$table->attach_defaults( $label, 0, 1, 26, 27 );
$label->show();
my $priority_combo;
my $combo3 = new Gtk::Combo();
my @class2 = ( "No Rush", "Low", "Medium", "High", "Urgent" );
$combo3->set_popdown_strings( @class2 );
$combo3->entry->set_text( "Please Specify" );
$combo3->entry->signal_connect( "changed", sub{
					my $priority = $combo3->entry;
					 $priority_combo = $priority->get_text;
					});

$table->attach_defaults( $combo3, 1, 3, 26, 27 );
$combo3->show();

########pulldown4
$label = new Gtk::Label( "Type:" );
$table->attach_defaults( $label, 0, 1, 27, 28 );
$label->show();
my $type_combo;
my $combo4 = new Gtk::Combo();
my @class3 = ( "Feedback", "Improve", "Problem", "Question", "Others" );
$combo4->set_popdown_strings( @class3 );
$combo4->entry->set_text( "Please Specify" );
$combo4->entry->signal_connect( "changed", sub{
					my $type = $combo4->entry;
					$type_combo = $type->get_text;
					});

$table->attach_defaults( $combo4, 1, 3, 27, 28 );
$combo4->show();
#########pulldown class type
$label = new Gtk::Label( "Category:" );
$table->attach_defaults( $label, 0, 1, 28, 29 );
$label->show();
###Hardware selection variables
my $hardware_b;
my $analog_device_c;
my $dps_c;
my $digital_c;
my $external_c;
my $rf_c;
##Smartest selction variables
my $smartest_b;
my $analog_setup_c;
my $digital_setup_c;
my $dps_setup_c;
my $rf_setup_c;
##Documentation selection variables
my $documentation_b;
##ST - ASCII IF selection variables
my $ascii_b;

my $combo = new Gtk::Combo();
my @class = ( "Hardware", "Smartest", "Documentation", "ST - ASCII IF", "ST - Dataformatter" );
$combo->set_popdown_strings( @class );
$combo->entry->set_text( "Please Specify" );
$combo->entry->signal_connect( "changed",  sub {
		my $class_type = $combo->entry;
		$comp = $class_type->get_text;
		################################Diag commands############################
		system ("echo 'diag 444' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("echo 'diag 443' | /opt/hp93000/soc/pws/bin/hpt 2>>/tmp/diag_error");
			system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "MCDvmdump created in /var/opt/hp93000/$smartest\n";
			print "MCDsmdump created in /var/opt/hp93000/$smartest\n";
			}
			else 
			{
			print "DIAG 443/444 did not work. Make sure Smartest is running. \n";
			}
			system("rm /tmp/diag_error");
			system ("rm $FILENAME100");
		system ("echo 'diag 445' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("echo 'diag 446' | /opt/hp93000/soc/pws/bin/hpt 2>>/tmp/diag_error");
			system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "MCDseqdump created in /var/opt/hp93000/$smartest\n";
			print "MCDvirtseqdump created in /var/opt/hp93000/$smartest\n";
			}
			else 
			{
			print "DIAG 445/446 did not work. Make sure Smartest is running. \n";
			}
			system("rm /tmp/diag_error");
			system ("rm $FILENAME100");
		system ("echo 'diag 2' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "MCDLog being created in /var/opt/hp93000/$smartest\n";
			}
			else 
			{
			print "DIAG 2 did not work. Make sure Smartest is running.\n";
			}
    		
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		system ("echo 'diag 21' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "MCDErr being created in /var/opt/hp93000/$smartest\n";
			}
			else 
			{
			print "DIAG 21 did not work. Make sure Smartest is running.\n";
			
			}
    		
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		
	#	system ("echo 'diag -26' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
	#	system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
	#		if (-z "$FILENAME100")
	#		{
	#		print "LPM_Basetable being created in /var/opt/hp93000/$smartest\n";
	#		}
	#		else 
	#		{
	#		print "DIAG -26 did not work. Make sure Smartest is running.\n";
	#		
	#		}
    	#	
  	#	system ("rm /tmp/diag_error");
	#	system ("rm $FILENAME100");	
		
		system ("echo 'diag 30' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "ReportLog being created in /var/opt/hp93000/$smartest\n";
			}
			else 
			{
			print "DIAG 30 did not work. Make sure Smartest is running.\n";
			}
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		system ("echo 'diag 43' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "diag 43 being stored in ReportLog\n";
			}
			else 
			{
			print "DIAG 43 did not work. Make sure Smartest is running.\n";
			}
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		system ("echo 'diag 200' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "diag 200 being stored in ReportLog\n";
			}
			else 
			{
			print "DIAG 200 did not work. Make sure Smartest is running.\n";
			}
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		system ("echo 'diag 201' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "diag 201 being stored in ReportLog\n";
			}
			else 
			{
			print "DIAG 201 did not work. Make sure Smartest is running.\n";
			}
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		system ("echo 'diag 203' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "diag 203 being stored in ReportLog\n";
			}
			else 
			{
			print "DIAG 203 did not work. Make sure Smartest is running.\n";
			}
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		system ("echo 'diag 211' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "diag 211 being stored in ReportLog\n";
			}
			else 
			{
			print "DIAG 211 did not work. Make sure Smartest is running.\n";
			}
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		system ("echo 'diag 455' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "diag 455 being stored in ReportLog\n";
			}
			else 
			{
			print "DIAG 455 did not work. Make sure Smartest is running.\n";
			}
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		system ("echo 'diag 466' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "diag 466 being stored in ReportLog\n";
			}
			else 
			{
			print "DIAG 466 did not work. Make sure Smartest is running.\n";
			}
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		system ("echo 'diag 477' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
			if (-z "$FILENAME100")
			{
			print "diag 477 being stored in ReportLog\n";
			}
			else 
			{
			print "DIAG 477 did not work. Make sure Smartest is running.\n";
			}
  		system ("rm /tmp/diag_error");
		system ("rm $FILENAME100");
		if ($comp eq "Hardware")
		{
		my $combo5 = new Gtk::Combo();
		my @class5 = ("Analog", "DPS", "Digital", "External", "RF");
		$combo5->set_popdown_strings( @class5);
		$combo5->entry->set_text( "Please Specify");
		$combo5->entry->signal_connect( "changed", sub{
							my $hardware = $combo5->entry;
							$hardware_b = $hardware->get_text;
							if ($hardware_b eq "Analog")
							{
							my $analog_pulldown = new Gtk::Combo();
							my @analog_list = ("WGA", "WGB", "WGC", "WGD", "WGE", "WGF", "WDA", "WDB", "WDD", "WDE", "TIA", "MCB", "MCC", "PPS");
							$analog_pulldown->set_popdown_strings(@analog_list);
							$analog_pulldown->entry->set_text( "Please Specify");
							$analog_pulldown->entry->signal_connect( "changed", sub{
													my $analog_device = $analog_pulldown->entry;
													$analog_device_c = $analog_device->get_text;
													});
							$table->attach_defaults( $analog_pulldown, 1, 3, 30, 31 );
							$analog_pulldown->show();
							}
							if ($hardware_b eq "DPS")
							{
							my $dps_pulldown = new Gtk::Combo();
							my @dps_list = ("GP DPS", "HC DPS", "HV DPS", "LN DPS", "MC DPS", "CH DPS");
							$dps_pulldown->set_popdown_strings(@dps_list);
							$dps_pulldown->entry->set_text( "Please Specify");
							$dps_pulldown->entry->signal_connect( "changed", sub{
													my $dps_device = $dps_pulldown->entry;
													$dps_c = $dps_device->get_text;
													});
							$table->attach_defaults( $dps_pulldown, 1, 3, 30, 31 );
							$dps_pulldown->show();
							}
							if ($hardware_b eq "Digital")
							{
							my $digital_pulldown = new Gtk::Combo();
							my @digital_list = ("Bist Assist 6.4", "C Channel Card", "Ce Channel Card", "NP Channel Card", "P Channel Card", "PS800 Channel Card", "PS3600 Channel Card", "HX Channel Card");
							$digital_pulldown->set_popdown_strings(@digital_list);
							$digital_pulldown->entry->set_text( "Please Specify");
							$digital_pulldown->entry->signal_connect( "changed", sub{
													my $digital_device = $digital_pulldown->entry;
													$digital_c = $digital_device->get_text;
													});
							$table->attach_defaults( $digital_pulldown, 1, 3, 30, 31 );
							$digital_pulldown->show();
							}
							if ($hardware_b eq "External")
							{
							my $external_pulldown = new Gtk::Combo();
							my @external_list = ("Analog AMC", "Digital AMC", "RF Instruments");
							$external_pulldown->set_popdown_strings(@external_list);
							$external_pulldown->entry->set_text( "Please Specify");
							$external_pulldown->entry->signal_connect( "changed", sub{
													my $external_device = $external_pulldown->entry;
													$external_c = $external_device->get_text;
													});
							$table->attach_defaults( $external_pulldown, 1, 3, 30, 31 );
							$external_pulldown->show();
							}
							if ($hardware_b eq "RF")
							{
							my $rf_pulldown = new Gtk::Combo();
							my @rf_list = ("V*I Cardcage/Module", "8 or 4 Port Card");
							$rf_pulldown->set_popdown_strings(@rf_list);
							$rf_pulldown->entry->set_text( "Please Specify");
							$rf_pulldown->entry->signal_connect( "changed", sub{
													my $rf_device = $rf_pulldown->entry;
													$rf_c = $rf_device->get_text;
													});
							$table->attach_defaults( $rf_pulldown, 1, 3, 30, 31 );
							$rf_pulldown->show();
							}
							
							});
							
		$table->attach_defaults( $combo5, 1, 3, 29, 30 );
		$combo5->show();					
		}
		if ($comp eq "Smartest")
		{
		my $combo6 = new Gtk::Combo();
		my @class6 = ("Bist Assist", "Calibration", "Datalogging", "Diagnostics", "Firmware", "Licensing", "Memory Test", "Multiport/Concurrent Test", "Multisite", "Operating System", "PPSG", "Scantool", "Testfunction", "User Procedures", "Test Methods", "User Interface", "Analog Setup", "Digital Setup", "DPS Setup", "RF Setup", "Memory Setup");
		$combo6->set_popdown_strings( @class6);
		$combo6->entry->set_text( "Please Specify");
		$combo6->entry->signal_connect( "changed", sub{
							my $smartest_c = $combo6->entry;
							$smartest_b = $smartest_c->get_text;
							if ($smartest_b eq "Analog Setup")
							{
							my $analog_setup_pulldown = new Gtk::Combo();
							my @analog_setup_list = ("AV8 Analog Setup Converter", "Analog AMC Tool", "Analog Setup Tool", "Analog Setup/Use General/Other", "Mixed Signal Tool", "Routing Setup Tool", "Signal Analyzer");
							$analog_setup_pulldown->set_popdown_strings(@analog_setup_list);
							$analog_setup_pulldown->entry->set_text( "Please Specify");
							$analog_setup_pulldown->entry->signal_connect( "changed", sub{
													my $analog_setup_device = $analog_setup_pulldown->entry;
													$analog_setup_c = $analog_setup_device->get_text;
													});
							$table->attach_defaults( $analog_setup_pulldown, 1, 3, 30, 31 );
							$analog_setup_pulldown->show();
							}
							if ($smartest_b eq "Digital Setup")
							{
							my $digital_setup_pulldown = new Gtk::Combo();
							my @digital_setup_list = ("Vector Tool");
							$digital_setup_pulldown->set_popdown_strings(@digital_setup_list);
							$digital_setup_pulldown->entry->set_text( "Please Specify");
							$digital_setup_pulldown->entry->signal_connect( "changed", sub{
													my $digital_setup_device = $digital_setup_pulldown->entry;
													$digital_setup_c = $digital_setup_device->get_text;
													});
							$table->attach_defaults( $digital_setup_pulldown, 1, 3, 30, 31 );
							$digital_setup_pulldown->show();
							}
							if ($smartest_b eq "DPS Setup")
							{
							my $dps_setup_pulldown = new Gtk::Combo();
							my @dps_setup_list = ("DPS Capabilities/Features", "DPS Configuration", "DPS General/Other", "DPS Triggering");
							$dps_setup_pulldown->set_popdown_strings(@dps_setup_list);
							$dps_setup_pulldown->entry->set_text( "Please Specify");
							$dps_setup_pulldown->entry->signal_connect( "changed", sub{
													my $dps_setup_device = $dps_setup_pulldown->entry;
													$dps_setup_c = $dps_setup_device->get_text;
													});
							$table->attach_defaults( $dps_setup_pulldown, 1, 3, 30, 31 );
							$dps_setup_pulldown->show();
							}
							if ($smartest_b eq "RF Setup")
							{
							my $rf_setup_pulldown = new Gtk::Combo();
							my @rf_setup_list = ("BER Measurement", "RF Digital Demodulation", "RF Instrument Setup Tool", "RF Measurements", "RF Related Model File", "RF Related Workorder Management", "RF Setup/Opeeration General/Other", "RF WAPI Setup");
							$rf_setup_pulldown->set_popdown_strings(@rf_setup_list);
							$rf_setup_pulldown->entry->set_text( "Please Specify");
							$rf_setup_pulldown->entry->signal_connect( "changed", sub{
													my $rf_setup_device = $rf_setup_pulldown->entry;
													$rf_setup_c = $rf_setup_device->get_text;
													});
							$table->attach_defaults( $rf_setup_pulldown, 1, 3, 30, 31 );
							$rf_setup_pulldown->show();
							}
							if ($smartest_b eq "Bist Assist")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Calibration")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "User Interface")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Datalogging")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Diagnostics")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Firmware")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Licensing")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Memory Test")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Multiport/Concurrent Test")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Multisite")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Operating System")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "PPSG")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Scantool")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Testfunction")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "User Procedures")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Test Methods")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							if ($smartest_b eq "Memory Setup")
							{
							$entry = new Gtk::Entry( 30);
							$entry->set_text("");
							$entry->set_editable($false);
							$table->attach_defaults($entry, 1, 3, 30, 31);
							$entry->show();	
							}
							});
		$table->attach_defaults( $combo6, 1, 3, 29, 30 );
		$combo6->show();					
		}
		if ($comp eq "Documentation")
		{
		my $combo7 = new Gtk::Combo();
		my @class7 = ("Documentation General", "Installation", "Online Help", "User Documentation");
		$combo7->set_popdown_strings( @class7);
		$combo7->entry->set_text( "Please Specify");
		$combo7->entry->signal_connect( "changed", sub{
							my $documentation_c = $combo7->entry;
							$documentation_b = $documentation_c->get_text;
							});
		$table->attach_defaults( $combo7, 1, 3, 29, 30 );
		$combo7->show();
		
		$entry = new Gtk::Entry( 30);
		$entry->set_text("");
		$entry->set_editable($false);
		$table->attach_defaults($entry, 1, 3, 30, 31);
		$entry->show();						
		}
		if ($comp eq "ST - ASCII IF")
		{
		my $combo8 = new Gtk::Combo();
		my @class8 = ("B2A", "Installation", "Online Help", "User Documentation");
		$combo8->set_popdown_strings( @class8);
		$combo8->entry->set_text( "Please Specify");
		$combo8->entry->signal_connect( "changed", sub{
							my $ascii_c = $combo8->entry;
							$ascii_b = $ascii_c->get_text;
							});
		$table->attach_defaults( $combo8, 1, 3, 29, 30 );
		$combo8->show();
		
		$entry = new Gtk::Entry( 30);
		$entry->set_text("");
		$entry->set_editable($false);
		$table->attach_defaults($entry, 1, 3, 30, 31);
		$entry->show();
		}	
		if ($comp eq "ST - Dataformatter")
		{
		$entry = new Gtk::Entry( 30);
		$entry->set_text("");
		$entry->set_editable($false);
		$table->attach_defaults($entry, 1, 3, 29, 30);
		$entry->show();
		$entry = new Gtk::Entry( 30);
		$entry->set_text("");
		$entry->set_editable($false);
		$table->attach_defaults($entry, 1, 3, 30, 31);
		$entry->show();
		}
		});
#		if ($comp eq "Digital")
#		{
#		system ("echo 'diag 444' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
#		system ("echo 'diag 443' | /opt/hp93000/soc/pws/bin/hpt 2>>/tmp/diag_error");
#			system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
#			if (-z "$FILENAME100")
#			{
#			print "MCDvmdump created in /var/opt/hp93000/$smartest\n";
#			print "MCDsmdump created in /var/opt/hp93000/$smartest\n";
#			}
#			else 
#			{
#			print "DIAG 443/444 did not work. Make sure Smartest is running. \n";
#			$comp = "not digital";
#			}
#			system("rm /tmp/diag_error");
#			system ("rm $FILENAME100");
#		}
#		
#		if ($comp eq "Mixed Signal")
#		{
#		system ("echo 'diag 2' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag_error");
#		system ("grep -a FATAL /tmp/diag_error >$FILENAME100");
#			if (-z "$FILENAME100")
#			{
#			my $window6;
#     	 		$window6 = new Gtk::Window( "toplevel" );
#			$window6->signal_connect( "delete_event", sub { $window6->hide(); } );
##			$window6->title( "Mixed Signal help" );
#			$window6->border_width( 20 );
#
#			$table = new Gtk::Table( 2, 3, $true );
#			$window6->add( $table );
#	
#			$label = new Gtk::Label( "Please Execute Testflow, ");
#			$table->attach_defaults( $label, 0, 2, 0, 1 );
#  			$label->show();
#		
#			$label = new Gtk::Label( "Then click 'Next' or Click 'Cancel' ");
#			$table->attach_defaults( $label, 0, 2, 1, 2 );
#  			$label->show();
#			$button = new Gtk::Button( "Next" );
#			$button->signal_connect( "clicked", sub {
#						system ("echo 'diag -2' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag2_error");
#						$window6->hide();
#						system ("ls /tmp | grep diag2_error >/tmp/check");
#						if (-z "/tmp/check")
#						{
#						print "The testflow did not produce firmware commands\n";
#						}
#						else
#						{
#						system ("rm /tmp/diag2_error");
#						}
#						system ("rm /tmp/check");
#						});

			# Insert button 1 into the upper left quadrant of the table
#			$table->attach_defaults( $button, 0, 1, 2, 3);
#			$button->show();

#			#Create second button
#			$button = new Gtk::Button( "Cancel" );
#			$button->signal_connect( "clicked", sub{
#						system ("echo 'diag -2' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag-2_error");
#						$comp = "not mixed signal";
#						$window6->hide();
#						system ("rm /tmp/diag-2_error");
#						} );

			# Insert button 2 into the upper right quadrant of the table
#			$table->attach_defaults( $button, 1, 2, 2, 3);
#			$button->show();
#			$table->show();
#			$window6->show();
#			}
#			else 
#			{
#			print "DIAG 2 did not work. Make sure Smartest is running.\n";
#			$comp = "not mixed signal";
#			}
#     		
 #  		system ("rm /tmp/diag_error");
#		system ("rm $FILENAME100");		 					
#		}
		


$table->attach_defaults( $combo, 1, 3, 28, 29 );
$combo->show();
################
###Text Box#####
################
$label = new Gtk::Label( "PREPARATION:  (Mention any other special setup info.)" );
$table->attach_defaults( $label, 0, 8, 46, 47 );
$label->show();

# Create the GtkText widget
my $text6 = new Gtk::Text( undef, undef );
$text6->set_editable( $true );
$text6->set_word_wrap( $true );
$text6->set_line_wrap( $true );
$text6->set_point(0); # this is probably optional

$table->attach_defaults( $text6, 0, 10, 47, 48);
$text6->show();  
   
# Add a vertical scrollbar to the GtkText widget
my $vscrollbar = new Gtk::VScrollbar( $text6->vadj );
$table->attach_defaults( $vscrollbar,10, 11, 47, 48);
$vscrollbar->show();

#######TEXT BOX 2 STEP-BY-STEP
$label = new Gtk::Label( "STEP-BY-STEP PROCESS:" );
$table->attach_defaults( $label, 0, 8, 48, 49 );
$label->show();
$label = new Gtk::Label( "(The quality of this description directly affects duplication time. If you would rather demonstrate the issue, please mention this here.)" );
$table->attach_defaults( $label, 0, 10, 49, 50 );
$label->show();
# Create the GtkText widget
my $text = new Gtk::Text( undef, undef );
$text->set_editable( $true );
$text->set_word_wrap( $true );
$text->set_line_wrap( $true );
$text->set_point(0); # this is probably optional

$table->attach_defaults( $text, 0, 10, 50, 52);
$text->show();  
   
# Add a vertical scrollbar to the GtkText widget
my $vscrollbar = new Gtk::VScrollbar( $text->vadj );
$table->attach_defaults( $vscrollbar,10, 11, 50, 52);
$vscrollbar->show();

####TEXT BOX3####
$label = new Gtk::Label( "OBSERVED PROBLEM: (Include error messages and Log files)" );
$table->attach_defaults( $label, 0, 8, 52, 53 );
$label->show();

# Create the GtkText widget
my $text2 = new Gtk::Text( undef, undef );
$text2->set_editable( $true );
$text2->set_word_wrap( $true );
$text2->set_line_wrap( $true );
$text2->set_point(0); # this is probably optional

$table->attach_defaults( $text2, 0, 10, 53, 55);
$text2->show();  
   
# Add a vertical scrollbar to the GtkText widget
my $vscrollbar = new Gtk::VScrollbar( $text2->vadj );
$table->attach_defaults( $vscrollbar,10, 11, 53, 55);
$vscrollbar->show();

########TEXT BOX 4###########
$label = new Gtk::Label( "EXPECTED BEHAVIOR:" );
$table->attach_defaults( $label, 0, 8, 55, 56 );
$label->show();

# Create the GtkText widget
my $text3 = new Gtk::Text( undef, undef );
$text3->set_editable( $true );
$text3->set_word_wrap( $true );
$text3->set_line_wrap( $true );
$text3->set_point(0); # this is probably optional

$table->attach_defaults( $text3, 0, 10, 56, 57);
$text3->show();  
   
# Add a vertical scrollbar to the GtkText widget
my $vscrollbar = new Gtk::VScrollbar( $text3->vadj );
$table->attach_defaults( $vscrollbar,10, 11, 56, 57);
$vscrollbar->show();
######################
####Select Folder#####
######################
$button = new Gtk::Button( "Select Device Folder" );
$button->signal_connect( "clicked",\&file_select );
$table->attach_defaults( $button, 0, 1, 11, 12 );
$button->show();
  $label = new Gtk::Label( "Specify the Device folder path, then choose 'Get Testprogram' or 'Get Testflow' " );
  $table->attach_defaults( $label, 0, 4, 10, 11 );
  $label->show();

##########################
####Testprogram button####
##########################
   	$label = new Gtk::Label( "If 'Get Testprogram' has an empty pulldown menu, click 'Get Testflow':" );
	$table->attach_defaults( $label, 0, 4, 12, 13 );
	$label->show();

#create "testprogram button" button
$button = new Gtk::Button( "Get Testprogram" );
$button->signal_connect( "clicked",\&testprog );

# Insert the testprogram button 
$table->attach_defaults( $button, 0, 1, 13, 14 );
$button->show();

##########################
####Testflow button#######
##########################
#create "testflow button" button
$button = new Gtk::Button( "Get Testflow" );
$button->signal_connect( "clicked",\&testflow );

# Insert the testflow button 
$table->attach_defaults( $button, 1, 2, 13, 14 );
$button->show();   

##############################
####Problem Description#######
##############################
$label = new Gtk::Label("################################Problem Description Below################################");
$table->attach_defaults( $label, 0, 10, 36, 37);
$label->show();

$label = new Gtk::Label("Production Halted?");
$table->attach_defaults( $label, 0, 1, 37, 38);
$label->show();

my $radio13 = new Gtk::RadioButton("N/A");
$table->attach_defaults($radio13, 1, 2, 37, 38);
$radio13->show();
my $radio1 = new Gtk::RadioButton( "Yes", $radio13 );
$table->attach_defaults( $radio1, 2, 3, 37, 38);
$radio1->show();
my $radio2 = new Gtk::RadioButton( "No", $radio13 );
$table->attach_defaults( $radio2, 3, 4, 37, 38);
$radio2->show();

$label = new Gtk::Label("Development Halted?");
$table->attach_defaults( $label, 0, 1, 38, 39);
$label->show();

my $radio14 = new Gtk::RadioButton("N/A");
$table->attach_defaults($radio14, 1, 2, 38, 39);
$radio14->show();
my $radio3 = new Gtk::RadioButton( "Yes", $radio14 );
$table->attach_defaults( $radio3, 2, 3, 38, 39);
$radio3->show();
my $radio4 = new Gtk::RadioButton( "No", $radio14 );
$table->attach_defaults( $radio4, 3, 4, 38, 39);
$radio4->show();

$label = new Gtk::Label("Can issue be seen Offline?");
$table->attach_defaults( $label, 0, 1, 39, 40);
$label->show();

my $radio15 = new Gtk::RadioButton("N/A");
$table->attach_defaults($radio15, 1, 2, 39, 40);
$radio15->show();
my $radio5 = new Gtk::RadioButton( "Yes", $radio15 );
$table->attach_defaults( $radio5, 2, 3, 39, 40);
$radio5->show();
my $radio6 = new Gtk::RadioButton( "No", $radio15 );
$table->attach_defaults( $radio6, 3, 4, 39, 40);
$radio6->show();


$label = new Gtk::Label("Do you need to load device to see problem?");
$table->attach_defaults( $label, 0, 1, 40, 41);
$label->show();

my $radio16 = new Gtk::RadioButton("N/A");
$table->attach_defaults($radio16, 1, 2, 40, 41);
$radio16->show();
my $radio17 = new Gtk::RadioButton( "Yes", $radio16 );
$table->attach_defaults( $radio17, 2, 3, 40, 41);
$radio17->show();
my $radio18 = new Gtk::RadioButton( "No", $radio16 );
$table->attach_defaults( $radio18, 3, 4, 40, 41);
$radio18->show();

$label = new Gtk::Label("Have you already submitted a case?");
$table->attach_defaults( $label, 0, 1, 41, 42);
$label->show();

my $radio19 = new Gtk::RadioButton("N/A");
$table->attach_defaults($radio19, 1, 2, 41, 42);
$radio19->show();
my $radio20 = new Gtk::RadioButton( "Yes", $radio19 );
$table->attach_defaults( $radio20, 2, 3, 41, 42);
$radio20->show();
my $radio21 = new Gtk::RadioButton( "No", $radio19 );
$table->attach_defaults( $radio21, 3, 4, 41, 42);
$radio21->show();

$label = new Gtk::Label( "If yes, State Other consul case report");
$table->attach_defaults($label, 0, 2, 42, 43);
$label->show();	
  my  $entry5 = new Gtk::Entry( 50 );
    $table->attach_defaults( $entry5, 2, 4, 42, 43 );
    $entry5->show();
    
$label = new Gtk::Label("93K Type");
$table->attach_defaults( $label, 0, 1, 43, 44);
$label->show();

my $radio7 = new Gtk::RadioButton( "Single Density" );
$table->attach_defaults( $radio7, 1, 2, 43, 44);
$radio7->show();
my $radio8 = new Gtk::RadioButton( "Pin Scale", $radio7 );
$table->attach_defaults( $radio8, 2, 3, 43, 44);
$radio8->show();
my $radio9 = new Gtk::RadioButton( "High Speed Memory", $radio7 );
$table->attach_defaults( $radio9, 3, 4, 43, 44);
$radio9->show();

$label = new Gtk::Label("Linux Workstation Model");
$table->attach_defaults( $label, 0, 1, 44, 45);
$label->show();

my $radio10 = new Gtk::RadioButton( "XW4100" );
$table->attach_defaults( $radio10, 1, 2, 44, 45);
$radio10->show();
my $radio11 = new Gtk::RadioButton( "XW8100", $radio10 );
$table->attach_defaults( $radio11, 2, 3, 44, 45);
$radio11->show();
my $radio12 = new Gtk::RadioButton( "Other", $radio10 );
$table->attach_defaults( $radio12, 3, 4, 44, 45);
$radio12->show();

$label = new Gtk::Label( "If Other, State Other Workstation Model");
$table->attach_defaults($label, 0, 2, 45, 46);
$label->show();	
  my  $entry2 = new Gtk::Entry( 50 );
    $table->attach_defaults( $entry2, 2, 4, 45, 46 );
    $entry2->show();
    
################
###Save Button##
################
# Create "Save" button
$button = new Gtk::Button( "Save" );
$button->signal_connect( "clicked",\&Save );

# Insert the Save button 
$table->attach_defaults( $button, 0, 1, 0, 1 );
$button->show();

$label = new Gtk::Label( "Saves input data fields to user.txt");
$table->attach_defaults ($label, 1, 3, 0, 1 );
$label->show();

#################
###Tar and send###
#################
# Create "tar" button
$button = new Gtk::Button( "Tar & Send" );
$button->signal_connect( "clicked",\&tar );

# Insert the tar button 
$table->attach_defaults( $button, 0, 1, 1, 2 );
$button->show();

$label = new Gtk::Label( "Tar important files & ftp");
$table->attach_defaults ($label, 1, 3, 1, 2 );
$label->show();

##################
###Help button####
##################
# Create "Help" button
$button = new Gtk::Button( "Help" );
$button->signal_connect( "clicked", \&help );

# Insert the quit button into the both lower quadrants of the table
$table->attach_defaults( $button, 0, 1, 2, 3 );
$button->show();

$label = new Gtk::Label( "Pull up the Help file");
$label->set_justify( 'left' );
$table->attach_defaults ($label, 1, 3, 2, 3 );
$label->show();

################
###Quit Button##
################
# Create "Quit" button
$button = new Gtk::Button( "Quit" );
$button->signal_connect( "clicked", sub { Gtk->exit( 0 ); } );

# Insert the quit button into the both lower quadrants of the table
$table->attach_defaults( $button, 0, 1, 3, 4 );
$button->show();

$table->show();
$window->show();
###############
##Quit Button##
###############



main Gtk;
exit( 0 );

  sub Save
  {

    system ("rm -r $result_dir 2>$FILENAME100");
    system ("rm $FILENAME100");
    system ("mkdir $result_dir");
    my $FILENAME37 = "$result_dir/problem_description.txt";
    #####PROBLEM DESCRIPTION AREA##########
    open (FILEWRITE, ">$FILENAME37") || warn "$FILENAME37 could not save";
    print FILEWRITE "Severity:     [$severity_combo]\n";
    print FILEWRITE "Priority:     [$priority_combo]\n";
    print FILEWRITE "Type:         [$type_combo]\n";
    print FILEWRITE "Class Type:   [$comp]\n";
    if ($comp eq "Hardware")
    {
    print FILEWRITE "Sub Category: [$hardware_b]\n";
    	if ($hardware_b eq "Analog")
	{
        print FILEWRITE "Item:         [$analog_device_c]\n";
        }
	if ($hardware_b eq "DPS")
	{
        print FILEWRITE "Item:         [$dps_c]\n";
        }
	if ($hardware_b eq "Digital")
	{
        print FILEWRITE "Item:         [$digital_c]\n";
        }
	if ($hardware_b eq "External")
	{
        print FILEWRITE "Item:         [$external_c]\n";
        }
	if ($hardware_b eq "RF")
	{
        print FILEWRITE "Item:         [$rf_c]\n";
        }
    }
    if ($comp eq "Smartest")
    {
    print FILEWRITE "Sub Category: [$smartest_b]\n";
        if ($smartest_b eq "Analog Setup")
	{
        print FILEWRITE "Item:         [$analog_setup_c]\n";
        }
	if ($smartest_b eq "Digital Setup")
	{
        print FILEWRITE "Item:         [$digital_setup_c]\n";
        }
	if ($smartest_b eq "RF Setup")
	{
	print FILEWRITE "Item:         [$rf_setup_c]\n";
	}
	if ($smartest_b eq "DPS Setup")
	{
	print FILEWRITE "Item:         [$dps_setup_c]\n";
	}
    }
    if ($comp eq "Documentation")
    {
    print FILEWRITE "Sub Category: [$documentation_b]\n";
    }
    if ($comp eq "ST - ASCII IF")
    {
    print FILEWRITE "Sub Category: [$ascii_b]\n";
    }
    print FILEWRITE "\n\n==============================================================================\n";
    print FILEWRITE "STS CONSUL DEFECT CASE SUBMISSION REQUIREMENTS (NOT REQUIRED FOR ENHANCEMENTS)\n";
    print FILEWRITE "==============================================================================\n";
    print FILEWRITE "\nCASES NOT ADHERING TO THE FOLLOWING REQUIREMENTS OR NOT ANSWERING THE FOLLOWING\n\n";
    print FILEWRITE "\n========= CRITICAL IMPACT (i.e. a 'Showstopper')=======================\n\n";
        my $NA = $radio13->get_active();
	my $production = "N/A" if ($NA ==1);
	my $yes = $radio1->get_active();
        $production = "Y" if ($yes == 1);
        my $no = $radio2->get_active();
        $production = "N" if ($no == 1);
    print FILEWRITE "Production Halted?  $production\n";
        my $NA = $radio14->get_active();
	my $development = "N/A" if ($NA ==1);
        my $yes = $radio3->get_active();
        my $development = "Y" if ($yes == 1);
        my $no = $radio4->get_active();
        $development = "N" if ($no == 1);
    print FILEWRITE "Development Halted? $development\n";
    print FILEWRITE "\n========= EXECUTION MODE / MODEL AND SETUP FILES ================\n";
        my $NA = $radio15->get_active();
	my $Offline = "N/A" if ($NA ==1);
        my $yes = $radio5->get_active();
        my $Offline = "Y" if ($yes == 1);
        my $no = $radio6->get_active();
        $Offline = "N" if ($no == 1);
    print FILEWRITE "\nCan issue be seen Offline? $Offline\n";
    print FILEWRITE "\n\n========= LOCATION/NAME OF CASE FILES =================================\n";
    print FILEWRITE "Put a tar file with sample device dir and related files on:\n";
    print FILEWRITE "\nFTP Server: ftp.servername.com\n";
    print FILEWRITE "\nIF POSSIBLE, PLEASE NAME (OR RENAME) THE TAR FILE WITH THE CASE NUMBER <case-number.tar.gz>\n";
    print FILEWRITE "\nNAME OF YOUR TAR FILE: [$workstation-$date.tar.gz]\n";
    print FILEWRITE "\nMODEL FILE (MANDATORY)\n";
    print FILEWRITE "    Name of Model File [$model]\n";
    print FILEWRITE "\n    Model File Location:  [ ] In device directory\n";
    print FILEWRITE "                          [X] Attached to case\n";
    print FILEWRITE "                          [ ] Uploaded to ftp site as separate file\n";
    print FILEWRITE "\n\n======== SETUP INFORMATION ================================\n";
    print FILEWRITE "Place an X or information in the boxes as appropriate:\n";
        my $yes = $radio7->get_active();
        my $single;
	if ($yes == 1)
	{$single = "X";}
	else
	{$single = " ";}
        $yes = $radio8->get_active();
	my $Pin_Scale;
        if ($yes == 1)
	{$Pin_Scale= "X";}
	else
	{$Pin_Scale= " ";}
	$yes = $radio9->get_active();
	my $high_speed;
        if ($yes == 1)
	{$high_speed= "X";} 
	else 
	{$high_speed = " ";}
    print FILEWRITE "\n93K Type:  Single Density      [$single]\n";
    print FILEWRITE "           Pin Scale           [$Pin_Scale]\n";
    print FILEWRITE "           High Speed Memory   [$high_speed]\n";
    print FILEWRITE "\n\n------------------------------------------------------------------------------\n";
    print FILEWRITE "The following rev info is mandatory for Linux cases\n";
    print FILEWRITE "\n   Revision:     [$rhel]  Example: RHEL 3.0\n";
    print FILEWRITE "\n   Update Rev    [$redhat]  example: Taroon 3\n";
    print FILEWRITE "    Check by typing: cat /etc/redhat-release\n";
    print FILEWRITE "\n   Kernel Rev    [$uname]    example 2.4.21-4ELsmp\n";
    print FILEWRITE "    Check OS version and kernel by typing: uname -a\n";
        my $yes = $radio10->get_active();
        my $XW4100;
	if ($yes == 1)
	{$XW4100 = "X";}
	else
	{$XW4100 = " ";}
        $yes = $radio11->get_active();
	my $XW8100;
        if ($yes == 1)
	{$XW8100= "X";}
	else
	{$XW8100= " ";}
	$yes = $radio12->get_active();
	my $other;
        if ($yes == 1)
	{$other = "X";} 
	else 
	{$other = " ";}
	
    my $w_model = $entry2->get_text();
    print FILEWRITE "\n   Linux Workstation Model:  XW4100 [$XW4100]  XW8100 [$XW8100]   Other [$other]\n";
    if ($yes == 1)
    {
    print FILEWRITE "       Other Linux Workstation Model: [$w_model]\n";
    }
    print FILEWRITE "-------------------------------------------------------------------------------\n";
    print FILEWRITE "\nTESTPROGRAM INFO\n";
    print FILEWRITE "             Device Name: [$device]\n";
    print FILEWRITE "       Test Program Name: [$prog]\n";
    print FILEWRITE "           Testflow Name: [$current]\n";
    print FILEWRITE "\n\n======== DETAILED DUPLICATION INSTRUCTIONS ================\n";
    print FILEWRITE "PREPARATION:  (Mention any other special setup info.)\n";
        $text6->freeze;
	my $length = $text6->get_length;
	my $text7 = $text6->get_chars(0,$length);
	print FILEWRITE "$text7";
	$text6->thaw;
    print FILEWRITE "\n-------------------------------------------------------------------------------\n";
    print FILEWRITE "STEP-BY-STEP PROCESS:(The quality of this description directly affects duplication time. If you would rather demonstrate the issue, please mention this here.)\n";
    	$text->freeze;
	my $length = $text->get_length;
	my $text1 = $text->get_chars(0,$length);
	print FILEWRITE "$text1";
	$text->thaw;
    print FILEWRITE "\n\n\n\nOBSERVED PROBLEM: (Include error messages and Log files)\n";
    	$text2->freeze;
	my $length = $text2->get_length;
	my $text4 = $text2->get_chars(0,$length);
	print FILEWRITE "$text4";
	$text2->thaw;
    print FILEWRITE "\n\nEXPECTED BEHAVIOR:\n";
    	$text3->freeze;
	my $length = $text3->get_length;
	my $text5 = $text3->get_chars(0,$length);
	print FILEWRITE "$text5";
	$text3->thaw;
    print FILEWRITE "\n\n\n========== SUBMISSION REQUIREMENTS =====================================\n";
        my $NA = $radio16->get_active();
	my $load = "N/A" if ($NA ==1);
	my $yes = $radio17->get_active();
        $load = "Y" if ($yes == 1);
        my $no = $radio18->get_active();
        $load = "N" if ($no == 1);
    print FILEWRITE "Do you need to load device to see problem? $load\n";
        my $NA = $radio19->get_active();
	my $repeat = "N/A" if ($NA ==1);
	my $yes = $radio20->get_active();
        $repeat = "Y" if ($yes == 1);
        my $no = $radio21->get_active();
        $repeat = "N" if ($no == 1);
    print FILEWRITE "\nHave you already submitted a consul case? $repeat\n";
    my $c_case = $entry5->get_text();
    if ($yes == 1)
    {
    print FILEWRITE "     Other Consul Case file: [$c_case]\n";
    }
 
  #  print FILEWRITE "\nA SAMPLE DEVICE IS REQUIRED\n";
  #  print FILEWRITE "*For issues that can be seen without loading any device, simply mention this in your instructions\n";
  #  print FILEWRITE "\n*If you have already submitted a test device with another case,\n";
  #  print FILEWRITE "enter that case number here: [              ]\n";
  #  print FILEWRITE "\nOFFLINE DUPLICATION\n";
  #  print FILEWRITE "* Customer device files, and model file, must be supplied when the case is submitted. The FTP site information is given below.\n";
  #  print FILEWRITE "\nONLINE DUPLICATION\n";
  #  print FILEWRITE "* A device and model file are still required - the setup must be simplified to run on a simple system (because this is all that exists at the factory or R&D).  This means: remove all resources that are not part of the error like analog, NP, etc. Use minimum number of pins.\n";
  #  print FILEWRITE "\n* If you wish to use the digital training device 74ACT299, instead of simplifying the customer";#\x{2019}s
  #  print FILEWRITE " device please download it from: http://atginside.agilent.com/socbu/training/index.asp\n";
  #  print FILEWRITE "Look under: User Training 93000\n";
  #  print FILEWRITE "            --> User Training Part 1 (Digital)\n";
  #  print FILEWRITE "              --> pt1_lab_solutions_4.2.0.tar.gz\n";
  #  print FILEWRITE "\nOTHER REQUIREMENTS\n";
  #  print FILEWRITE "* ASCII interface cases require an executable conversion file setup\n";
  #  print FILEWRITE "\n* All Testmethod or User Procedure related directories must be local to the device directory.\n";
  #  print FILEWRITE "\n* The specific software release number must be mentioned (i.e. '4.3.x' is not appropriate)\n";
    close FILEWRITE;
    my $FILENAME102 = "$result_dir/saved_files.txt";
      open (FILEWRITE, "> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "Files Saved in directory\n\n\n";
	 print FILEWRITE "consul_tool/problem_description.txt\n";
      close FILEWRITE;
    
    my $FILENAME1= "$result_dir/info.txt";
    open (FILEWRITE, ">$FILENAME1") || warn "info.txt could not save";
    print FILEWRITE "INFORMATION FILE \n \n \n";
    print FILEWRITE "Linux Version: $uname \n \n \n" || warn "WARNING: Linux Version not saved into $result_dir/info.txt";;
    print FILEWRITE "Redhat Version: $redhat \n \n \n" || warn "WARNING: Redhat Version not saved into $result_dir/info.txt";;
    print FILEWRITE "Smartest Revision: $smartest \n \n \n" || warn "WARNING: Smartest Revision not saved into $result_dir/info.txt";;
    print FILEWRITE "df Information\n  $df_text \n \n \n" || warn "WARNING: df Information not saved into $result_dir/info.txt";;
    print FILEWRITE "/etc/hosts file: \n $host_text \n \n \n" || warn "WARNING: /etc/hosts not saved into $result_dir/info.txt";;
    print FILEWRITE "/etc/resolv.conf file: \n $resolv_text\n \n \n" || warn "WARNING: /etc/resolv.conf not saved into $result_dir/info.txt";;
    print FILEWRITE "free command output: \n $free_text \n \n \n" || warn "WARNING: free command not saved into $result_dir/info.txt";;
    print FILEWRITE "vmstat command output: \n $vmstat_text \n \n \n" || warn "WARNING: vmstat command not saved into $result_dir/info.txt";
    close FILEWRITE;
###################Diag folder
    	system ("mkdir $result_dir/Diag 2>$FILENAME100");
	system ("rm $FILENAME100");
	
	system ("cp /var/opt/hp93000/$smartest/MCDvmdump /$result_dir/Diag 2>$FILENAME100");
	system ("cp /var/opt/hp93000/$smartest/MCDsmdump /$result_dir/Diag 2>>$FILENAME100");
	if (-z $FILENAME100)
	{
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/MCDvmdump\n";
	 print FILEWRITE "consul_tool/Diag/MCDsmdump\n";
      close FILEWRITE;
	}
	else
	{
	
	open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/MCDvmdump not saved because no content\n";
	 print FILEWRITE "consul_tool/Diag/MCDsmdump not saved because no content\n";
      close FILEWRITE;
      }
      system ("rm $FILENAME100");
      system ("cp /var/opt/hp93000/$smartest/MCDseqdump /$result_dir/Diag 2>$FILENAME100");
	system ("cp /var/opt/hp93000/$smartest/MCDvirtseqdump /$result_dir/Diag 2>>$FILENAME100");
	if (-z $FILENAME100)
	{
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/MCDseqdump\n";
	 print FILEWRITE "consul_tool/Diag/MCDvirtseqdump\n";
      close FILEWRITE;
	}
	else
	{
	
	open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/MCDseqdump not saved because no content\n";
	 print FILEWRITE "consul_tool/Diag/MCDvirtseqdump not saved because no content\n";
      close FILEWRITE;
      }
      system ("rm $FILENAME100");
	system ("echo 'diag -2' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag2_error");

	system ("ls /tmp | grep diag2_error >/tmp/check");
	if (-z "/tmp/check")
	{
	print "The testflow did not produce firmware commands\n";
	open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
        print FILEWRITE "MCDLog has bad data\n";
      	close FILEWRITE;
	}
	else
	{
	system ("rm /tmp/diag2_error");
	}
	system ("rm /tmp/check");
	system ("cp /var/opt/hp93000/$smartest/MCDLog /$result_dir/Diag 2>$FILENAME100");
	if (-z $FILENAME100)
	{
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/MCDLog\n";
      close FILEWRITE;
	}
	system ("rm $FILENAME100");

	system ("echo 'diag -21' | /opt/hp93000/soc/pws/bin/hpt 2>/tmp/diag2_error");
	system ("ls /tmp | grep diag2_error >/tmp/check");
	if (-z "/tmp/check")
	{
	print "Diag -21 did not work\n";
	open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
        print FILEWRITE "MCDErr has bad data\n";
      	close FILEWRITE;
	}
	else
	{
	system ("rm /tmp/diag2_error");
	}
	system ("rm /tmp/check");
	system ("cp /var/opt/hp93000/$smartest/MCDErr /$result_dir/Diag 2>$FILENAME100");
	if (-z $FILENAME100)
	{
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/MCDErr\n";
      close FILEWRITE;
	}
	else
	
	{
      open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/MCDErr\n";
      close FILEWRITE;
      }
	system ("rm $FILENAME100");
	
	system ("cp /var/opt/hp93000/$smartest/LPM_Basetable /$result_dir/Diag 2>$FILENAME100");
	if (-z $FILENAME100)
	{
        open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/LPM_Basetable\n";
        close FILEWRITE;
	}
	else
        {
	open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/LPM_Basetable not saved because no content\n";
        close FILEWRITE;
        }
	system ("rm $FILENAME100");
	system ("cp /var/opt/hp93000/$smartest/ReportLog /$result_dir/Diag 2>$FILENAME100");
	if (-z $FILENAME100)
	{
        open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/ReportLog\n";
        close FILEWRITE;
	}
	else
        {
	open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "consul_tool/Diag/ReportLog not saved because no content\n";
        close FILEWRITE;
        }
	system ("rm $FILENAME100");

     ###############Workstation Hardware and Software################
my $FILENAME20 = "/$result_dir/rpm-qa.txt";
    system( "rpm -qa > $FILENAME20" );
      open(FILEREAD, "< $FILENAME20") || warn "file: $FILENAME20 did not open for reading";
	my @line = <FILEREAD>;
      close FILEREAD;
      @rpm = (sort {lc($a) cmp lc($b)} @line); 
      open (FILEWRITE, "> $FILENAME20") || warn "file: $FILENAME20 did not open for writing";
         print FILEWRITE "rpm -qa sorted data \n \n \n";
	 print FILEWRITE " @rpm";
      close FILEWRITE;
    system ("mkdir $result_dir/WS_HW-SW 2>$FILENAME100");
    system ("rm $FILENAME100");
    system ("mv $result_dir/rpm-qa.txt $result_dir/WS_HW-SW") || warn "SAVING: rpm-qa.txt saved into $result_dir/WS_HW-SW";
    system ("mv $result_dir/info.txt $result_dir/WS_HW-SW") || warn "SAVING: info.txt saved into $result_dir/WS_HW-SW";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/WS_HW-SW/info.txt\n";
      close FILEWRITE;
    #get root lspci
    system ("/var/opt/rootinfo 2>$FILENAME100");
    system ("rm $FILENAME100");
      open (FILEWRITE, "> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "Files Not Saved in directory\n\n\n";
      close FILEWRITE;
    system ("ls /tmp/ > $result_dir/tmpinfo");
    system ("grep -a lspc $result_dir/tmpinfo > $result_dir/check");
    open (FILEREAD, "< $result_dir/check") || warn "lspci file not created";
   	my $split = <FILEREAD>;
        my @split = split (/\s+/, $split);
    close FILEREAD;
    system ("mv /tmp/$split[0] $result_dir 2>$FILENAME100");
    system ("mv $result_dir/$split[0] $result_dir/lspci 2>$FILENAME100");
    if (-s "$result_dir/lspci")
    {
    system ("cp $result_dir/lspci $result_dir/WS_HW-SW/ ") || warn "SAVING:lspci saved into $result_dir/WS_HW-SW";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/WS_HW-SW/lspci\n";
      close FILEWRITE;
    }
    else
    {
    print "##############################################\n";
    print "ERROR: lspci not saved because no content \n";
    print "##############################################\n";
      open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "lspci not saved because no content\n";
      close FILEWRITE;
    } 
    system ("rm $result_dir/lspci 2>$FILENAME100");
    system ("rm $FILENAME100");
    ##get dmidecode
    system ("grep -a dmid $result_dir/tmpinfo > $result_dir/check");
    open (FILEREAD, "< $result_dir/check") || warn "dmid file not created";
   	my $split = <FILEREAD>;
        my @split = split (/\s+/, $split);
    close FILEREAD;
    system ("mv /tmp/$split[0] $result_dir 2>$FILENAME100");
    system ("mv $result_dir/$split[0] $result_dir/dmidecode 2>$FILENAME100");
    if (-s "$result_dir/dmidecode")
    {
    system ("cp $result_dir/dmidecode $result_dir/WS_HW-SW/") || warn "SAVING: dmidecode saved into $result_dir/WS_HW-SW";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/WS_HW-SW/dmidecode\n";
      close FILEWRITE;
    }
    else
    {
    print "##############################################\n";
    print "ERROR: dmidecode not saved because no content \n";
    print "##############################################\n";
      open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "dmidecode not saved because no content\n";
      close FILEWRITE;
    } 
    system ("rm $result_dir/dmidecode 2>$FILENAME100");
    system ("rm $FILENAME100");
    ##get root ifconfig
    system ("grep -a ifco $result_dir/tmpinfo > $result_dir/check");
    open (FILEREAD, "< $result_dir/check") || warn "ifconfig file not created";
   	my $split = <FILEREAD>;
        my @split = split (/\s+/, $split);
    close FILEREAD;
    system ("mv /tmp/$split[0] $result_dir 2>$FILENAME100");
    system ("mv $result_dir/$split[0] $result_dir/ifconfig 2>$FILENAME100");
    if (-s "$result_dir/ifconfig")
    {
    system ("cp $result_dir/ifconfig $result_dir/WS_HW-SW/") || warn "SAVING: ifconfig saved into $result_dir/WS_HW-SW";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/WS_HW-SW/ifconfig\n";
      close FILEWRITE;
    }
    else
    {
    print "##############################################\n";
    print "ERROR: ifconfig not saved because no content \n";
    print "##############################################\n";
      open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "ifconfig not saved because no content\n";
      close FILEWRITE;
    } 
    system ("rm $result_dir/check");
    
    system ("rm $result_dir/ifconfig 2>$FILENAME100");
    system ("rm $FILENAME100");
    system ("rm $result_dir/tmpinfo");

    ##############Smartest Software###########################
    
    system ("mkdir $result_dir/Smartest_SW 2>$FILENAME100");
    system ("mkdir $result_dir/Smartest_SW/Testflow_files 2>$FILENAME100");
    system ("rm $FILENAME100");
    system ("ls /opt/hp93000 > $result_dir/Smartest_SW/version.txt 2>$FILENAME100");
    if (-z "$FILENAME100")
    {
    print "SAVING: version.txt saved to $result_dir/WS_HW-SW/ \n";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Smartest_SW/version.txt\n";
      close FILEWRITE;
    }
    else
    {
    print "##############################################\n";
    print "WARNING: ls /opt/hp93000 has no output \n";
    print "##############################################\n";
      open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "consul_tool/Smartest_SW/version.txt not saved because no content\n";
      close FILEWRITE;
    } 
    system ("rm $FILENAME100");
   
    system ("cp -r /opt/flexlm/license $result_dir/Smartest_SW 2>$FILENAME100");
    if (-z "$FILENAME100")
    {
    print "SAVING: /opt/flexlm/license saved to $result_dir/Smartest_SW\n";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Smartest_SW/license\n";
      close FILEWRITE;
    }
    else
    {
    print "##############################################\n";
    print "WARNING: No files in /opt/flexlm/license \n";
    print "##############################################\n";
      open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "/opt/flexlm/license not saved because no content\n";
      close FILEWRITE;
    } 
    system ("rm $FILENAME100");
    
    system ("cp -r /opt/flexlm/local_license $result_dir/Smartest_SW 2>$FILENAME100");
    if (-z "$FILENAME100")
    {
    print "SAVING: /opt/flexlm/local_license saved to $result_dir/Smartest_SW\n";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Smartest_SW/local_license\n";
      close FILEWRITE;
    }
    else
    {
    print "##############################################\n";
    print "WARNING: No files in /opt/flexlm/local_license \n";
    print "##############################################\n";
      open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "/opt/flexlm/local_license not saved because no content\n";
      close FILEWRITE;
    } 
    system ("rm $FILENAME100");
    system ("cp -r /opt/flexlm/log $result_dir/Smartest_SW 2>$FILENAME100");
    if (-z "$FILENAME100")
    {
    print "SAVING: /opt/flexlm/log saved to $result_dir/Smartest_SW\n";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Smartest_SW/log\n";
      close FILEWRITE;
    }
    else
    {
    print "##############################################\n";
    print "WARNING: No files in /opt/flexlm/log \n";
    print "##############################################\n";
      open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "/opt/flexlm/log not saved because no content\n";
      close FILEWRITE;
    } 
    system ("rm $FILENAME100");
    system ("mkdir $result_dir/Smartest_SW/Testflow_files/configuration 2>$FILENAME100");
    system ("mkdir $result_dir/Smartest_SW/Testflow_files/levels 2>$FILENAME100");
    system ("mkdir $result_dir/Smartest_SW/Testflow_files/timing 2>$FILENAME100");
    system ("mkdir $result_dir/Smartest_SW/Testflow_files/vectors 2>$FILENAME100");
    system ("mkdir $result_dir/Smartest_SW/Testflow_files/pin_attributes 2>$FILENAME100");
    system ("mkdir $result_dir/Smartest_SW/Testflow_files/analog_control 2>$FILENAME100");
    system ("mkdir $result_dir/Smartest_SW/Testflow_files/waveform 2>$FILENAME100");
    system ("mkdir $result_dir/Smartest_SW/Testflow_files/routing 2>$FILENAME100");
    
    system ("cp $file/configuration/$pin /$result_dir/Smartest_SW/Testflow_files/configuration 2>$FILENAME100");
    system ("cp $file/levels/$levels /$result_dir/Smartest_SW/Testflow_files/levels 2>$FILENAME100");
    system ("cp $file/timing/$timing /$result_dir/Smartest_SW/Testflow_files/timing 2>$FILENAME100");
    system ("cp $file/vectors/$vector /$result_dir/Smartest_SW/Testflow_files/vectors 2>$FILENAME100");
    system ("cp $file/pin_attributes/$attrib /$result_dir/Smartest_SW/Testflow_files/pin_attributes 2>$FILENAME100");
    system ("cp $file/analog_control/$analog /$result_dir/Smartest_SW/Testflow_files/analog_control 2>$FILENAME100");
    system ("cp $file/waveform/$waveform /$result_dir/Smartest_SW/Testflow_files/waveform 2>$FILENAME100");
    system ("cp $file/routing/$routing /$result_dir/Smartest_SW/Testflow_files/routing 2>$FILENAME100");
    if (-z "$FILENAME100")
    {
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/configuration\n";
      	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/levels\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/timing\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/vectors\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/pin_attributes\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/analog_control\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/waveform\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/routing\n";
      close FILEWRITE;
    }
    else
    {
         open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
        print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/configuration\n";
     	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/levels\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/timing\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/vectors\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/pin_attributes\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/analog_control\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/waveform\n";
	 print FILEWRITE "consul_tool/Smartest_SW//Testflow_files/routing\n";
      close FILEWRITE;
     }
    system (" rm $FILENAME100");

     
       system ("cp /etc/opt/hp93000/soc_common/$model /$result_dir/Smartest_SW 2>$FILENAME100");
       if (-z "$FILENAME100")
       {
       print "SAVING: /etc/opt/hp93000/soc_common/$model saved to $result_dir/Smartest_SW\n";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Smartest_SW/$model\n";
      close FILEWRITE;
       }
       else
       {
       print "#############################################################\n";
       print "WARNING: WARNING: Check $model file \n";
       print "#############################################################\n";
        open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
            print FILEWRITE "###### Compare /etc/opt/hp93000/soc_common/$model to /tmp/consul_tool/Smartest_SW/model\n";
         close FILEWRITE;
   	}
    system ("rm $FILENAME100");
    
    #################Tester Hardware########################
    system ("mkdir $result_dir/Tester_HW 2>$FILENAME100");
    system ("mkdir $result_dir/Tester_HW/var 2>$FILENAME100\n mkdir $result_dir/Tester_HW/etc 2>$FILENAME100");
    
    system ("rm $FILENAME100");
    system ("cp /tmp/ReportWindow.dump $result_dir/Tester_HW 2>$FILENAME100");
    if (-z "$FILENAME100")
    {
    print "SAVING: /tmp/ReportWindow.dump saved to $result_dir/Tester_HW\n";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Tester_HW/var/ReportWindow.dump\n";
      close FILEWRITE;
    }
    else
    {
    print "##############################################\n";
    print "WARNING: No file in /tmp/ReportWindow.dump \n";
    print "##############################################\n";
      open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "/tmp/ReportWindow.dump not saved because no content\n";
      close FILEWRITE;
    } 
    system ("rm $FILENAME100");
 #******************checking if file is too big to save Diagnostic******************
   my $window2;
   my $table2;
   my $button2;
   my $label2;

    system ("ls -al /var/opt/hp93000/soc_common/ >$result_dir/tmp");
    system ("grep -a diagnostic $result_dir/tmp > $result_dir/diag_size");
      open (FILEREAD, "< $result_dir/diag_size") || warn "file; $result_dir/diag_size could not open";
        chomp(my $split = <FILEREAD>);
        my @split = split (/\s+/, $split);
      close FILEREAD;
     system ("rm $result_dir/diag_size");
     system ("rm $result_dir/tmp");  
    if ($split[4] <= $filesize1)
    {
      	system ("cp -r /var/opt/hp93000/soc_common/diagnostic $result_dir/Tester_HW/var 2>$FILENAME100");
      	if (-z "$FILENAME100")
     	 {
     		 print "SAVING: /var/opt/hp93000/soc_common/diagnostic saved to $result_dir/Tester_HW/var\n";
    	    	open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         		print FILEWRITE "consul_tool/Tester_HW/var/diagnostic\n";
     	 	close FILEWRITE;
	  }
      	else
     	 {
     		print "##############################################\n";
      		print "WARNING: No file in /var/opt/hp93000/soc_common/diagnostic \n";
      		print "##############################################\n";
        	open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
          	 print FILEWRITE "/var/opt/hp93000/soc_common/diagnostic not saved because no content\n";
        	close FILEWRITE;
     	 } 
     	 system ("rm $FILENAME100");
				 #****************************check if calibration is too big
     				system ("ls -al /var/opt/hp93000/soc_common/ >$result_dir/tmp");
    				system ("grep -a calibration $result_dir/tmp > $result_dir/diag_size");
      				open (FILEREAD, "< $result_dir/diag_size") || warn "file; $result_dir/diag_size could not open";
        			chomp(my $split = <FILEREAD>);
        			my @split = split (/\s+/, $split);
      				close FILEREAD;
     				system ("rm $result_dir/diag_size");
     				system ("rm $result_dir/tmp"); 
    				if ($split[4] <= $filesize2)
    				{
      					system ("cp -r /var/opt/hp93000/soc_common/calibration $result_dir/Tester_HW/var 2>$FILENAME100");
      					if (-z "$FILENAME100")
     	 				{
     					 print "SAVING: /var/opt/hp93000/soc_common/calibration saved to $result_dir/Tester_HW/var\n";
    	  				  open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         					print FILEWRITE "consul_tool/Tester_HW/var/calibration\n";
      					  close FILEWRITE;
					}
      					else
     				 	{
     					print "##############################################\n";
      					print "WARNING: No file in /var/opt/hp93000/soc_common/calibration \n";
      					print "##############################################\n";
        				open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
          				 print FILEWRITE "/var/opt/hp93000/soc_common/calibration not saved because no content\n";
        				close FILEWRITE;
     					 } 
     	 				system ("rm $FILENAME100");
				}
    				else
    				{
     	 			$window1 = new Gtk::Window( "toplevel" );
				$window1->signal_connect( "delete_event", sub { $window->hide(); } );
				$window1->title( "File too big" );
				$window1->border_width( 20 );

				$table = new Gtk::Table( 2, 2, $true );
				$window1->add( $table );
		
				$label = new Gtk::Label( "File size = $split[4], Do you want to Save Calibration?");
				$table->attach_defaults( $label, 0, 2, 0, 1 );
  				$label->show();
		
				$button = new Gtk::Button( "yes" );
				$button->signal_connect( "clicked", \&yes1);

				# Insert button 1 into the upper left quadrant of the table
				$table->attach_defaults( $button, 0, 1, 1, 2);
				$button->show();

				#Create second button
				$button = new Gtk::Button( "no" );
				$button->signal_connect( "clicked", \&no1 );

				# Insert button 2 into the upper right quadrant of the table
				$table->attach_defaults( $button, 1, 2, 1, 2);
				$button->show();

				$table->show();
				$window1->show();

   				 }	
    }
    else
    {
     	 	$window2 = new Gtk::Window( "toplevel" );
		$window2->signal_connect( "delete_event", sub { $window2->hide(); } );
		$window2->title( "File too big" );
		$window2->border_width( 20 );

		$table2 = new Gtk::Table( 2, 2, $true );
		$window2->add( $table2 );
		
		$label2 = new Gtk::Label( "File size = $split[4], Do you want to Save Diagnositc?");
		$table2->attach_defaults( $label2, 0, 2, 0, 1 );
  		$label2->show();
		
		$button2 = new Gtk::Button( "yes" );
		$button2->signal_connect( "clicked", sub
 						{

   						system ("cp -r /var/opt/hp93000/soc_common/diagnostic $result_dir/Tester_HW/var 2>$FILENAME100");
   						my $file_size1 = "1";  	
						if (-z "$FILENAME100")
     	 					{
     		 				print "SAVING: /var/opt/hp93000/soc_common/diagnostic saved to $result_dir/Tester_HW/var\n";
    	 					  open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
       						  print FILEWRITE "consul_tool/Tester_HW/var/diagnostic\n";
      						close FILEWRITE; 
						 }
      						else
     	 					{
     						print "##############################################\n";
      						print "WARNING: No file in /var/opt/hp93000/soc_common/diagnostic \n";
      						print "##############################################\n";
        					open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
          	 				print FILEWRITE "/var/opt/hp93000/soc_common/diagnostic not saved because no content\n";
        					close FILEWRITE;
     						 } 
     	 					system ("rm $FILENAME100");
	   					$window2->hide();
									 #****************************check if calibration is too big
    									system ("ls -al /var/opt/hp93000/soc_common/ >$result_dir/tmp");
    									system ("grep -a calibration $result_dir/tmp > $result_dir/diag_size");
      									open (FILEREAD, "< $result_dir/diag_size") || warn "file; $result_dir/diag_size could not open";
        								chomp(my $split = <FILEREAD>);
       			 						my @split = split (/\s+/, $split);
      									close FILEREAD;
     									system ("rm $result_dir/diag_size");
    			 						system ("rm $result_dir/tmp"); 
    									if ($split[4] <= $filesize2)
    									{
      									system ("cp -r /var/opt/hp93000/soc_common/calibration $result_dir/Tester_HW/var 2>$FILENAME100");
      									 if (-z "$FILENAME100")
     	 								 { 
     									  print "SAVING: /var/opt/hp93000/soc_common/calibration saved to $result_dir/Tester_HW/var\n";
    	  								   open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
        								 print FILEWRITE "consul_tool/Tester_HW/var/calibration\n";
     									 close FILEWRITE;
									 }
      									 else
     				 					 {
     									 print "##############################################\n";
      									 print "WARNING: No file in /var/opt/hp93000/soc_common/calibration \n";
      									 print "##############################################\n";
        								 open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
          								  print FILEWRITE "/var/opt/hp93000/soc_common/calibration not saved because no content\n";
        								 close FILEWRITE;
     	 								 } 
     	 								system ("rm $FILENAME100");
    									}
   			 						else
   			 						{
     	 								$window1 = new Gtk::Window( "toplevel" );
									$window1->signal_connect( "delete_event", sub { $window->hide(); } );
									$window1->title( "File too big" );
									$window1->border_width( 20 );

									$table = new Gtk::Table( 2, 2, $true );
									$window1->add( $table );
		
									$label = new Gtk::Label( "File size = $split[4], Do you want to Save Calibration?");
									$table->attach_defaults( $label, 0, 2, 0, 1 );
  									$label->show();
		
									$button = new Gtk::Button( "yes" );
									$button->signal_connect( "clicked", \&yes1);

									# Insert button 1 into the upper left quadrant of the table
									$table->attach_defaults( $button, 0, 1, 1, 2);
									$button->show();

									#Create second button
									$button = new Gtk::Button( "no" );
									$button->signal_connect( "clicked", \&no1 );

									# Insert button 2 into the upper right quadrant of the table
									$table->attach_defaults( $button, 1, 2, 1, 2);
									$button->show();

									$table->show();
									$window1->show();

   									 }
			 		
    						}, "button 1" );

		# Insert button 1 into the upper left quadrant of the table
		$table2->attach_defaults( $button2, 0, 1, 1, 2 );
		$button2->show();

		#Create second button
		$button2 = new Gtk::Button( "no" );
		$button2->signal_connect( "clicked", sub 
  						{
      						my $file_size1 = "1";
     						open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
          					print FILEWRITE "/var/opt/hp93000/soc_common/diagnostic not saved because no content\n";
     						close FILEWRITE;
        					$window2->hide();
						
									#****************************check if calibration is too big
     									system ("ls -al /var/opt/hp93000/soc_common/ >$result_dir/tmp");
    									system ("grep -a calibration $result_dir/tmp > $result_dir/diag_size");
      									open (FILEREAD, "< $result_dir/diag_size") || warn "file; $result_dir/diag_size could not open";
        								chomp(my $split = <FILEREAD>);
        								my @split = split (/\s+/, $split);
      									close FILEREAD;
     									system ("rm $result_dir/diag_size");
     									system ("rm $result_dir/tmp"); 
    									if ($split[4] <= $filesize2)
    									{
      									system ("cp -r /var/opt/hp93000/soc_common/calibration $result_dir/Tester_HW/var 2>$FILENAME100");
      									  if (-z "$FILENAME100")
     	 								  {
     									   print "SAVING: /var/opt/hp93000/soc_common/calibration saved to $result_dir/Tester_HW/var\n";
    	  								    open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
        									 print FILEWRITE "consul_tool/Tester_HW/var/calibration\n";
      										close FILEWRITE;
									  }
      									  else
     				 					  {
     									  print "##############################################\n";
      									  print "WARNING: No file in /var/opt/hp93000/soc_common/calibration \n";
      									  print "##############################################\n";
        								  open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
          				 				  print FILEWRITE "/var/opt/hp93000/soc_common/calibration not saved because no content\n";
        								  close FILEWRITE;
     									  } 
     	 								system ("rm $FILENAME100");
									}
    									else
    									{
     	 								$window1 = new Gtk::Window( "toplevel" );
									$window1->signal_connect( "delete_event", sub { $window1->hide(); } );
									$window1->title( "File too big" );
									$window1->border_width( 20 );

									$table = new Gtk::Table( 2, 2, $true );
									$window1->add( $table );
	
									$label = new Gtk::Label( "File size = $split[4], Do you want to Save Calibration?");
									$table->attach_defaults( $label, 0, 2, 0, 1 );
  									$label->show();
		
									$button = new Gtk::Button( "yes" );
									$button->signal_connect( "clicked", \&yes1);

									# Insert button 1 into the upper left quadrant of the table
									$table->attach_defaults( $button, 0, 1, 1, 2);
									$button->show();

									#Create second button
									$button = new Gtk::Button( "no" );
									$button->signal_connect( "clicked", \&no1 );

									# Insert button 2 into the upper right quadrant of the table
									$table->attach_defaults( $button, 1, 2, 1, 2);
									$button->show();
									$table->show();
									$window1->show();
   				 					}
   						}, "button 2" );

		# Insert button 2 into the upper right quadrant of the table
		$table2->attach_defaults( $button2, 1, 2, 1, 2 );
		$button2->show();

		$table2->show();
		$window2->show();

    }
    
    system ("cp -r /etc/opt/hp93000/soc_common $result_dir/Tester_HW/etc 2>$FILENAME100");
    if (-z "$FILENAME100")
    {
    print "SAVING: /etc/opt/hp93000/soc_common saved to $result_dir/Tester_HW/etc\n";
      open (FILEWRITE, ">> $FILENAME102") || warn "file: $FILENAME102 did not open for error reporting";
         print FILEWRITE "consul_tool/Tester_HW/etc/soc_common\n";
      close FILEWRITE;
    }
    else
    {
    print "##############################################\n";
    print "WARNING: No file in /etc/opt/hp93000/soc_common \n";
    print "##############################################\n";
      open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
         print FILEWRITE "/etc/opt/hp93000/soc_common not saved because no content\n";
      close FILEWRITE;
    } 
    system ("rm $FILENAME100");
    system ("chmod -R 777 $result_dir/Tester_HW/etc");
    system ("chmod -R 777 $result_dir/Tester_HW/var");   
  }

sub tar
{
my $window5;
    ################Tar Everything and Clean up###########
    system ("tar cvzf /tmp/$workstation-$date.tar.gz $result_dir 2>/tmp/tar_error ");
         
	 system ("grep -a directory /tmp/tar_error >$FILENAME100");
	 system ("rm /tmp/tar_error");
	 if (-z "$FILENAME100")
    	{
    	    	print "TAR: $result_dir/$workstation-$date.tar.gz was created Successfully\n";
    	    	system ("rm -r $result_dir") ||warn "TAR: $result_dir has been Removed Succesfully";    
    		system ("ls -al /tmp/ >/tmp/sending");
    		system ("grep -a $workstation-$date /tmp/sending > /tmp/diag_size");
      		open (FILEREAD, "< /tmp/diag_size") || warn "file: /tmp/diag_size could not open";
       		chomp(my $split = <FILEREAD>);
       		 my @split = split (/\s+/, $split);
      		close FILEREAD;
    		system ("rm /tmp/diag_size");
  		  system ("rm /tmp/sending"); 


  		  $window5 = new Gtk::Window( "toplevel" );
  		  $window5->signal_connect( "delete_event", sub { $window5->hide(); } );
   		 $window5->title( "Sending file" );
   		 $window5->border_width( 20 );

    		$table = new Gtk::Table( 2, 2, $true );
   		 $window5->add( $table );
	
    		$label = new Gtk::Label( "$workstation-$date.tar.gz = $split[4] bytes Are you ready to send?");
   		 $table->attach_defaults( $label, 0, 2, 0, 1 );
   		 $label->show();
		
   		 $button = new Gtk::Button( "yes" );
   		 $button->signal_connect( "clicked", sub {
    			   $window5->hide();
			   my $newerr;
			   my $ftpobj = Net::FTP -> new ("$ftp_server", Debug=>0 );
			   $ftpobj -> login("$ftp_username","$ftp_password");
			   $ftpobj -> put ("/tmp/$workstation-$date.tar.gz", "/tmp/$workstation-$date.tar.gz") or $newerr = 1;
				     print "Can't Send File, Please Check to see if ftp is working.\n" if $newerr;
     					print "FILE SENT!!\n" if !$newerr;
			   $ftpobj -> close;
			   
			   });

    		# Insert button 1 into the upper left quadrant of the table
   		 $table->attach_defaults( $button, 0, 1, 1, 2);
   		 $button->show();

    		#Create second button
   		 $button = new Gtk::Button( "no" );
   		 $button->signal_connect( "clicked", sub {
    				print "\n\nFile not Sent!!!\n\n";
    			        $window5->hide();
			   } );

    		# Insert button 2 into the upper right quadrant of the table
    		$table->attach_defaults( $button, 1, 2, 1, 2);
    		$button->show();
    		$table->show();
    		$window5->show();
    
	}
   	else
    	{
	print "TAR: No information to send.  Try using 'Save' button first\n";
	}
	system ("rm $FILENAME100");
    
}

############New window for Help file##########
sub help
{
my $window3;
my $text1;
my $table1;
my $vscrollbar1;


$window3 = new Gtk::Window( 'toplevel' );
$window3->set_usize( 450, 400 );
$window3->set_policy( $true, $true, $false );
$window3->signal_connect( 'destroy', sub { $window3->hide();
					$numclicked = "0";
					 } );
$window3->set_title( "help.txt" );
$window3->border_width( 0 );

my $main_vbox = new Gtk::VBox( $false, 0 );
$window3->add( $main_vbox );
$main_vbox->show();

my $vbox = new Gtk::VBox( $false, 10 );
$vbox->border_width( 10 );
$main_vbox->pack_start( $vbox, $true, $true, 0 );
$vbox->show();

$table1 = new Gtk::Table( 2, 2, $false );
$table1->set_row_spacing( 0, 2 );
$table1->set_col_spacing( 0, 2 );
$vbox->pack_start( $table1, $true, $true, 0 );
$table1->show();

# Create the GtkText widget
$text1 = new Gtk::Text( undef, undef );
$text1->set_editable( $true );
$table1->attach( $text1, 0, 1, 0, 1,
		[ 'expand', 'shrink', 'fill' ],
		[ 'expand', 'shrink', 'fill' ],
		0, 0 );
$text1->show();

# Add a vertical scrollbar to the GtkText widget
$vscrollbar1 = new Gtk::VScrollbar( $text1->vadj );
$table1->attach( $vscrollbar1, 1, 2, 0, 1, 'fill',
		[ 'expand', 'shrink', 'fill' ], 0, 0 );
$vscrollbar1->show();
$text1->freeze();
open( FILE, "/var/opt/help.txt" );
my $fixed_font;
foreach $line ( <FILE> )
  {
    $text1->insert( $fixed_font, undef, undef, $line );
  }
    
close( FILE );
$text1->thaw();
if ($numclicked == 1)
{
$window3->hide();
}
if ($numclicked == 0)
{
$window3->show();
$numclicked++;
}

}
###########New window for selecting file########
sub file_select
{
my $file_dialog = new Gtk::FileSelection( "File Selection" );
$file_dialog->signal_connect( "destroy", sub { $file_dialog->hide();
						$numclicked1 = "0";
						 } );

# Connect the ok_button to file_ok_sel function
$file_dialog->ok_button->signal_connect( "clicked",
					 sub { $file = $file_dialog->get_filename();   my $chr = chop($file); $file_dialog->hide();
					 my @ARRAY = split('/', $file);
					$device = $ARRAY[$#ARRAY];
					     $entry = new Gtk::Entry( 50 );
    					     $entry->set_text($file);
					     $table->attach_defaults( $entry, 1, 4, 11, 12 );
    					     $entry->show();
					     $numclicked1 = "0";
					     } );
					     
           
# Connect the cancel_button to destroy the widget
$file_dialog->cancel_button->signal_connect( "clicked",
					     sub { $file_dialog->hide(); $numclicked1 = "0";} );
           
$file_dialog->hide_fileop_buttons(); 
if ($numclicked1 == 1)
{
$file_dialog->hide();
}
if ($numclicked1 == 0)
{          
$file_dialog->show();
$numclicked1++;
}
main Gtk;
exit( 0 );

# Get the selected filename and print it to the console
sub testprog
  {
 
    my @test1;
    my @config;
    my $config1; 
    my $data;
    $testflow_testprog = "Testprogram Selected";
my $FILENAME10 = "$result_dir/test"; 
my $FILENAME11 = "$result_dir/prog_list";
	$entry = new Gtk::Entry( 20 );
    	$entry->set_text($testflow_testprog);
   	$table->attach_defaults( $entry, 0, 1, 14, 15 );
   	$entry->show();
   ########Testprogram list creation
   system ("ls $file/testprog/ > $result_dir/test 2>$FILENAME100");
   if (-s "$FILENAME100")
     	 {
	 	 print "*******************************************\n";
     		 print "Change 'Select Device Folder' path\n";
		 print "*******************************************\n";
		 my @split = "";
		 my $combo = new Gtk::Combo();
	$combo->set_popdown_strings( @split );
	$combo->entry->set_text( "Change 'Select Device Folder'" );
	$combo->entry->signal_connect( "changed", sub {});
	$table->attach_defaults( $combo, 2, 4, 13, 14 );
	$combo->show();
	
	my $blank = "";     
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 15, 16 );
    $entry->show();

    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 16, 17 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 17, 18 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 18, 19 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 19, 20 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 20, 21 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 21, 22 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 22, 23 );
    $entry->show(); 
    
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 23, 24 );
    $entry->show();
	 }
      	else
     	 {

     	 
   open (FILEREAD, "< $FILENAME10") || warn "file $FILENAME10 did not open $!";
   open (FILEWRITE, "> $FILENAME11") || warn "file $FILENAME11  did not open $!";	
	while (chomp (my $test =<FILEREAD>))
		{
   		@test1 = split /\s+/, $test;
		my $data2 = "$test1[0] ;";
		print FILEWRITE "$data2";
		}
	close FILEREAD;
	close FILEWRITE;

   open (FILEREAD, "< $FILENAME11") || die "not working";
   	my $split = <FILEREAD>;
        my @split = split (/;/, $split);
   close FILEREAD;
   system ("rm $result_dir/prog_list");
my $FILENAME8 = "$result_dir/testflow";	

	my $combo = new Gtk::Combo();
	$combo->set_popdown_strings( @split );
	$combo->entry->set_text( "Choose a Testprogram" );
	$combo->entry->signal_connect( "changed", 
	sub {
		my $entry3 = $combo->entry;
		$prog = $entry3->get_text;
		system ("grep -a Testflow $file/testprog/$prog > $FILENAME10");
		open(FILEREAD, "< $FILENAME10") || warn "file: $FILENAME10 did not open $!";
   	 	my $test = <FILEREAD>;
	  	my @test1 = split /\s+/, $test;
    		close FILEREAD; 
		system ("grep context_ $file/testflow/$test1[1] > $FILENAME8");

my $FILENAME9 = "$result_dir/split";
   
   		open(FILEREAD, "< $FILENAME8") || warn "file: $FILENAME8 did not open $!";
   		open (FILEWRITE, "> $FILENAME9");		
   			while (chomp (my $config1 =<FILEREAD>))
			{
   			@config = split /\s+/, $config1;
   			$data = $config[2];
			####deletes quotation marks
			####code from http://perl.active-venture.com/pod/perlfaq4-datastrings.html
		    	push(@config, $+) while $data =~ m{
        	    	"([^\"\\]*(?:\\.[^\"\\]*)*)",?  # groups the phrase inside the quotes
                    	| ([^,]+),?
                    	| ,
                    		}gx;
     
     		    	 push(@config, undef) if substr($data,-1,1) eq ',';
   			###### add the quotation mark in so there's something to seperate later
   			my $data1 = "$config[3] $config[4]";
   			print FILEWRITE "$data1";
   			}
   		close FILEREAD;
   		close FILEWRITE;
   
   		open (FILEREAD, "< $FILENAME9") || die "not working";
   		my $file1 = <FILEREAD>;
   		my @split = split (/;/, $file1);
	  	$pin = $split[0];
		$levels = $split [1];
		$timing = $split [2];
		$vector = $split [3];
		$attrib = $split [4];
		$analog = $split [5];
   		$waveform = $split [6];
   		$routing = $split [7];
   		close FILEREAD;
system ("rm $result_dir/split");
system ("rm $result_dir/testflow");
system ("rm $result_dir/test");
###Fill all the gathered info from user program 
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($pin);
    $table->attach_defaults( $entry, 1, 4, 16, 17 );
    $entry->show();

    $entry = new Gtk::Entry( 20 );
    $entry->set_text($levels);
    $table->attach_defaults( $entry, 1, 4, 17, 18 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($timing);
    $table->attach_defaults( $entry, 1, 4, 18, 19 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($vector);
    $table->attach_defaults( $entry, 1, 4, 19, 20 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($attrib);
    $table->attach_defaults( $entry, 1, 4, 20, 21 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($analog);
    $table->attach_defaults( $entry, 1, 4, 21, 22 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($waveform);
    $table->attach_defaults( $entry, 1, 4, 22, 23 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($routing);
    $table->attach_defaults( $entry, 1, 4, 23, 24 );
    $entry->show(); 
$current = $test1[1];
		
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($current);
    $table->attach_defaults( $entry, 1, 4, 15, 16 );
    $entry->show();	
		});
	
	$table->attach_defaults( $combo, 2, 4, 13, 14 );
	$combo->show();
	}
	system ("rm $FILENAME100");
	}
#######################Testflow area#####################
sub testflow
  {
   my @test1;
   my @config;
   my $config1; 
   my $data;
   $testflow_testprog = "Testflow Selected";
   my $FILENAME12 = "$result_dir/test1";
   my $FILENAME13 = "$result_dir/test_list";
   	$entry = new Gtk::Entry( 20 );
    	$entry->set_text($testflow_testprog);
   	$table->attach_defaults( $entry, 0, 1, 14, 15 );
   	$entry->show();
   system ("ls $file/testflow/ > $result_dir/test1 2>$FILENAME100");
   if (-s "$FILENAME100")
     	 {
	 	 print "*******************************************\n";
     		 print "Change 'Select Device Folder' path\n";
		 print "*******************************************\n";
		my @split = "";
		my $combo = new Gtk::Combo();
	$combo->set_popdown_strings( @split );
	$combo->entry->set_text( "Change 'Select Device Folder'" );
	$combo->entry->signal_connect( "changed", sub {});
	$table->attach_defaults( $combo, 2, 4, 13, 14 );
	$combo->show();
    	
my $blank = "";     
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 16, 17 );
    $entry->show();

    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 17, 18 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 18, 19 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 19, 20 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 20, 21 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 21, 22 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 22, 23 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 23, 24 );
    $entry->show(); 
        
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($blank);
    $table->attach_defaults( $entry, 1, 4, 15, 16 );
    $entry->show();
	  }
      	else
     	 {
   open (FILEREAD, "<$FILENAME12") || warn "file $FILENAME12 did not open $!";
   open (FILEWRITE, "> $FILENAME13") || warn "file $FILENAME13  did not open $!";	
	while (chomp (my $test =<FILEREAD>))
		{
   		@test1 = split /\s+/, $test;
		my $data2 = "$test1[0] ;";
		print FILEWRITE "$data2";
		}
	close FILEREAD;
	close FILEWRITE;

   open (FILEREAD, "< $FILENAME13") || die "not working";
   	my $split = <FILEREAD>;
        my @testflow_folder = split (/;/, $split);

   close FILEREAD;
my $FILENAME15 = "$result_dir/testflow1";	

	my $combo = new Gtk::Combo();
	$combo->set_popdown_strings( @testflow_folder );
	$combo->entry->set_text( "Choose a Testflow" );
	$combo->entry->signal_connect( "changed", 
	sub {
		my $entry4 = $combo->entry;
		$prog1 = $entry4->get_text;
		system ("grep context_ $file/testflow/$prog1 > $FILENAME15");
		 	
my $FILENAME14 = "$result_dir/split1";

   		open(FILEREAD, "< $FILENAME15") || warn "file: $FILENAME15 did not open $!";
   		open (FILEWRITE, "> $FILENAME14");		
   			while (chomp (my $config1 =<FILEREAD>))
			{
   			@config = split /\s+/, $config1;
   			$data = $config[2];
			####deletes quotation marks
			####code from http://perl.active-venture.com/pod/perlfaq4-datastrings.html
		    	push(@config, $+) while $data =~ m{
        	    	"([^\"\\]*(?:\\.[^\"\\]*)*)",?  # groups the phrase inside the quotes
                    	| ([^,]+),?
                    	| ,
                    		}gx;
     
     		    	 push(@config, undef) if substr($data,-1,1) eq ',';
   			###### add the quotation mark in so there's something to seperate later
   			my $data1 = "$config[3] $config[4]";
   			print FILEWRITE "$data1";
   			}
   		close FILEREAD;
   		close FILEWRITE;
   
   		open (FILEREAD, "< $FILENAME14") || die "not working";
   		my $file = <FILEREAD>;
   		my @split = split (/;/, $file);
	  	$pin = $split[0];
		$levels = $split [1];
		$timing = $split [2];
		$vector = $split [3];
		$attrib = $split [4];
		$analog = $split [5];
   		$waveform = $split [6];
   		$routing = $split [7];
   		close FILEREAD;
system ("rm $result_dir/split1");
system ("rm $result_dir/testflow1");

###Fill all the gathered info from user program 
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($pin);
    $table->attach_defaults( $entry, 1, 4, 16, 17 );
    $entry->show();

    $entry = new Gtk::Entry( 20 );
    $entry->set_text($levels);
    $table->attach_defaults( $entry, 1, 4, 17, 18 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($timing);
    $table->attach_defaults( $entry, 1, 4, 18, 19 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($vector);
    $table->attach_defaults( $entry, 1, 4, 19, 20 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($attrib);
    $table->attach_defaults( $entry, 1, 4, 20, 21 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($analog);
    $table->attach_defaults( $entry, 1, 4, 21, 22 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($waveform);
    $table->attach_defaults( $entry, 1, 4, 22, 23 );
    $entry->show();
  
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($routing);
    $table->attach_defaults( $entry, 1, 4, 23, 24 );
    $entry->show(); 
	
$current = $prog1;
    $entry = new Gtk::Entry( 20 );
    $entry->set_text($current);
    $table->attach_defaults( $entry, 1, 4, 15, 16 );
    $entry->show();
   	
		});
system ("rm $result_dir/test_list");
system ("rm $result_dir/test1");

	$table->attach_defaults( $combo, 2, 4, 13, 14 );
	$combo->show();
    }
    }
    system ("rm $FILENAME100");
    }
sub yes1
 {
   system ("cp -r /var/opt/hp93000/soc_common/calibration $result_dir/Tester_HW/var 2>$FILENAME100");
      	if (-z "$FILENAME100")
     	 {
     		 print "SAVING: /var/opt/hp93000/soc_common/calibration saved to $result_dir/Tester_HW/var\n"
    	  }
      	else
     	 {
     		print "##############################################\n";
      		print "WARNING: No file in /var/opt/hp93000/soc_common/calibration \n";
      		print "##############################################\n";
        	open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
          	 print FILEWRITE "/var/opt/hp93000/soc_common/calibration not saved because no content\n";
        	close FILEWRITE;
     	 } 
     	 system ("rm $FILENAME100");
    $window1->hide();
  }
sub no1
  {
     open (FILEWRITE, ">> $FILENAME101") || warn "file: $FILENAME101 did not open for error reporting";
          	print FILEWRITE "/var/opt/hp93000/soc_common/calibration not saved because no content\n";
     close FILEWRITE;
     $window1->hide();
   }
