#!/usr/bin/perl 
my $i=0;
my $total_time;

$file= $ARGV[0];
open(READ, "< $file");
$line = <READ>;
print "$line";
$line = <READ>;
print "$line";
$line = <READ>;
print "$line";
$line = <READ>;
print "$line";
$line = <READ>;
print "$line";
$line = <READ>;
print "$line";
$line = <READ>;;
 while(my $line = <READ>)
 {
   @arrary[$i] = $line;
   $i++;
 }

foreach(@arrary){

 if($_ =~ /A\s+/){
   $array_a .= $_;
 }
 elsif($_ =~ /_B\s+/){
   $array_b .= $_;
 }
 elsif($_ =~ /_C\s+/){
   $array_c .= $_;
 }
 elsif($_ =~ /_D\s+/){
   $array_d .= $_;
 }
 elsif($_ =~ /_E\s+/){
   $array_e .= $_;
 }
 elsif($_ =~ /_F\s+/){
   $array_f .= $_;
 }
 elsif($_ =~ /_G\s+/){
   $array_g .= $_;
 }
 elsif($_ =~ /_H\s+/){
   $array_h .= $_;
 }
 elsif($_ =~ /_I\s+/){
   $array_i .= $_;
 }
 elsif($_ =~ /_J\s+/){
   $array_j .= $_;
 }
 elsif($_ =~ /_H\s+/){
   $array_h .= $_;
 }
 elsif($_ =~ /_K\s+/){
   $array_k .= $_;
 } 
 elsif($_ =~ /_L\s+/){
   $array_l .= $_;
 }
 elsif($_ =~ /_M\s+/){
   $array_m .= $_;
 }
 elsif($_ =~ /_N\s+/){
   $array_n .= $_;
 }
 elsif($_ =~ /_P\s+/){
   $array_p .= $_;
 }
 elsif($_ =~ /_Q\s+/){
   $array_q .= $_;
 } 
 elsif($_ =~ /_R\s+/){
   $array_r .= $_;
 } 
 elsif($_ =~ /_S\s+/){
   $array_s .= $_;
 } 
 elsif($_ =~ /_T\s+/){
   $array_t .= $_;
 } 
 elsif($_ =~ /_U\s+/){
   $array_u .= $_;
 } 
 elsif($_ =~ /_V\s+/){
   $array_v .= $_;
 } 
 elsif($_ =~ /_W\s+/){
   $array_w .= $_;
 } 
 elsif($_ =~ /_X\s+/){
   $array_x .= $_;
 } 
 elsif($_ =~ /_Y\s+/){
   $array_y .= $_;
 }
 elsif($_ =~ /_Z\s+/){
   $array_z .= $_;
 }
 elsif($_ =~ /Total avg testsuite/){
   $array .= $_;
   $total_time= $_;
   @new = split(/\s+/,$total_time);
   $total_time= $new[5];
 }
 else{ $array .= $_;}

}

 
sub sum{
        
    my $blockpercent=0;
    my $running =0;
    my $tt =0;
    my $percent =0;
    $nu = shift;
    $sze = length($nu);
    if($sze != 0){
     print "\n*************************************************************\n";
     @tmp = split(/\n/,$nu);
     $sz=@tmp;
     
     for(my $idx =0;$sz>$idx;$idx++){
       chomp($tmp[$idx]);
       print $tmp[$idx];
       @tmp2=split(/\s+/, $tmp[$idx]);
       $tt = $tmp2[2]; 
       $running+=$tmp2[2];
       
       $percent = ($tt/$total_time);
       $percent=$percent*100;
       $percent = sprintf("%.3f", $percent);
       print "\t$percent%\n";
     }
     $blockpercent = ($running/$total_time);
     $blockpercent = $blockpercent*100;
     $blockpercent = sprintf("%.3f", $blockpercent);
     print "Block Total:                          $running          $blockpercent%\n";
    }  
}

&sum($array_a);
&sum($array_b);
&sum($array_c);
&sum($array_d);
&sum($array_e);
&sum($array_f);
&sum($array_g);
&sum($array_h);
&sum($array_i);
&sum($array_j);
&sum($array_k);
&sum($array_l);
&sum($array_m);
&sum($array_n);
&sum($array_o);
&sum($array_p);
&sum($array_q);
&sum($array_r);
&sum($array_s);
&sum($array_t);
&sum($array_u);
&sum($array_v);
&sum($array_w);
&sum($array_x);
&sum($array_y);
&sum($array_z);

print "\n******************************************************\n";
print $array;
