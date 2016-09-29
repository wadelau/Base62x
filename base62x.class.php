<?php
/*
 * -Base62x in -PHP
 * Wadelau@ufqi.com
 * Refers to 
 	http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=6020065
 	-GitHub-Wadelau , base62x.c
 	https://github.com/wadelau/Base62x
 	https://ufqi.com/dev/base62x/?_via=-naturedns
 * Tue Aug  9 21:18:14 CST 2016
 * bugfix, 13:39 13 September 2016
 * bugfix, Thu Sep 29 04:06:26 UTC 2016
 */


class Base62x {

	
	# variables

	var $isdebug = false;
	var $i = 0;
	var $codetype = 0; # 0:encode, 1:decode
	const XTAG = 'x'; 
	const ENCD = "-enc";
	const DECD = "-dec";
	const DEBG = "-v";
	const CVTN = "-n";
	const b62x = array('0','1','2','3','4','5','6','7','8','9',
		'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
		'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
		'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
		'q','r','s','t','u','v','w','y','z','1','2','3','x');
	const bpos = 60; # 0-60 chars
	const xpos = 64; # b62x[64] = 'x'
	static $rb62x = array();
	const ascmax = 127;
	const asclist = array('4','5','6','7','8','9', '0',
		'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
		'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
		'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
		'q','r','s','t','u','v','w','y','z'); # 58 
	
	var $ascidx = array();
	var $ascrlist = array();
	static $ver = 0.7;
	

	# methods

