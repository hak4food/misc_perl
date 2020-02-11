#!/usr/bin/perl


use strict;
use Getopt::Long;


########  defined default variables 

use constant  VERSION => "{0.3 : 26-Jun-09}";  # the version identifier 



######## globals
my $debug=0;
my $help=0;
my $in="";
my $out="";
my $mapping="";
my $ins = $ARGV[1];
my $arg2;
my $pins;
my $is_in_gzipped=0;
my $is_out_gzipped=0;
my $is_mapping=0;
my $line=1;
my %pin_mapping;
my $rpt_converted =0;
my $lines_converted =0;

######## get the program name
my $program =`/bin/basename $0`; chop ($program);

######## Usage
my  $usage= "
 $program: Revision ".VERSION."

 Purpose:
    Converts ATP to AVC (quick and dirty) 

 Assumptions for usage:

 Usage:

    Required parameters: 
    -in  atp_file    (or gzipped atp file)
    -out avc_file    (file will be automatically gzipped if filename contains .gz)
   
    Optional paramaters: 
    -mapping mapping_file   {maps pin names to shorter pin names.  See usage below in Notes}
    -debug  n        (n=1 to 2)  
    
 Example usage:
 
    $program  -in my_atp_file.gz  -out my_avc_file -debug 2 
                                                                                                 

 Notes:
   1. The optional pin mapping file specifies the mapping of an ATP pin name to a 93k pin name.  The syntax of the mapping is: 
        old_name -> new_name   # comment
	# comment 
	
    
 Limitations:
 
    
\n";
  
######### Subroutines
  
sub gunzip { 
	$_ = shift ; 
	&prd("gunzipping $_...",1);
	my $res = system ("/usr/bin/gunzip $_");
	&pre("Cannot gunzip file '$_', does it exist?") unless ($res==0);
	s/\.gz//g;
	return ($_);
}
sub gzip { 
	$_ = shift ; 
	&prd("gzipping $_...",1);
	my $res = system ("/usr/bin/gzip $_");
	&pre("Cannot gzip file '$_', does it exist?") unless ($res==0);

}	
	

sub pre { 
        my $msg =shift;
        die "\n$program: FATAL ERROR: $msg\n";
        
}

sub prd { 
        ###########  prints the debug message.  if level ==0, the program prints a notice (e.g. debug level 0 is a notice)
        my $msg =shift;
        my $dlevel =shift ;
        print "$program: (debug${dlevel}) $msg\n" if ($dlevel <= $debug and $dlevel>0);
        print "$program: notice: $msg\n" if ( $dlevel==0);
        
}
sub check_args { 
      die "\n$program: debug level cannot be <0!" if ($debug<0);
      &prd ("debug level set to $debug",$debug) if ($debug>0);
        	  

      	die "\n$program: missing input atp  (or atp.gz) file.\nSee usage:\n$usage" unless (length($in));
      	die "\n$program: missing output avc (or avc.gz) file.\nSee usage:\n$usage" unless (length($out));
      	&prd ("missing mapping file.  No pin mapping will be performed!",0) unless (length($mapping));
	$is_mapping =1 if (length($mapping));
	
	if ($in=~/\.gz/) { 
		$is_in_gzipped=1 ; 
		&prd("input file is gzipped",1);
	}
	if ($out=~/\.gz/) { 
		$is_out_gzipped=1 ; 
		&prd("output file is gzipped",1);
		$_=$out;
		s/\.gz//g;
		$out=$_;
	}
 
	
}


sub get_envinfo { 
      my $whome = $ENV{'USER'} ; 
      my $hostname = `/bin/hostname`; chop($hostname);
      my $t_stamp = `/bin/date`;	  chop ($t_stamp);
      print "\n$program :: Version: ",VERSION," started on '$hostname' by user '$whome' at '$t_stamp'" , "\n" x 2;
        
}

