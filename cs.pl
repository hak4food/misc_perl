#!/usr/bin/env perl 
use warnings;
use strict;

&usage unless ( @ARGV == 2 );

sub usage {
    print "\n
$0   v1.2   for 93000 SOC tester

Purpose:
   Fix checksum errors in 93k timing or level file.
   This allows you to edit the wavetable, clock set, equation set, and specs
   in a text editor, fix the file, and then load it into SmarTest

Usage example:
   $0  example_timing  example_timing.fixed

Example input file:
    EQSP TIM,WVT,#9000001234
    EQSP TIM,EQN,#9000002345
    EQSP TIM,SPS,#9000003456

Example output file:
    EQSP TIM,WVT,#9000008248
    EQSP TIM,EQN,#9000002046
    EQSP TIM,SPS,#9000002648
    
";
    exit;
}

print "\n\n";
print "##################################\n";
print "#  timing_level_fix_checksum.pl  #\n";
print "##################################\n\n";

open( "INFILE", "< $ARGV[0]" )
  or die "ERROR: Cannot open file for reading:  $ARGV[0]\n\n";
open( "OUTFILE", "> $ARGV[1]" )
  or die "ERROR: Cannot open file for writing:  $ARGV[1]\n\n";
print "Reading from input file: $ARGV[0]\n";
print "Writing to output file: $ARGV[1]\n";

my $in_wvt         = 0;
my $in_eqn         = 0;
my $in_sps         = 0;
my $in_clk         = 0;
my $wvt_str        = "";
my $eqn_str        = "";
my $sps_str        = "";
my $clk_str        = "";
my $clockset_found = 0;

my $filetype;
$_ = <INFILE>;
if (/,level,/) {
    $filetype = "LEV";
}
elsif (/,timing,/) {
    $filetype = "TIM";
}
else {
    print "First line of input file $ARGV[0] not recognized as a valid 93k timing or level file: $_\n";
    print "Exiting.\n\n";
    exit;
}
print OUTFILE;

while (<INFILE>) {
    if (/^@/) {
        $in_wvt = 0;
        $in_eqn = 0;
        $in_sps = 0;
        $in_clk = 0;
    }

    $wvt_str .= $_ if ($in_wvt);
    $eqn_str .= $_ if ($in_eqn);
    $sps_str .= $_ if ($in_sps);
    $clk_str .= $_ if ($in_clk);

    if (/EQSP TIM,WVT,#9\d\d\d\d\d\d\d\d\d(.*\n)/) {
        $in_wvt  = 1;
        $wvt_str = $1;
    }
    elsif (/EQSP (LEV|TIM),EQN,#9\d\d\d\d\d\d\d\d\d(.*\n)/) {
        $in_eqn  = 1;
        $eqn_str = $2;
    }
    elsif (/EQSP (LEV|TIM),SPS,#9\d\d\d\d\d\d\d\d\d(.*\n)/) {
        $in_sps  = 1;
        $sps_str = $2;
    }
    elsif (/EQSP TIM,CLK,#9\d\d\d\d\d\d\d\d\d(.*\n)/) {
        $in_clk         = 1;
        $clk_str        = $1;
        $clockset_found = 1;
    }
    if ( !$in_wvt and !$in_eqn and !$in_sps and !$in_clk and !/^@/ ) {
        print OUTFILE $_;
    }
}
if ( $filetype eq "TIM" ) {
    printf OUTFILE "EQSP TIM,WVT,#9%09d%s@\n", length($wvt_str) + 1, $wvt_str;
}
if ($clockset_found) {
    printf OUTFILE "EQSP TIM,CLK,#9%09d%s@\n", length($clk_str) + 1, $clk_str;
}
printf OUTFILE "EQSP $filetype,EQN,#9%09d%s@\n", length($eqn_str) + 1, $eqn_str;
printf OUTFILE "EQSP $filetype,SPS,#9%09d%s@\n", length($sps_str) + 1, $sps_str;

print "To see the changes made, do a:   sdiff -s $ARGV[0] $ARGV[1]\n";
print "Done.\n\n";

__END__