	# encode, ibase=2,8,10,16,32...
	public static function encode($input, $ibase=null){
		
		$output = null;

		$codetype = 0;
		$xtag = self::XTAG;
		$b62x = self::b62x;
		$asclist = self::asclist;
		$bpos = self::bpos;
		$xpos = self::xpos;
		$ascmax = self::ascmax;

		$rb62x = self::fillRb62x($b62x, $bpos, $xpos);
		$isNum = false;
		if($ibase > 0){ $isNum = true; }
		if($isNum){
			$output = 0;
			$num_input = self::xx2dec($input, $ibase, $xpos, $rb62x); 	
			$obase = $xpos;
			$output = self::dec2xx($num_input, $obase, $rb62x);
			# why a mediate number format is needed?
		}
		else{
			# string
			$inputArr = str_split($input); $inputlen = count($inputArr);
			$setResult = self::setAscii($codetype, $inputArr, $ascidx, $ascmax, $asclist, $ascrlist);
			$asctype = $setResult['asctype'];
			$ascidx = $setResult['ascidx'];
			$ascrlist = $setResult['ascrlist'];

			$op = array();
			$i = 0; $m = 0;
			if($asctype == 1){
				$ixtag = ord($xtag);
				do{
					$inputArr[$i] = ord($inputArr[$i]);
					if($ascidx[$inputArr[$i]] > -1){
						$op[$m] = $xtag; $op[++$m] = $ascidx[$inputArr[$i]];	
					}
					else if($inputArr[$i] == $ixtag){
						$op[$m] = $xtag; $op[++$m] = $xtag;
					}
					else{
						$op[$m] = chr($inputArr[$i]);	
					}
					$m++;
				}
				while(++$i < $inputlen);
				$op[++$m] = $xtag; # asctype has a tag 'x' appended
			}
			else{
				$c0 = 0; $c1 = 0; $c2 = 0; $c3 = 0;
				do{
					$remaini = $inputlen - $i;
					$inputArr[$i] = ord($inputArr[$i]);
					switch($remaini){
						case 1:
							$c0 = $inputArr[$i] >> 2;
							$c1 = (($inputArr[$i] << 6) & 0xff) >> 6;
							if($c0 > $bpos){ $op[$m] = $xtag; $op[++$m] = $b62x[$c0]; }else{ $op[$m] = $b62x[$c0]; } 
							if($c1 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c1]; }else{ $op[++$m] = $b62x[$c1]; } 
							break;

						case 2:
							$inputArr[$i+1] = ord($inputArr[$i+1]);
							$c0 = $inputArr[$i] >> 2;
							$c1 = ((($inputArr[$i] << 6) & 0xff) >> 2) | ($inputArr[$i+1] >> 4);
							$c2 = (($inputArr[$i+1] << 4) & 0xff) >> 4;
							if($c0 > $bpos){ $op[$m] = $xtag; $op[++$m] = $b62x[$c0]; }else{ $op[$m] = $b62x[$c0]; } 
							if($c1 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c1]; }else{ $op[++$m] = $b62x[$c1]; } 
							if($c2 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c2]; }else{ $op[++$m] = $b62x[$c2]; } 
							$i += 1;
							break;

						default:
							$inputArr[$i+1] = ord($inputArr[$i+1]);
							$inputArr[$i+2] = ord($inputArr[$i+2]);
							$c0 = $inputArr[$i] >> 2;
							$c1 = ((($inputArr[$i] << 6) & 0xff) >> 2) | ($inputArr[$i+1] >> 4);
							$c2 = ((($inputArr[$i+1] << 4) & 0xff) >> 2) | ($inputArr[$i+2] >> 6);
							$c3 = (($inputArr[$i+2] << 2) & 0xff) >> 2;
							if($c0 > $bpos){ $op[$m] = $xtag; $op[++$m] = $b62x[$c0]; }else{ $op[$m] = $b62x[$c0]; } 
							if($c1 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c1]; }else{ $op[++$m] = $b62x[$c1]; } 
							if($c2 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c2]; }else{ $op[++$m] = $b62x[$c2]; } 
							if($c3 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c3]; }else{ $op[++$m] = $b62x[$c3]; } 
							$i += 2;	
					}
					$m++;
				}
				while(++$i < $inputlen);
			}
			$output = implode($op);
		}

		return $output;

	}

	# decode, obase=2,8,10,16,32...
	public static function decode($input, $obase=null){
		
		$output = "";

		$codetype = 1;
		$xtag = self::XTAG;
		$b62x = self::b62x;
		$asclist = self::asclist;
		$bpos = self::bpos;
		$xpos = self::xpos;
		$ascmax = self::ascmax;
		$rb62x = self::fillRb62x($b62x, $bpos, $xpos);
		
		$isNum = false;
		if($obase > 0){ $isNum = true; }
		if($isNum){
			$output = 0;
			$ibase = $xpos;
			$num_input = self::xx2dec($input, $ibase, $xpos, $rb62x); 	
			$output = self::dec2xx($num_input, $obase, $rb62x);
			# why a mediate number format is needed?
		}
		else{
			# string
			$inputArr = str_split($input); $inputlen = count($inputArr);
			$setResult = self::setAscii($codetype, $inputArr, $ascidx, $ascmax, $asclist, $ascrlist);
			$asctype = $setResult['asctype'];
			$ascidx = $setResult['ascidx'];
			$ascrlist = $setResult['ascrlist'];
			
			$op = array();
			$i = 0; $m = 0;
			if($asctype == 1){
				$inputlen--;
				do{
					if($inputArr[$i] == $xtag){
						if($inputArr[$i+1] == $xtag){
							$op[$m] = $xtag;
							$i++;
						}
						else{
							$op[$m] = chr($ascrlist[$inputArr[++$i]]);	
						}
					}
					else{
						$op[$m] = $inputArr[$i];	
					}
					$m++;
				}
				while(++$i < $inputlen);
			}
			else{
				$c0 = 0; $c1 = 0; $c2 = 0;
				$tmpArr = array();
				$bint = array('1'=>1, '2'=>2, '3'=>3);
				do{
					$tmpArr = array('\0', '\0', '\0', '\0');
					$remaini = $inputlen - $i;
					$k = 0; # what for?
					switch($remaini){
						case 1:
							error_log(__FILE__.": found illegal base62x input:[".$inputArr[$i]."]. 1608091042.");
							break;
						
						case 2:
							if($inputArr[$i] == $xtag){ $tmpArr[0] = $bpos + $bint[$inputArr[++$i]]; }
							else{$tmpArr[0] = $rb62x[$inputArr[$i]]; }
							if($inputArr[++$i] == $xtag){ $tmpArr[1] = $bpos + $bint[$inputArr[++$i]]; }
							else{$tmpArr[1] = $rb62x[$inputArr[$i]]; }
							$c0 = $tmpArr[0] << 2 | $tmpArr[1];
							$op[$m] = chr($c0);
							break;	

						case 3:
							if($inputArr[$i] == $xtag){ $tmpArr[0] = $bpos + $bint[$inputArr[++$i]]; }
							else{$tmpArr[0] = $rb62x[$inputArr[$i]]; }
							if($inputArr[++$i] == $xtag){ $tmpArr[1] = $bpos + $bint[$inputArr[++$i]]; }
							else{$tmpArr[1] = $rb62x[$inputArr[$i]]; }
							if($inputArr[++$i] == $xtag){ $tmpArr[2] = $bpos + $bint[$inputArr[++$i]]; }
							else{$tmpArr[2] = $rb62x[$inputArr[$i]]; }
							$c0 = $tmpArr[0] << 2 | $tmpArr[1] >> 4;
							$c1 = (($tmpArr[1] << 4) & 0xf0) | $tmpArr[2];
							$op[$m] = chr($c0);
							$op[++$m] = chr($c1);
							break;

						default:
							if($inputArr[$i] == $xtag){ $tmpArr[0] = $bpos + $bint[$inputArr[++$i]]; }
							else{$tmpArr[0] = $rb62x[$inputArr[$i]]; }
							if($inputArr[++$i] == $xtag){ $tmpArr[1] = $bpos + $bint[$inputArr[++$i]]; }
							else{$tmpArr[1] = $rb62x[$inputArr[$i]]; }
							if($inputArr[++$i] == $xtag){ $tmpArr[2] = $bpos + $bint[$inputArr[++$i]]; }
							else{$tmpArr[2] = $rb62x[$inputArr[$i]]; }
							if($inputArr[++$i] == $xtag){ $tmpArr[3] = $bpos + $bint[$inputArr[++$i]]; }
							else{$tmpArr[3] = $rb62x[$inputArr[$i]]; }
							$c0 = $tmpArr[0] << 2 | $tmpArr[1] >> 4;
							$c1 = (($tmpArr[1] << 4) & 0xf0) | ($tmpArr[2] >> 2);
							$c2 = (($tmpArr[2] << 6) & 0xff) | $tmpArr[3];
							$op[$m] = chr($c0);
							$op[++$m] = chr($c1);
							$op[++$m] = chr($c2);	
					}
					$m++;
				}
				while(++$i < $inputlen);
			}
			$output = implode($op);
		}

		return $output;

	}

	# xx2dec
	public static function xx2dec($inum, $ibase, $safebase, $ridx){

		$onum = 0;

		# @todo
		
		return $onum;

	}

	# dec2xx
	public static function dec2xx($inum, $obase, $ridx){
	
		$onum = 0;

		# @todo

		return $onum;

	}


	# inner faciliates

	# fill reverse b62x
	private static function fillRb62x($b62x, $bpos, $xpos){
	
		$rb62x = array();
		for($i=0; $i<=$xpos; $i++){
			if($i > $bpos && $i< $xpos){
				# omit x1, x2, x3	
			}
			else{
				$rb62x[$b62x[$i]] = $i;	
			}
		}

		return $rb62x;

	}

	# set ascii type
	private static function setAscii($codetype, $inputArr, $ascidx, $ascmax, $asclist, $ascrlist){
		
		$ret = array();

		$asctype = 0;
		$xtag = self::XTAG;
		$inputlen = count($inputArr);
		if($codetype == 0 && $inputArr[0] <= $ascmax){
			$asctype = 1;
			for($i=1; $i<$inputlen; $i++){
				$tmpi = ord($inputArr[$i]);
				if($tmpi > $ascmax
					|| ($tmpi > 16 && $tmpi < 21) # DC1-4
					|| ($tmpi > 27 && $tmpi < 32)){ # FC, GS, RS, US
					$asctype = 0;
					break;
				}
			}
		}
		else if($codetype == 1 && $inputArr[$inputlen-1] == $xtag){
			$asctype = 1;	
		}
		$ret['asctype'] = $asctype;

		if($asctype == 1){
			for($i=0; $i<=$ascmax; $i++){ $ascidx[$i] = -1; }		
			$idxi = 0;
			for($i=0; $i<17; $i++){
				$ascidx[$i] = $asclist[$idxi]; 
				$ascrlist[$asclist[$idxi]] = $i;
				$idxi++;
			}
			# DC 1-4, skip
			for($i=21; $i<28; $i++){
				$ascidx[$i] = $asclist[$idxi]; 
				$ascrlist[$asclist[$idxi]] = $i;
				$idxi++;
			}
			# FS, GS, RS, US, skip
			$tmpi = 47; # ord('/');
			for($i=ord(' '); $i<=$tmpi; $i++){
				$ascidx[$i] = $asclist[$idxi]; 
				$ascrlist[$asclist[$idxi]] = $i;
				$idxi++;
			}
			$tmpi = 64; # ord('@');
			for($i=ord(':'); $i<=$tmpi; $i++){
				$ascidx[$i] = $asclist[$idxi]; 
				$ascrlist[$asclist[$idxi]] = $i;
				$idxi++;
			}
			$tmpi = 96; # ord('`');
			for($i=ord('['); $i<=$tmpi; $i++){
				$ascidx[$i] = $asclist[$idxi]; 
				$ascrlist[$asclist[$idxi]] = $i;
				$idxi++;
			}
			for($i=ord('{'); $i<=$ascmax; $i++){
				$ascidx[$i] = $asclist[$idxi]; 
				$ascrlist[$asclist[$idxi]] = $i;
				$idxi++;
			}
		}

		$ret['ascidx'] = $ascidx;
		$ret['ascrlist'] = $ascrlist;

		return $ret;

	}


}

?>