sub parse_mapping_file { 

	
        while (<MAPPING>) { 
              next if (/^#/);
	      next if (/^$/);
	      s/#.*//g;
               if (/(\S+)\s*->\s*(\S+)/) { 
        	       &prd ("processed mapping of '$1' to '$2'", 2);  
		       $pin_mapping{$1}=$2;
               }
        }
	close (MAPPING);  
	
	
}

	
sub parse_pin_group { 
	$_=shift; 
	my $orig= $_;
	&prd("parsing pin or group: '$_'" ,2); 

	if ($is_mapping) { 
		foreach my $key (keys (%pin_mapping)) { 
			if (/$key/) { 
				s/$key/$pin_mapping{$key}/g;
				&prd("applying '$key' mapping to change pin/group '$orig' to '$_'",1);
			}
		}
	}
	
	my $length = length($_); 
	&pre("The length of the pin or group '$orig' was shortened to '$_', however, it's still > 16 characters!") if ($length > 16 and ($orig ne $_)) ;
	&pre("The length of the pin or group '$orig' is > 16 characters!  Consider the mapping file option.") if ($length > 16) ;
	return ($_);
	
}


sub aic{

#$ins=s/\.atp//g;
my @tmp = split(/.atp/,$ins);
print "Creating AIC $tmp[0].aic\n";
$ins =$tmp[0];
open(WRITE, "> $ins.aic");
print WRITE "AI_DIR_FILE\n";
print WRITE "tmp_dir				./\n";
print WRITE "tmf_dir				./\n";
print WRITE "vbc_dir				./\n";
print WRITE "avc_dir				./\n";
print WRITE "pinconfig_file			./2049_x8.pin\n";
print WRITE "single_binary_pattern_dir		./\n";
print WRITE "\n";
print WRITE "AI_V2B_OPTIONS  -CELAT\n";
print WRITE "\n";
print WRITE "PATTERNS\n";
print WRITE "name        type  ctim xfact timing_map_file    hp_wf          hp_eq {  vec_ascii_dvc  ascii_dvc  hp_ts };\n";
print WRITE "$ins  MAIN  NCT    1  $ins.01.tmf  \"wavetable 1\"   1    {  $arg2          $arg2       1    };\n";
print WRITE "\n";
print WRITE "\n";
print WRITE "\n";
print WRITE "GROUPS   # type ctim name { elements };\n";


print WRITE "WAVETBL \"wavetable 1\"\n";
print WRITE "  EQNSET 1 \"equation set 1\"\n";
print WRITE "    period_res = 10\n";
print WRITE "    TIMINGSET 1 \"eq 1 ts 1\"\n";
print WRITE "      xfact = 1\n";
print WRITE "      period = 10\n";
print WRITE "      DVC $arg2;\n";

close WRITE;


}

sub dvc{

print "Creating DVC $ins.dvc\n";
open(WRITE, "> $ins.dvc");
print WRITE "DVC $arg2\n";
print WRITE "period = 10\n";

print WRITE "PINS $pins\n";
print WRITE "1 1:0\n";
print WRITE "0 0:0\n";
print WRITE "Z Z:0\n";
print WRITE "L FNZ:0 W0:8 WC:10\n";
print WRITE "H FNZ:0 W1:8 WC:10\n";
print WRITE "M FNZ:0 WM:8 WC:10\n";
print WRITE "X FNZ:0 EX:8\n";
print WRITE "\n";
close WRITE;

}

sub translate{
system("ait -FPxZ -Mw -c $ins.aic -b $ins");
system("aiv -z MCU -c $ins.aiv -Ia");


} 
##################################################################### MAIN #############################################################################

$ins = @ARGV[1];
print "Converting dos2unix\n";
system("dos2unix $ins");
my $help;
&get_envinfo();
Getopt::Long::GetOptions( 'debug=i'             => \$debug ,
			  'in=s', 		=> \$in ,
			  'mapping=s', 		=> \$mapping ,
			  'help'                => \$help, 
			  'out=s', 		=> \$out);


die "\nPrinting help:\n\n$usage\n" if ($help);
undef $help;

&check_args();

$in = &gunzip($in) if ($is_in_gzipped);

&pre("Cannot open file $in for reading!") unless (open (IN, "< $in")) ; 
&pre("Cannot open file $in for writing!") unless (open (OUT, "> $out")) ; 
if ($is_mapping ) { 
	&pre("Cannot open file $mapping for reading!") unless (open (MAPPING, "< $mapping")) ; 
	&parse_mapping_file();
}

&prd("now processing ATP file...",0);

while (<IN>) { 
	chop;
	s/halt//g;
	if (/^\/\/(.*)/ ) { 
		print OUT "# $1 \n";
		$line++;
		next;
	}
	if (/^import(.*)/ ) { 
		print OUT "# import $1 \n";
		$arg2 = $1;
                my @tmp = split(/\s/,$arg2);
		$tmp[2] =~ s/;//g;
		$arg2 = $tmp[2];
		
		$line++;
		next;
	}
	if (/^vm_vector/) { 
		#$_=$1;
		s/vm_vector//g;
		s/\$tset//g;
		s/\(//g;
		s/\)//g;
		s/\s//g;
		s/\:S//g;
		print OUT "FORMAT  "; 
		foreach my $token (split(/,/,$_)) { 
			my $entry = &parse_pin_group ($token); 
			$pins=+$pins.$entry." ";
			print OUT "$entry ";
			
		}
		print OUT " ;\n";
		$line++;
		next;
		
	}
	if (/^repeat\s\d+\s*>\s*(\S+)\s+(.*);/) {
	        my @tmp =split(/\s+/,);
		my $rpt = $tmp[1]; 
		my $devcyc = $1;
		my $data = $2; 
		my $comment;
		$comment = $1 if (/\/\/(.*)/) ; 
		chomp($comment);
		my $print_line = sprintf("R%d\t%s\t%s ; %s\n" ,$rpt, $devcyc, $data, $comment);
		print OUT "$print_line";
		$line++;
		$lines_converted++;
		$rpt_converted++;
		next;
	}
	if (/^\s*>\s*(\S+)\s+(.*);/) {
		my $devcyc = $1;
		my $data = $2; 
		my $comment;
		chomp($comment);
		$comment = $1 if (/\/\/(.*)/) ; 
		my $print_line = sprintf("R%d\t%s\t%s ; %s\n" ,1, $devcyc, $data ,$comment);
		print OUT "$print_line";
		$line++;
		$lines_converted++;
		
		next;
	}
	
	$line++;

}
close (IN);
close (OUT);
&gzip($out) if ($is_out_gzipped) ; 
print "$program: SUMMARY:\n";
print "\t$line lines of ATP file '$in' were read.\n";
print "\t$lines_converted ATP lines converted (of which $rpt_converted lines contained single-line repeats).\n";
print "$program: DONE!  wrote avc file: $out" , $is_out_gzipped   ? ".gz" : "" , "\n";
print "DOES NOT SUPPORT RZ or NRZ CLOCKS!!!!!!!!!!!!!!!!!!!!!\n";

&aic;
&dvc;
&translate;
exit(0);


