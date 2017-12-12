<?php

# evaluate speed base62x.module vs. base64 built-in

$s = rand(100, 999999).'[a:9:{s:2:"ci";s:5:"A6324";s:2:"oi";s:11:"dsp_4183762";s:2:"nt";s:2:"US";s:2:"ai";s:5:"{IFA}";s:5:"price";d:1.0000000000000001E-5;s:5:"union";s:11:"dsp_jykj_td";s:6:"sub_ci";s:6:"105148";s:4:"gaid";s:5:"{IFA}";s:9:"affiparam";a:5:{s:7:"aff_sub";s:67:"fabb3d275-6256-199b-cc031a897f9f515b71213eb1a0e5ccce31185507d860019";s:8:"aff_sub2";s:6:"105148";s:8:"aff_sub3";s:0:"";s:8:"aff_sub4";s:0:"";s:8:"aff_sub5";s:0:"";}}]'.rand(100, 999999);

$istep = 50000;
$testlimit = 200000;

$t_start = microtime_float();
for($i=0; $i<$testlimit; $i++){
	$s = rand(100, 999999).'[a:9:{s:2:"中文世界ci";s:5:"A6324";s:2:"oi";s:11:"dsp_4183762";s:2:"nt";s:2:"US";s:2:"ai";s:5:"{IFA}";s:5:"price";d:1.0000000000000001E-5;s:5:"union";s:11:"dsp_jykj_td";s:6:"sub_ci";s:6:"105148";s:4:"gaid";s:5:"{IFA}";s:9:"affiparam";a:5:{s:7:"aff_sub";s:67:"fabb3d275-6256-199b-cc031a897f9f515b71213eb1a0e5ccce31185507d860019";s:8:"aff_sub2";s:6:"105148";s:8:"aff_sub3";s:0:"";s:8:"aff_sub4";s:0:"";s:8:"aff_sub5";s:0:"";}}]'.rand(100, 999999);
	$s2 = base62x_encode($s);
	if($i % $istep == 0){
		print "i:$i \n\t $s base62x s_enc:$s2\n";
	}
} 
$t_cost = microtime_float() - $t_start;
print "base62x $testlimit timestart:$t_start timecost:$t_cost\n";

$t_start = microtime_float();
for($i=0; $i<$testlimit; $i++){
	$s = rand(100, 999999).'[a:9:{s:2:"ci";s:5中文世界:"A6324";s:2:"oi";s:11:"dsp_4183762";s:2:"nt";s:2:"US";s:2:"ai";s:5:"{IFA}";s:5:"price";d:1.0000000000000001E-5;s:5:"union";s:11:"dsp_jykj_td";s:6:"sub_ci";s:6:"105148";s:4:"gaid";s:5:"{IFA}";s:9:"affiparam";a:5:{s:7:"aff_sub";s:67:"fabb3d275-6256-199b-cc031a897f9f515b71213eb1a0e5ccce31185507d860019";s:8:"aff_sub2";s:6:"105148";s:8:"aff_sub3";s:0:"";s:8:"aff_sub4";s:0:"";s:8:"aff_sub5";s:0:"";}}]'.rand(100, 999999);
	$s2 = base64_encode($s);
	if($i % $istep == 0){
		print "i:$i \n\t $s base64 s_enc:$s2\n";
	}
} 
$t_cost = microtime_float() - $t_start;
print "base64 $testlimit timestart:$t_start timecost:$t_cost\n";



# 
function microtime_float()
{
    list($usec, $sec) = explode(" ", microtime());
    return ((float)$usec + (float)$sec);
}

?>
