#!/cygwin/c/Strawberry/perl/bin/perl  
use Math::Complex;
use Spreadsheet::WriteExcel;
use Spreadsheet::WriteExcel::Utility;


# Program to classify records MTBC genotypes and set of expert rules into Spoldb4 subfamilies.

if (!defined $ARGV[2]) {
    print "usage $0 <test file> <biomarker> <date>";}

open (MODEL, "<mKTU") or die " Couldn't open model";
open (DATAFILE, "<$ARGV[0]") or die " Couldn't open $ARGV[0]";


   $loneSp = 0;
   $SM12 = 0;
   $SM24 = 0;
   $M12 = 0;
   $M24 = 0;
   $bioM = $ARGV[1];
   if ($bioM eq "Spoligo"){$loneSp = 1;}
   else {
         if ($bioM eq "Spoligo12"){$SM12 = 1;}
         else {
                if ($bioM eq "MIRU12"){$M12 = 1;}
                else{
                     if ($bioM eq "MIRU24"){$M24 = 1;}
                     else{
                          if ($bioM eq "Spoligo24"){$SM24 = 1;}
                          else{$result = sprintf ("N/A option \n"); exit;}
                     } 
                }
         } 
   }
    my $thetime = $ARGV[2];
    my $workbook  = Spreadsheet::WriteExcel->new("Results$thetime.xls");
    my $worksheet = $workbook->compatibility_mode();  
    my $worksheet = $workbook->add_worksheet();

    my $bold = $workbook->add_format();
    $bold-> set_bold();
    $bold-> set_align('center');
    my $center = $workbook->add_format();
    $center-> set_align('center');
    my $general = $workbook->add_format();
    $general->set_num_format(sprintf '"%s"');
    my $number1 = $workbook->add_format();
    $number1->set_num_format();
    my $number2 = $workbook->add_format();
    $number2->set_num_format('0.00');
    $number2->set_align('center');
    my $xi=0;
   $t = 0;
   $M1 = <MODEL>;
   chomp($M1);
   $N = <MODEL>;
   chomp($N);

   $c = <MODEL>;
   chomp($c);
   $cR = <MODEL>;
   chomp($cR);

   for($m=0; $m < $c; $m++)
      {
           $ln = <MODEL>;
           chomp($ln);
           ($k, $v) = split (' ',$ln);
           $ind{$k}= $v;         
      }

   $a = <MODEL>;
   chomp($a);
   for($i=0; $i < $a; $i++){
        $ln = <MODEL>;
        chomp($ln);
        $array[$i] = $ln;
   }
   for($m=0; $m < $cR; $m++)
      {
           $ln = <MODEL>;
           chomp($ln);
           ($k, $v) = split (' ',$ln);
           $rul{$k}= $v; 
      }
   $a = <MODEL>;
   chomp($a);
   for($i=0; $i < $a; $i++){
        $ln = <MODEL>;
        chomp($ln);
        $arrayR[$i] = $ln;
   }
      foreach $m (keys(%rul))
      {
        $SumRC[$rul{$m}] = 0;
      }
      foreach $m (keys(%rul))
      {
        foreach $n (keys(%ind))
        { 
           $ln = <MODEL>;
           chomp($ln);
           ($m, $n, $d) = split (' ',$ln);
           $arrayRC[$rul{$m}][$ind{$n}]= $d;
           $SumRC[$rul{$m}] = $SumRC[$rul{$m}] + $d;
        
        }
      }       

   for($j = 0; $j < $M1-2; $j++)
   { 
    $t_index[$j]{0}=-1;    $t_index[$j]{a}=-1;
    $t_index[$j]{1}=-1;    $t_index[$j]{r}=-1;
    $t_index[$j]{2}=-1;    $t_index[$j]{s}=-1;
    $t_index[$j]{3}=-1;    $t_index[$j]{t}=-1;
    $t_index[$j]{4}=-1;    $t_index[$j]{u}=-1;
    $t_index[$j]{5}=-1;    $t_index[$j]{v}=-1;
    $t_index[$j]{6}=-1;    $t_index[$j]{w}=-1;
    $t_index[$j]{7}=-1;    $t_index[$j]{x}=-1;
    $t_index[$j]{8}=-1;    $t_index[$j]{y}=-1;
    $t_index[$j]{9}=-1;    $t_index[$j]{z}=-1;
    $t_index[$j]{q}=-1;   

    $attr[$j] = <MODEL>;
    chomp($attr[$j]); 
    for ($i = 0; $i < $attr[$j]; $i++)
    {
           $ln = <MODEL>;
           chomp $ln;
           ($feature, $indx) = split (' ',$ln);
           $t_index[$j]{$feature}= $indx;        
    }       

   }
 
     sub ConverToBinary()
     {
                          $lastOne = $AS[14];
                          $i = 0;
                          for ($j=0; $j<14;$j++){
                             
                                if ($AS[$j] eq '0') {
                         	      $Bchars[$i] = 0;
	                              $Bchars[$i+1] = 0;
	                              $Bchars[$i+2] = 0;
                                      $i = $i+3;
	                              }
	                         else {
                                    if ($AS[$j] eq '1') {
	                              $Bchars[$i] = 0;
	                              $Bchars[$i+1] = 0;
	                              $Bchars[$i+2] = 1;
                                      $i = $i+3;
	                              }
	                        else{
                                if ($AS[$j] eq '2') {
	                              $Bchars[$i] = 0;
	                              $Bchars[$i+1] = 1;
	                              $Bchars[$i+2] = 0;
                                      $i = $i+3;
	                              }
	                        else{
                                if ($AS[$j] eq '3') {
	                              $Bchars[$i] = 0;
	                              $Bchars[$i+1] = 1;
	                              $Bchars[$i+2] = 1;
                                      $i = $i+3;
	                              }
	                        else{
                                if ($AS[$j] eq '4') {
	                              $Bchars[$i] = 1;
	                              $Bchars[$i+1] = 0;
	                              $Bchars[$i+2] = 0;
                                      $i = $i+3;
	                              }
	                        else{
                                if ($AS[$j] eq '5') {
	                             $Bchars[$i] = 1;
	                             $Bchars[$i+1] = 0;
	                             $Bchars[$i+2] = 1;
                                      $i = $i+3;
	                             }
	                        else{
                                if ($AS[$j] eq '6') {
	                             $Bchars[$i] = 1;
	                             $Bchars[$i+1] = 1;
	                             $Bchars[$i+2] = 0;
                                      $i = $i+3;
	                             }
	                        else{
                                if ($AS[$j] eq '7') {
	                             $Bchars[$i] = 1;
	                             $Bchars[$i+1] = 1;
	                             $Bchars[$i+2] = 1;
                                      $i = $i+3;
	                             }
                                }
                               }
                              }
                             }
                            }
                           }
                         }
                    }
                    for($l=0; $l<42; ++$l){
                         $AS[$l] = $Bchars[$l];
                    }
                    $AS[42] = $lastOne;
 }
 
 @U1 = ();
 @U2 = ();
 $di = 0;
 while ($d = <DATAFILE>){
   chomp($d);
    @words = split /\t/, $d;
    if (length($words[1]) == 15){
         @AS = split(//, $words[1]);
         ConverToBinary();
         $words[1] = join("",@AS);
    } 
    @Bchars = split //, $words[1];
##
    $d1 = '1';
    $d2='1';
    $d3='1';
    $d4='1';
    $d5='1';
    $d6='1';
    $dM = '1';
    $dnt = '1';
    $dma = '1';
    $dp1 = '1';
    $dp2 = '1';
    $dz = '1';
    $dc = '1';

    for ($l=0; $l<70; ++$l){
     $Rule[$l] = '0';      
    }
    $del = 0;

#Microti

    for ($l=0; $l<36; ++$l){
     if ($Bchars[$l] eq '1'){$dM = '0';}     
    }
    if ( ($dM eq '1') && ($Bchars[36] eq '1')&&($Bchars[37] eq '1')&&($Bchars[38] eq '0')&&($Bchars[39] eq '0')&&($Bchars[40] eq '0')
          &&($Bchars[41] eq '0')&&($Bchars[42] eq '0')){ 
          $Rule[$del] = '1';
    }
    else {$dM = '0';}	
    
# East Asian

    for ($l=0; $l<34; ++$l){
     if ($Bchars[$l] eq '1'){$d1 = '0';}     
    }
    if ( ($d1 eq '1') && ( ($Bchars[34] eq '1')||($Bchars[35] eq '1')||($Bchars[36] eq '1')||($Bchars[37] eq '1')||($Bchars[38] eq '1')||($Bchars[39] eq '1')||($Bchars[40] eq '1')||($Bchars[41] eq '1')||($Bchars[42] eq '1') ) ){ 
          $del = 1;
          $Rule[$del] = '1';

    }
    else {$d1 = '0';}

# East African Indian

    for ($l=22; $l<34; ++$l){
     if ($Bchars[$l] eq '1'){$d2 = '0';}     
    }
 
   
    if ($d2 eq '1'){
#CAS
         if (($Bchars[2] eq '1')&&($Bchars[3] eq '0')&&($Bchars[4] eq '0')&&($Bchars[5] eq '0')&&($Bchars[6] eq '0')){
                           $del = 2;
                           $Rule[$del] = '1';

         }

#CAS1_DELHI
          if (($Bchars[2] eq '1')&&($Bchars[3] eq '0')&&($Bchars[4] eq '0')&&($Bchars[5] eq '0')&&($Bchars[6] eq '0')&&
                        ($Bchars[7] eq '1')&&($Bchars[21] eq '1')&&($Bchars[34] eq '1')){
                           $del = 3;
                           $Rule[$del] = '1';
            
                     }

#CAS1-Kili
          if (($Bchars[19] eq '0')&&($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[33] eq '0')&&($Bchars[34] eq '0')&&
                        ($Bchars[3] eq '0')&&($Bchars[4] eq '0')&&($Bchars[5] eq '0')&&($Bchars[6] eq '0')&&($Bchars[2] eq '1')&&
                        ($Bchars[7] eq '1')&&($Bchars[8] eq '1')&&($Bchars[9] eq '0')&&($Bchars[10] eq '1')&&($Bchars[18] eq '1')&&($Bchars[35] eq '1')){
                           $del = 4;
                           $Rule[$del] = '1';
            
                     }
#CAS2
          if (($Bchars[3] eq '0')&&($Bchars[4] eq '0')&&($Bchars[5] eq '0')&&($Bchars[6] eq '0')&&($Bchars[7] eq '0')
                         &&($Bchars[8] eq '0')&&($Bchars[9] eq '0')&&($Bchars[2] eq '1')&&($Bchars[21] eq '1')&&($Bchars[34] eq '1')){
                           $del = 5;
                           $Rule[$del] = '1';
            
                     }

          
    }
    else {$d2 = '0';}

# Indo-Oceanic

    if ( ($Bchars[28] eq '0')&&($Bchars[29] eq '0')&&($Bchars[30] eq '0')&&($Bchars[31] eq '0')&&($Bchars[33] eq '0')){
 


#EAI2_MANILLA
         if (($Bchars[1] eq '1')&&($Bchars[2] eq '0')&&($Bchars[3] eq '1')&&($Bchars[18] eq '1')&&
                   ($Bchars[19] eq '0')&&($Bchars[20] eq '0')&&($Bchars[21] eq '1')&&($Bchars[32] eq '1')){
                           $del = 6;
                           $Rule[$del] = '1';
            
               }
#EAI2-nonthaburi
    for ($l=7; $l<25; ++$l){
     if ($Bchars[$l] eq '1'){$dnt = '0';}     
    }         
         if (($Bchars[1] eq '1')&&($Bchars[3] eq '1')&&($dnt eq '1')&&
                   ($Bchars[2] eq '0')&&($Bchars[32] eq '1')){
                           $del = 7;
                           $Rule[$del] = '1';
            
               }
#EAI1_SOM
         if (($Bchars[38] eq '1')&&($Bchars[39] eq '0')&&($Bchars[40] eq '1')&&($Bchars[32] eq '1')){
                           $del = 8;
                           $Rule[$del] = '1';
            
                     }


#EAI4_VNM
         if (($Bchars[24] eq '1')&&($Bchars[25] eq '0')&&($Bchars[26] eq '0')&&($Bchars[27] eq '1')&&($Bchars[32] eq '1')){
                                      $del = 9;
                                      $Rule[$del] = '1';
        
                                }
#EAI3_IND
         if (($Bchars[1] eq '0')&&($Bchars[2] eq '0')&&($Bchars[36] eq '0')&&($Bchars[37] eq '0')&&($Bchars[38] eq '0')&&
            ($Bchars[35] eq '1')&&($Bchars[39] eq '1')&&($Bchars[32] eq '1')){
                                            $del = 10;
                                            $Rule[$del] = '1';
          
                                      }
#EAI6_BGD1
         if (($Bchars[22] eq '0')&&($Bchars[21] eq '1')&&($Bchars[27] eq '1')&&($Bchars[32] eq '1')){
                                            $del = 11;
                                            $Rule[$del] = '1';

          
                                      }
#EAI7-BGD2
         if (($Bchars[24] eq '0')&&($Bchars[25] eq '0')&&($Bchars[23] eq '1')&&($Bchars[34] eq '1')&&($Bchars[35] eq '1')&&
             ($Bchars[37] eq '1')&&($Bchars[32] eq '0')&&($Bchars[26] eq '0')&&($Bchars[27] eq '0')&&($Bchars[36] eq '0')){
                                            $del = 12;
                                            $Rule[$del] = '1';
          
                                      }
#EAI8_MDG
         if (($Bchars[1] eq '0')&&($Bchars[2] eq '0')&&($Bchars[3] eq '1')&&($Bchars[32] eq '1')
              &&($Bchars[17] eq '1')&&($Bchars[18] eq '0')&&($Bchars[19] eq '1')){
                                            $del = 13;
                                            $Rule[$del] = '1';
          
                                      }
#EAI5 or EAI
                                     else{
                                            $del = 14;
                                            $Rule[$del] = '1';
           
                                         }

      
    }
    else {$d4 = '0';}

# Euro-American

    if ( ($Bchars[32] eq '0')&&($Bchars[33] eq '0')&&($Bchars[34] eq '0')&&($Bchars[35] eq '0')){ 

#X2
         if ( ($Bchars[16] eq '1')&&($Bchars[18] eq '1')&&($Bchars[38] eq '0')&&($Bchars[39] eq '0')&&($Bchars[40] eq '0')&&
         ($Bchars[41] eq '0')&&($Bchars[31] eq '1')&&($Bchars[17] eq '0') ){
                           $del = 15;
                           $Rule[$del] = '1';
          
          }

#LAM12-Madrid1
         if ( ($Bchars[7] eq '1')&&($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')
              &&($Bchars[24] eq '1')&&($Bchars[8] eq '0')&&($Bchars[9] eq '0')&&
              ($Bchars[10] eq '0')&&($Bchars[11] eq '0')&&($Bchars[12] eq '0')&&($Bchars[13] eq '0')&&
              ($Bchars[14] eq '1')&&($Bchars[30] eq '1')&&($Bchars[31] eq '1')       ){
                           $del = 16;
                           $Rule[$del] = '1';
            
              }
#LAM11-ZWE
         if ( ($Bchars[31] eq '1')&&($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&
                    ($Bchars[23] eq '0')&&($Bchars[24] eq '1')&&($Bchars[25] eq '1')&&($Bchars[26] eq '0')&&($Bchars[27] eq '0')&&
                    ($Bchars[28] eq '0')&&($Bchars[29] eq '0')&&($Bchars[30] eq '1')){
                           $del = 17;
                           $Rule[$del] = '1';
            
              }

#LAM3
          if (($Bchars[8] eq '0')&&($Bchars[9] eq '0')&&($Bchars[10] eq '0')&&
              ($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')&&($Bchars[24] eq '1')&&
              ($Bchars[30] eq '1')&&($Bchars[31] eq '1')){
                                        $del = 18;
                                        $Rule[$del] = '1';
        
                          }

#LAM4
          if ( ($Bchars[30] eq '1')&&($Bchars[31] eq '1')&&
                    ($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')&&
                    ($Bchars[24] eq '1')&&($Bchars[39] eq '0') ){
                           $del = 19;
                           $Rule[$del] = '1';
         
               }
                     

#LAM2
           if (($Bchars[30] eq '1')&&($Bchars[31] eq '1')&&($Bchars[2] eq '0')&&($Bchars[12] eq '0')&&
               ($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')&&($Bchars[24] eq '1')){
                                        $del = 20;
                                        $Rule[$del] = '1';
      
                                }

#LAM6
          if ( ($Bchars[24] eq '1')&&($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&
                                          ($Bchars[23] eq '0')&&($Bchars[31] eq '1')&&
                                          ($Bchars[27] eq '1')&&($Bchars[28] eq '0')&&($Bchars[29] eq '1')&&($Bchars[30] eq '1')){
                                          $del = 21;
                                          $Rule[$del] = '1';
       
                                    }


#LAM5
          if ( ($Bchars[12] eq '0')&&($Bchars[20] eq '0')&&
                 ($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')&&($Bchars[24] eq '1')&&($Bchars[30] eq '1')){
                                                   $del = 22;
                                                   $Rule[$del] = '1';
        
                                     }
}
    if ( ($Bchars[32] eq '0')&&($Bchars[33] eq '0')&&($Bchars[34] eq '0')&&($Bchars[35] eq '0')){ 

    
#LAM1
         if ( ($Bchars[2] eq '0')&&($Bchars[20] eq '0')&&
            ($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')&&($Bchars[24] eq '1')&&($Bchars[30] eq '1')){
                           $del = 23;
                           $Rule[$del] = '1';
          
               }
#LAM8
         if ( ($Bchars[26] eq '0')&&($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')&&
              ($Bchars[18] eq '1')&&($Bchars[19] eq '1')&&($Bchars[24] eq '1')&&($Bchars[25] eq '1')&&($Bchars[30] eq '1')&&
              ($Bchars[27] eq '1')&&($Bchars[31] eq '1') ){
                           $del = 24;
                           $Rule[$del] = '1';
          
               }



#X3
         if ( ($Bchars[3] eq '0')&&($Bchars[4] eq '0')&&($Bchars[5] eq '0')&&($Bchars[6] eq '0')&&
              ($Bchars[7] eq '0')&&($Bchars[8] eq '0')&&($Bchars[9] eq '0')&&($Bchars[10] eq '0')&&
              ($Bchars[11] eq '0')&&($Bchars[2] eq '1')&&($Bchars[16] eq '1')&&($Bchars[18] eq '1')&&
              ($Bchars[17] eq '0')&&($Bchars[30] eq '1')){
                                  $del = 25;
                                  $Rule[$del] = '1';
          
                     }


#T4_CEU1
         if ( ($Bchars[30] eq '1')&&($Bchars[19] eq '1')&&($Bchars[21] eq '1')&&($Bchars[17] eq '1')&&
              ($Bchars[24] eq '1')&&($Bchars[36] eq '1')&&($Bchars[39] eq '1')&&($Bchars[18] eq '0')&&
              ($Bchars[22] eq '0')&&($Bchars[23] eq '0')){
                                            $del = 26;
                                           $Rule[$del] = '1';
          
                               }


    }


    if ( ($Bchars[31] eq '1')&&($Bchars[32] eq '0')&&($Bchars[33] eq '0')&&($Bchars[34] eq '0')&&($Bchars[35] eq '0')&&
         ($Bchars[36] eq '1')){ 



#X1
         if ( ($Bchars[16] eq '1')&&($Bchars[17] eq '0')&&($Bchars[18] eq '1')&&($Bchars[30] eq '1')){
                           $del = 27;
                           $Rule[$del] = '1';
        
               }
#T-tuscany
         if ( ($Bchars[14] eq '0')&&($Bchars[15] eq '0')&&($Bchars[16] eq '0')&&($Bchars[17] eq '0')&&
            ($Bchars[18] eq '0')&&($Bchars[19] eq '0')&&($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&
            ($Bchars[22] eq '0')&&($Bchars[12] eq '1')&&($Bchars[13] eq '1')&&($Bchars[23] eq '1')&&($Bchars[30] eq '1')&&($Bchars[31] eq '1')){
                           $del = 28;
                           $Rule[$del] = '1';
         }
#T5-Madrid2
         if ( ($Bchars[19] eq '0')&&($Bchars[22] eq '0')&&($Bchars[18] eq '1')&&($Bchars[20] eq '1')&&($Bchars[21] eq '1')&&
              ($Bchars[23] eq '1')&&($Bchars[30] eq '1')&&($Bchars[31] eq '1')){
                           $del = 29;
                           $Rule[$del] = '1';
         }
#T3-OSA
         if ( ($Bchars[4] eq '0')&&($Bchars[5] eq '0')&&($Bchars[6] eq '0')&&($Bchars[7] eq '0')&&($Bchars[12] eq '0')&&
              ($Bchars[3] eq '1')&&($Bchars[8] eq '1')&&($Bchars[11] eq '1')&&
              ($Bchars[13] eq '1')&&($Bchars[30] eq '1')&&($Bchars[31] eq '1')){
                           $del = 30;
                           $Rule[$del] = '1';
         }

#T5_RUS1
         if ( ($Bchars[13] eq '1')&&($Bchars[14] eq '0')&&($Bchars[15] eq '0')&&($Bchars[16] eq '0')&&($Bchars[17] eq '0')&&
                          ($Bchars[18] eq '0')&&($Bchars[19] eq '0')&&($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&
                          ($Bchars[23] eq '0')){
                                          $del = 31;
                                         $Rule[$del] = '1';
            
                     }
#H1
          if ( ($Bchars[24] eq '1')&&($Bchars[25] eq '0')&&($Bchars[26] eq '0')&&($Bchars[27] eq '0')&&($Bchars[28] eq '0')&&
                          ($Bchars[29] eq '0')&&($Bchars[30] eq '0')){
                                        $del = 32;
                                        $Rule[$del] = '1';
         
                    }
#H2
          $FlagH2 = 1;
          for ($l=0; $l<24; ++$l){
             if ($Bchars[$l] eq '1'){$FlagH2 = 0;}
          }
          if ( $FlagH2 && ($del == 32)){
                                        $del = 33;
                                        $Rule[$del] = '1';
         
                    }

#T5
           if ( ($Bchars[21] eq '1')&&($Bchars[22] eq '0')&&($Bchars[23] eq '1')&&($Bchars[30] eq '1')){
                                          $del = 34;
                                         $Rule[$del] = '1';
        
                          }

    } 
    if ( ($Bchars[31] eq '1')&&($Bchars[32] eq '0')&&($Bchars[33] eq '0')&&($Bchars[34] eq '0')&&($Bchars[35] eq '0')&&
         ($Bchars[36] eq '1')){ 
#S
         if ( ($Bchars[7] eq '1')&&($Bchars[8] eq '0')&&($Bchars[9] eq '0')&&($Bchars[10] eq '1')){
                           $del = 35;
                           $Rule[$del] = '1';
          
          }         
#T3
         if ( ($Bchars[11] eq '1')&&($Bchars[12] eq '0')&&($Bchars[13] eq '1')&&($Bchars[30] eq '1')){
                            $del = 36;
                           $Rule[$del] = '1';
           
          }
#T3-ETH
         if ( ($Bchars[9] eq '0')&&($Bchars[10] eq '0')&&($Bchars[11] eq '0')&&($Bchars[12] eq '0')&&($Bchars[13] eq '0')&&
              ($Bchars[14] eq '1')&&($Bchars[15] eq '0')&&($Bchars[16] eq '0')&&($Bchars[17] eq '0')&&($Bchars[18] eq '0')&&
              ($Bchars[8] eq '1')&&($Bchars[19] eq '1')&&($Bchars[30] eq '1')&&($Bchars[31] eq '1')){
                            $del = 37;
                           $Rule[$del] = '1';
           
          }
#T1-RUS2
         if ( ($Bchars[6] eq '0')&&($Bchars[7] eq '0')&&($Bchars[8] eq '0')&&($Bchars[9] eq '0')&&($Bchars[10] eq '0')&&
              ($Bchars[11] eq '0')&&($Bchars[12] eq '0')&&($Bchars[13] eq '0')&&
              ($Bchars[14] eq '1')&&($Bchars[15] eq '0')&&($Bchars[16] eq '0')&&($Bchars[17] eq '0')&&
              ($Bchars[5] eq '1')&&($Bchars[18] eq '1')&&($Bchars[30] eq '1')&&($Bchars[31] eq '1')){
                            $del = 38;
                           $Rule[$del] = '1';
           
          }


#LAM9 or LAM
         if ( ($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')&&
              ($Bchars[24] eq '1')&&($Bchars[30] eq '1')){
                                         $del = 39;
                                         $Rule[$del] = '1';
            
                      }




#LAM10_CAM
          if ( ($Bchars[21] eq '1')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')&&($Bchars[24] eq '0')&&($Bchars[25] eq '1')){
                                        $del = 40;
                                        $Rule[$del] = '1';
       
                                }
#H4
#          if ( ($Bchars[27] eq '1')&&($Bchars[28] eq '0')&&($Bchars[29] eq '0')&&($Bchars[30] eq '0')&&($Bchars[1] eq '0')){
#                                       $del = 41;
#                                       $Rule[$del] = '1';
#        
#                                     }

}
    if ( ($Bchars[31] eq '1')&&($Bchars[32] eq '0')&&($Bchars[33] eq '0')&&($Bchars[34] eq '0')&&($Bchars[35] eq '0')&&
         ($Bchars[36] eq '1')){ 

#H3
         if ( ($Bchars[30] eq '0')&&($Bchars[29] eq '1')){
                           $del = 42;
                           $Rule[$del] = '1';
        
          }
#H37Rv
         if ( ($Bchars[18] eq '1')&&($Bchars[21] eq '1')&&($Bchars[19] eq '0')&&($Bchars[20] eq '0')&&($Bchars[30] eq '1')){
                           $del = 43;
                           $Rule[$del] = '1';
        
          }

#H
         if ( ($Bchars[24] eq '1')&&($Bchars[25] eq '0')&&($Bchars[26] eq '0')&&($Bchars[27] eq '0')&&($Bchars[28] eq '0')&&
               ($Bchars[30] eq '0')&&($Bchars[29] eq '0')){
                           $del = 44;
                           $Rule[$del] = '1';
        
          }

#T2
         if ( ($Bchars[30] eq '1')&&($Bchars[39] eq '0')&&($Bchars[40] eq '1')&&($Bchars[38] eq '1')){
                                         $del = 45;
                                        $Rule[$del] = '1';
            
                         }
#T2-uganda
         if ( ($Bchars[30] eq '1')&&($Bchars[39] eq '0')&&($Bchars[42] eq '0')&&($Bchars[40] eq '1')&&
              ($Bchars[38] eq '1')&&($Bchars[41] eq '1')){
                                         $del = 46;
                                        $Rule[$del] = '1';
            
                         }

#T4
         if ( ($Bchars[17] eq '1')&&($Bchars[18] eq '0')&&($Bchars[19] eq '1')&&($Bchars[30] eq '1')){
                                         $del = 47;
                                        $Rule[$del] = '1';
            
                               }
#T1 or T
         if ( ($Bchars[30] eq '1')){
                                       $del = 48;
                                       $Rule[$del] = '1';

                                    } 
#LAM7-TUR
         if ( ($Bchars[30] eq '1')&&($Bchars[24] eq '1')&&($Bchars[27] eq '1')&&($Bchars[31] eq '1')
              &&($Bchars[19] eq '0')&&($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')&&
                ($Bchars[25] eq '0')&&($Bchars[26] eq '0')){
                                       $del = 49;
                                       $Rule[$del] = '1';

                                    }            

    }
#MANU1
    if ( ($Bchars[33] eq '0')&&($Bchars[32] eq '1')&&($Bchars[34] eq '1')){
                        $del = 50;
                        $Rule[$del] = '1';

          }
#MANU2
    if ( ($Bchars[32] eq '0')&&($Bchars[33] eq '0')&&($Bchars[31] eq '1')&&($Bchars[34] eq '1')){
                        $del = 51;
                        $Rule[$del] = '1';

          }
#MANU3
    if ( ($Bchars[33] eq '0')&&($Bchars[35] eq '0')&&($Bchars[32] eq '1')&&($Bchars[36] eq '1')){
                        $del = 52;
                        $Rule[$del] = '1';

          }
#MANU-ancestor

    for ($l=0; $l<43; ++$l){
     if ($Bchars[$l] eq '0'){$dma = '0';}     
    }
    if ( ($dma eq '1')){
                        $del = 53;
                        $Rule[$del] = '1';

          }
    $d5 = '0';
#PINI
    if (($Bchars[38] eq '0')&&($Bchars[39] eq '0')&&($Bchars[40] eq '0')&&($Bchars[41] eq '0')&&
       ($Bchars[42] eq '0')){
        for ($l=0; $l<24; ++$l){
               if ($Bchars[$l] eq '1'){$dp1 = '0';}     
        }
        for ($l=7; $l<22; ++$l){
               if ($Bchars[$l] eq '1'){$dp2 = '0';}     
        }
        if ( ($Bchars[0] eq '0')&&($Bchars[1] eq '0')&&($Bchars[2] eq '0')&&($dp2 eq '1')&&
           ($Bchars[6] eq '1')&&($Bchars[22] eq '1')&&($Bchars[36] eq '1')&&($Bchars[37] eq '1')){
                        $del = 54;
                        $Rule[$del] = '1';

          }     
        if ( ($dp1 eq '1')&&($Bchars[24] eq '1')&&($Bchars[36] eq '1')&&($Bchars[37] eq '1')){
                        $del = 55;
                        $Rule[$del] = '1';

          }     
        if ( ($Bchars[0] eq '0')&&($Bchars[1] eq '0')&&($Bchars[2] eq '0')&&($dp2 eq '1')&&
           ($Bchars[3] eq '1')&&($Bchars[37] eq '1')){
                        $del = 56;
                        $Rule[$del] = '1';

          }     

   }

#CANETTII
        for ($l=0; $l<29; ++$l){
               if ($Bchars[$l] eq '1'){$dc = '0';}     
        }   
        if ( ($Bchars[30] eq '0')&&($Bchars[31] eq '0')&&($Bchars[32] eq '0')&&($Bchars[33] eq '0')&&($Bchars[34] eq '0')&&($dc eq '1')&&
             ($Bchars[36] eq '0')&&($Bchars[37] eq '0')&&($Bchars[38] eq '0')&&($Bchars[39] eq '0')&&($Bchars[40] eq '0')&& 
           ($Bchars[41] eq '0')&&($Bchars[42] eq '0')&&($Bchars[29] eq '1')&&($Bchars[35] eq '1')){
                        $del = 57;
                        $Rule[$del] = '1';

          }     
# Bovis



    if (($Bchars[37] eq '1')&&($Bchars[38] eq '0')&&($Bchars[39] eq '0')&&($Bchars[40] eq '0')&&($Bchars[41] eq '0')&&
       ($Bchars[42] eq '0')){

# BOVIS3
          if (($Bchars[1] eq '1')&&($Bchars[2] eq '0')&&($Bchars[3] eq '1')&&($Bchars[4] eq '0')&&
              ($Bchars[5] eq '0')&&($Bchars[6] eq '0')&&($Bchars[7] eq '0')&&($Bchars[8] eq '0')&&($Bchars[9] eq '0')&&
              ($Bchars[10] eq '0')&&($Bchars[11] eq '0')&&($Bchars[12] eq '0')&&($Bchars[13] eq '0')&&($Bchars[14] eq '1')&&
              ($Bchars[15] eq '0')&&($Bchars[16] eq '1')){
                           $del = 58;
                           $Rule[$del] = '1';

              }
#BOV4_CAPRAE
          if (($Bchars[0] eq '0')&&($Bchars[2] eq '0')&&($Bchars[15] eq '0')&&($Bchars[27] eq '0')){
                           $del = 59;
                           $Rule[$del] = '1';

              }

# BOVIS2
          if (($Bchars[1] eq '1')&&($Bchars[2] eq '0')&&($Bchars[3] eq '1')&&($Bchars[4] eq '1')&&
                   ($Bchars[5] eq '0')&&($Bchars[6] eq '1')&&($Bchars[7] eq '0')&&($Bchars[8] eq '0')&&($Bchars[9] eq '0')&&
                   ($Bchars[10] eq '0')&&($Bchars[11] eq '0')&&($Bchars[12] eq '1')&&($Bchars[13] eq '1')&&($Bchars[14] eq '1')&&
                   ($Bchars[15] eq '0')&&($Bchars[16] eq '1')){
                           $del = 60;
                           $Rule[$del] = '1';

                }

#BOVIS1
           if (($Bchars[1] eq '1')&&($Bchars[2] eq '0')&&
                               ($Bchars[7] eq '1')&&($Bchars[8] eq '0')&&($Bchars[9] eq '1')&&($Bchars[14] eq '1')&&
                               ($Bchars[15] eq '0')&&($Bchars[16] eq '1')){
                                    $del = 61;
                                    $Rule[$del] = '1';

                            }
#BOV
           else{
                                    $del = 62;
                                    $Rule[$del] = '1';

                            }

          
       }

    else {$d3 = '0';} 

# M. Africanum

#AFRI_1

    if (($Bchars[6] eq '0')&&($Bchars[7] eq '0')&&($Bchars[8] eq '0')&&($Bchars[5] eq '1')&&
        ($Bchars[9] eq '1')&&($Bchars[37] eq '1')&&($Bchars[39] eq '1')&&($Bchars[38] eq '0')){
                           $del = 63;
                           $Rule[$del] = '1';

                }
#AFRI_2

    if (($Bchars[6] eq '1')&&($Bchars[12] eq '1')&&($Bchars[19] eq '1')&&($Bchars[24] eq '1')&&($Bchars[35] eq '1')&&($Bchars[39] eq '1')&&
        ($Bchars[7] eq '0')&&($Bchars[8] eq '0')&&($Bchars[9] eq '0')&&($Bchars[10] eq '0')&&($Bchars[11] eq '0')&&
        ($Bchars[20] eq '0')&&($Bchars[21] eq '0')&&($Bchars[22] eq '0')&&($Bchars[23] eq '0')&&
        ($Bchars[36] eq '0')&&($Bchars[37] eq '0')&&($Bchars[38] eq '0')){
                           $del = 64;
                           $Rule[$del] = '1';

                }
#AFRI_3
     if (($Bchars[6] eq '1')&&($Bchars[12] eq '1')&&($Bchars[35] eq '1')&&($Bchars[39] eq '1')&&
         ($Bchars[7] eq '0')&&($Bchars[8] eq '0')&&($Bchars[9] eq '0')&&($Bchars[10] eq '0')&&($Bchars[11] eq '0')&&
         ($Bchars[38] eq '0')&&($Bchars[36] eq '0')&&($Bchars[37] eq '0')){
                           $del = 65;
                           $Rule[$del] = '1';

              }
#AFRI
     if (($Bchars[39] eq '1')&&
         ($Bchars[7] eq '0')&&($Bchars[8] eq '0')&&($Bchars[38] eq '0')){
                           $del = 66;
                           $Rule[$del] = '1';

              }

    
    else { $d6 = '0';} 
#ZERO
        for ($l=18; $l<41; ++$l){
               if ($Bchars[$l] eq '1'){$dz = '0';}     
        }   
        if ( ($Bchars[17] eq '1')&&($Bchars[41] eq '1')&&($dz eq '1')){
                        $del = 67;
                        $Rule[$del] = '1';
        }

#Ural-1
    if ( ($Bchars[1] eq '1')&&($Bchars[27] eq '1')&&($Bchars[28] eq '0')&&($Bchars[29] eq '0')&&($Bchars[30] eq '0')&&
         ($Bchars[31] eq '1')&&($Bchars[32] eq '0')&&($Bchars[33] eq '0')&&($Bchars[34] eq '0')&&($Bchars[35] eq '0')){
      $del = 68;
      $Rule[$del] = '1';
      $U1[$di] = 1; 
    }
#Ural-2
    if ( ($Bchars[1] eq '0')&&($Bchars[27] eq '1')&&($Bchars[28] eq '0')&&($Bchars[29] eq '0')&&($Bchars[30] eq '0')&&
         ($Bchars[31] eq '1')&&($Bchars[32] eq '0')&&($Bchars[33] eq '0')&&($Bchars[34] eq '0')&&($Bchars[35] eq '0')){ 
      $del = 41;
      $Rule[$del] = '1';
      $U2[$di] = 1;
    }
##
   $Rstring = join("", @Rule); 
   $line[$di] = join("",$words[0],"\t",$words[1],"\t",$Rstring,"\t",$words[2],"\n");
   $di = $di + 1;

 }
  $ld = $di;
  if ($ld != 1){

    if ($loneSp){
            $worksheet->write($xi, 0, "Index", $bold);
            $worksheet->write($xi, 1, "Spoligotype", $bold);
            $worksheet->write($xi, 2, "Lineage", $bold);
            $worksheet->write($xi, 3, "Probability", $bold);
    }
  }

     for ($i=0; $i<$M1-2; $i++)
     {
       for ($j = 0; $j < 21; $j++)
       {
        for ($k=0; $k<@array; $k++)
        {
            $ln = <MODEL>;
            chomp($ln);
            $P[$i][$j][$k] = $ln;

        }
       }
     }



 foreach $ln (@line) {
   chomp $ln;
   @gType = split ('\t',$ln);
   $id = $gType[0];
   $length = @gType;
   @A = split(//, $gType[1]);
  $xi = $xi +1;
  if ($ld != 1){ 
                 $worksheet->write($xi, 0, $id, $center);}
  if (!loneSp){ 
        for ($i=0; $i < @A; ++$i){
          if ($A[$i] =~ /a|b|c|d|e|f/) {$A[$i] = 'a';}
        }
   }
   if ($ld != 1){
                 if($loneSp){  
                                $worksheet->write_string($xi, 1, $gType[1]);
                     }
    }
   for($j = 0; $j < 43; $j++){
     $A[$j]=$t_index[$j]{$A[$j]};
   }
   $base = 0.;
   $max_p = 0.;
   $Found = 0;
   $hyp   = 0.0000000000001;
   foreach $m (keys(%rul))
    {
      if ($gType[$length-2] eq $m) { $curR = $m; $Found = 1;

      }
    }

   foreach $k (keys(%ind))
    {  
      if ( ($Found == 0) || ($curR eq "0000000000000000000000000000000000000000000000000000000000000000000000")){

          $P_A_this_class = $array[$ind{$k}]/$N;

      }
      else{
           $P_A_this_class = ($arrayRC[$rul{$curR}][$ind{$k}])/($SumRC[$rul{$curR}] );
      } 


      $start = 0;
      
### Different Markers ######
# to be completed later since model is trained only on spoligos so far.
#
      if ($SM12){$fin = 55;}
      if ($loneSp){$fin = 43;}
      for ($j=$start; $j<$fin; $j++)
       {
          $P_A_this_class = $P_A_this_class * $P[$j][$A[$j]][$ind{$k}];
       } 
      $P_A_this_class = $P_A_this_class + $hyp;      
      $base = $base + $P_A_this_class;
      $P_class[$ind{$k}] = $P_A_this_class;
      if ($P_A_this_class >= $max_p)
      {
         $max_p = $P_A_this_class;
         $max_class = $k;
      }
   } 

   if ($ld == 1){ 
#        open (OUT, ">out.txt") or die "Couldn't open out.txt";
        open (OUT, ">out$thetime.txt") or die "Couldn't open out$thetime.txt";
        if ($SM15 || $SM12 || $SM24th ){ 
               $result = sprintf ("     %s      %s  %s  %s          %.2f\n", $id, $gType[1], $gType[2], $max_class, (($P_class[$ind{$max_class}])/$base)); print OUT $result;
        }
        else{
               $result = sprintf ("     %s      %s  %s          %.2f\n", $id, $gType[1], $max_class, (($P_class[$ind{$max_class}])/$base)); print OUT $result;
        }                
        close OUT;
   }
   else{
        if ($SM12 || $SM15 || $SM24th ){
             $worksheet->write($xi, 3, $max_class); 
             $worksheet->write($xi, 4, (($P_class[$ind{$max_class}])/$base), $number2);
        }
        else{
             $worksheet->write($xi, 2, $max_class); 
             $worksheet->write($xi, 3, (($P_class[$ind{$max_class}])/$base), $number2);
            }
       }       



   } #foreach line



  close MODEL;
  close DATAFILE;



