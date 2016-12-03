<?php
#
# global functions, by wadelau@ufqi.com
# update Sat Jul 11 09:20:03 CST 2015
# update 09:56 Tuesday, November 24, 2015
#

/**
 * Send a POST requst using cURL, refer to http://www.php.net/manual/en/function.curl-exec.php
 * @param string $url to request
 * @param array $post values to send
 * @param array $options for cURL
 * @return string
  !!! This can be replaced with $WebApp->setBy('url:', array('target'=>$url, 'parameter'=>$post)); !!!
 ! since Sat May  7 13:11:15 CST 2016, by wadelau
 */
function curlPost($url, array $post = NULL, array $options = array()){
    $defaults = array(
		CURLOPT_POST => 1,
		CURLOPT_HEADER => 0,
		CURLOPT_URL => $url,
		CURLOPT_FRESH_CONNECT => 1,
		CURLOPT_RETURNTRANSFER => 1,
		CURLOPT_FORBID_REUSE => 1,
		CURLOPT_TIMEOUT => 4,
		CURLOPT_POSTFIELDS => http_build_query($post)
		);
	if($_CONFIG['ssl_verify_ignore']){
		$defaults[CURLOPT_SSL_VERIFYHOST] = 0;
		$defaults[CURLOPT_SSL_VERIFYPEER] = 0;
	}
    $ch = curl_init();
    curl_setopt_array($ch, ($options + $defaults));
    if( ! $result = curl_exec($ch))
    {
        trigger_error(curl_error($ch));
    }
    curl_close($ch);
    return $result;
}

/**
 * send mail by system built-in sendmail commands or extra mailer.class
 * @para string $to, receiver's email address
 * @para string $subject, email's subject
 * @para string $body, message body
 * return array(0=>true|false, 1=>array('error'=>'...'));
 */
function sendMail($to,$subject,$body, $from='', $local=0){
    $rtnarr = array();
	
	if($local == 0){
		$from = $from==''?$_CONFIG['adminmail']:$from;

		$mailstr = 'To:'.$to.'\n';
		$mailstr .= 'Subject:'.$subject.'\n';
		$mailstr .= 'Content-Type:text/html;charset=UTF-8\n';
		$mailstr .= 'From:'.$from.'\n';
		$mailstr .= '\n';
		$mailstr .= $body.'\n';

		$tmpfile = "/tmp/".GConf::get('agentalias').".user.reg.mail.tmp";
		system('/bin/echo -e "'.$mailstr.'" > '.$tmpfile);
		system('/bin/cat '.$tmpfile.' | /usr/sbin/sendmail -t &');

		$rtnarr[0] = true;
    
	}
	else if($local == 1){
        global $_CONFIG;
        include($_CONFIG['appdir']."/mod/mailer.class.php");

        $_CONFIG['mail_smtp_server'] = "smtp.163.com";
        $_CONFIG['mail_smtp_username'] = "";
        $_CONFIG['mail_smtp_password'] = "";
        $_CONFIG['isauth'] = true;
        $_CONFIG['mail_smtp_fromuser'] = $_CONFIG['mail_smtp_username'];

        $mail = new Mailer($_CONFIG['mail_smtp_server'],25,$_CONFIG['isauth'],$_CONFIG['mail_smtp_username'],$_CONFIG['mail_smtp_password']);

        $mail->debug = true;;
        $from==''?'bangco@'.$_CONFIG['agentname']:$from;
        if($_CONFIG['isauth']){
            $from = $_CONFIG['mail_smtp_fromuser'];
        }

        #print __FILE__.": from:$from";
        $rtnarr[0] = $mail->sendMail($to, $from, $subject, $body, 'HTML');

    }

    return $rtnarr;
}

//- string utils
function startsWith($haystack, $needle){
    $length = strlen($needle);
    return (substr($haystack, 0, $length) === $needle);
}

function endsWith($haystack, $needle){
    $length = strlen($needle);
    $start  = $length * -1; //negative
    return (substr($haystack, $start) === $needle);
}

function inList($needle, $haystack){
    $pos = strpos(",".$haystack.",", ",".$needle.",");
    return ($pos === false ? false : true);
}

function inString($needle, $haystack){
    $pos = stripos($haystack, $needle);
    return ($pos === false ? false : true);
}

function substr_unicode($str, $s, $l = null) {
	return join("", array_slice(preg_split("//u", $str, -1, PREG_SPLIT_NO_EMPTY), $s, $l));
}

function shortenStr($str, $len=0){
	$newstr = '';
	if($len == 0){
		$len = 10;
	}
	$newstr = substr_unicode($str, 0, $len);

	return $newstr;

}

function mkUrl($file, $_REQU){
    $url = $file."?";
   
    $needdata = array('id','tbl','db','oid','otbl','oldv','field','linkfield','linkfield2','tit','tblrotate');
    foreach($_REQU as $k=>$v){
        if(in_array($k, $needdata) || startsWith($k,'pn') || startsWith($k, "oppn")){
            if($k == 'oldv'){
                $v = substr($v,0,32); # why? Sun Mar 18 20:40:59 CST 2012
            }
            $url .= $k."=".$v."&";
            #error_log(__FILE__.": $k=$v is detected.");

        }else{
            #error_log(__FILE__.": $k=$v is abandoned.");
        }
    }

    $url = substr($url, 0, strlen($url)-1);
    #print __FILE__.": url:[$url]\n";
    return $url;

}

function base62x($s, $dec=0, $numType=null){
    # e.g. base62x('abcd', 0, '8');
    # e.g. base62x('abcd', 1, '16');
    $type = "-enc";
    if($dec == 1){
        $type = "-dec";
    }
    $s2 = '';
    require_once($_CONFIG['appdir']."/mod/base62x.class.php");
    if($type == "-enc"){
        $s2 = Base62x::encode($s, $numType);
    }
    else{
        $s2 = Base62x::decode($s, $numType);
    }
    return $s2;
}


//--- page navigator utils

/**
 *	alert
 *	@str : alert info
 *  @type : behavior
 *  @topWindow
 *  @timeout
 */
function alert($str,$type="back",$topWindow="",$timeout=100){
	$str = '';
	$str .= "<script type=\"text/javascript\">".chr(10);
	if(!empty($str)){
		$str .= "window.alert(\"警告:\\n\\n{$str}\\n\\n\");".chr(10);
	}
	#print "window.alert('type:[".$type."]');\n";
	$str .= "function _r_r_(){";
	$winName=(!empty($topWindow))?"top":"self";
	Switch (StrToLower($type)){
		case "#":
			break;
		case "back":
			$str .= $winName.".history.go(-1);".chr(10);
			break;
		case "reload":
			$str .= $winName.".window.location.reload();".chr(10);
			break;
		case "close":
			$str .= "window.opener=null;window.close();".chr(10);
			break;
		case "function":
			$str .= "var _T=new Function('return {$topWindow}')();_T();".chr(10);
			break;
			//Die();
		default:
			if($type!=""){
				//echo "window.{$winName}.location.href='{$type}';";
				$str .= "window.{$winName}.location=('{$type}');";
			}
	}
	$str .= "}".chr(10);
	//avoid firefox not excute setTimeout
	$str .= "if(window.setTimeout(\"_r_r_()\",".$timeout.")==2){_r_r_();}";
	if($timeout==100){
		$str .= "_r_r_();".chr(10);
	}
	else{
		$str .= "window.setTimeout(\"_r_r_()\",".$timeout.");".chr(10);
	}
	$str .= "</script>".chr(10);
	$html = $_CONFIG['html_resp']; $html = str_replace("RESP_TITLE","Alert!", $html); $html = str_replace("RESP_BODY", $str, $html);
	print $html;
	exit();
}

/**
 * URL redirect, remedy by wadelau@ufqi.com 09:52 Tuesday, November 24, 2015
 */
function redirect($url, $time=0, $msg='') {
    //multi URL addr support ?
    $url = str_replace(array("\n", "\r"), '', $url);
	if(!inString('://', $url)){ # relative to absolute path
		$url = "//".$_SERVER['SERVER_NAME'].":".$_SERVER['SERVER_PORT'].$url;
	}
	if($time < 10){ $time = $time * 1000; } # in case of milliseconds
	$hideMsg = "<!DOCTYPE html><html><head>";
	$hideMsg .= "<meta http-equiv=\"refresh\" content=\"{$time};URL='{$url}'\">";
	$hideMsg .= "</head><body>";  # remedy Mon Nov 23 22:03:24 CST 2015
    if (empty($msg)){
        #$msg = "系统将在{$time}秒之后自动跳转到{$url}！";
		$hideMsg = $hideMsg." <a href=\"".$url."\">系统将在{$time}秒之后自动跳转</a> ...";
	}
	else{
		$hideMsg = $hideMsg . $msg;
	}
	$hideMsg .= "<script type='text/javascript'>window.setTimeout(function(){window.location.href='".$url."';}, ".$time.");</script>";
	$hideMsg .= "</body></html>";
    if (!headers_sent()) {
        // redirect
        if (0 === $time) {
            header("Location: " . $url, true, 302);
			print $hideMsg;
        }
        else {
			print $hideMsg;
        }
        exit();
    }
    else{
        print $hideMsg;
        exit();
    }
}

# added by wadelau@ufqi.com,  Wed Oct 24 09:54:10 CST 2012
function isImg($file){
	$isimg = 0;
	if($file != ''){
		$tmpfileext = substr($file, strlen($file)-4);
		if(in_array(strtolower($tmpfileext),array("jpeg",".jpg",".png",".gif",".bmp"))){
			$isimg = 1;
		}
	}
	return $isimg;

}

function isEmail($email){
    if(!preg_match('|^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]{2,})+$|i', $email)){
    	return 0;
    }
    else{
      return 1;
    }
}

# get Ids list from array|hash
# by wadelau@ufqi.com, Sat Jul 11 09:21:13 CST 2015
function getIdList($iarray, $ikey){
	$tmpIds = "99999999,";

	foreach($iarray as $k=>$v){
		$tmpIds .= $v[$ikey].",";
	}
	$tmpIds = substr($tmpIds, 0, strlen($tmpIds)-1);

	return $tmpIds;

}

# write log in a simple approach
# by wadelau@ufqi.com, Sat Oct 17 17:38:26 CST 2015
# e.g.
# debug($user);
# debug($user, 'userinfo');  # with tag 'userinfo'
# debug($user, 'userinfo', 1); # with tag 'userinfo' and in backend and frontend
function debug($obj, $tag='', $output=null){
	$caller = debug_backtrace();
	if(is_array($obj) || is_object($obj)){
		if(isset($user)){
			$s .= $user->toString($obj);
		}
		else{
			$s .= serialize($obj);
		}
	}
	else{
		$s .= $obj;
	}

	if($tag != ''){
		$s = " $tag:[$s]";
	}
	$callidx = count($caller) - 2;
	$s .= ' func:['.$caller[$callidx]['function'].'] file:['.$caller[$callidx]['file'].'] line:['.$caller[$callidx]['line'].']';

	$s = "[".date("Y-m-d-H:i:s")."] ".$s."\n";
	
	if($output != null){
	    
	    if(startsWith($output, "file:")){
	        $f = str_replace('file:', '', $output).date('Ymd', time()).'.log';
	        file_put_contents($f, $s, FILE_APPEND);
	        error_log($s);
	    
	    }
	    else{
    		$output = intval($output);
	        if ($output == 0) { // in backend only
    			error_log ( $s );
    		}
    		else if ($output == 1) { // in backend and frontend
    			error_log ( $s );
    			print $s;
    		}
    		else if ($output == 2) { // in backend and frontend with backtrace
    			$s .= " backtrace:[" . serialize ( $caller ) . "]";
    			error_log ( $s );
    			print $s;
    		}
    		else{
    		    error_log(__FILE__.': Unknown log output:['.$output.']. s:['.$s.']');
    		}
	    }
	    
	}
	else{
		error_log($s); # default mode
	}
	
}


 // Wht: Web and/or HTTP Tools
 // get/set data from input and/or out and filter as expected
 // added by wadelau@ufqi.com
 // 19:11 20 June 2016
 class Wht {
 
 	private  static $hmt = array(); # container of variables for set
 
 	# get input from src
 	public static function get($src, $k = null, $defaultValue = null) {
 		// src=$_RQUEST, $_SERVER, $_COOKIE, $_SESSION, php://input, ...
 		$rtn = '';
 
 		if (! $src) {
 			$src = $_REQUEST;
 		}
 		if (! $k) {
 			$k = 'all';
 		}
 
 		if ($k == 'all') {
 			$rtn = serialize ( $src );
 		}
 		else {
 			$rtn = trim($src[$k]);
 		}
 
 		if (!$rtn && $defaultValue != null) {
 			$rtn = $defaultValue;
 		}
 
 		$rtn = str_replace ( '<', '&lt;', $rtn );
 		$rtn = str_replace ( '"', '&quot;', $rtn );
 
 		return $rtn;
 
 	}
 
 	# set output to dest
 	public static function set($dest, $k, $v) {
 		// dest=setHeader, setStatus, setCookie ...
 		self::$hmt['set'][$dest] = array($k, $v);
 
 	}
 
 	# flush set, usually at the end of a request handler
 	public static function flushSet(){
 
 		foreach (self::$hmt['set'] as $tk=>$tv){
 				
 			$dest = $tk; $k = $tv[0]; $v = $tv[1];
 			if($dest == 'setheader'){
 				header($k, $v);
 			}
 			else if($dest == 'setstatus'){
 				http_response_code($v);
 			}
 			else if($dest == 'setcookie'){
 				setcookie($k, $v['value'], $v['expire']);
 			}
 			else{
 				debug(__FILE__.": Unknown set:[$dest]");
 			}
 
 		}
 
 	}
	
	//- client ip read
	public static function getIp() {
	
		$ip = '';
		
		if (@$_SERVER["REMOTE_ADDR"]){ $ip = $_SERVER["REMOTE_ADDR"]; }
		else if (@$_SERVER["HTTP_X_FORWARDED_FOR"]){ $ip = $_SERVER["HTTP_X_FORWARDED_FOR"]; }
		else if (@$_SERVER["HTTP_CLIENT_IP"]){ $ip = $_SERVER["HTTP_CLIENT_IP"]; }
		else if (@getenv( "HTTP_X_FORWARDED_FOR" )){ $ip = getenv( "HTTP_X_FORWARDED_FOR" ); }
		else if (@getenv( "HTTP_CLIENT_IP" )){ $ip = getenv( "HTTP_CLIENT_IP" ); }
		else if (@getenv( "REMOTE_ADDR" )){ $ip = getenv( "REMOTE_ADDR" ); }
		else{ $ip = "Unknown";}

		if (($ip == "Unknown" or $ip == "127.0.0.1"
				or strpos( $ip, "172.31." ) === 0)
			and @$_SERVER["HTTP_X_REAL_IP"]){
			
			$ip = $_SERVER["HTTP_X_REAL_IP"];
		}
		if (($ip == "Unknown" or $ip == "127.0.0.1" or strpos( $ip, "172.31." ) === 0)
				and @$_SERVER["HTTP_X_FORWARDED_FOR"]) {
			
			$ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
			if (($tmppos=strrpos($ip," "))>0){
				$ip=substr($ip,$tmppos+1);
			}
			if (($tmppos=strrpos($ip,","))>0){
				$ip=substr($ip,$tmppos+1);
			}
		}
		
		return $ip;
		
	 }
 
 }
 
 /* get Smarty template file name
  wadelau, Wed Feb 15 09:18:27 CST 2012
  */
 function getSmtTpl($file, $act){
 	$scriptname = explode("/",$file);
 	$scriptname = $scriptname[count($scriptname)-1];
 	$scriptname = explode(".",$scriptname);
 	$scriptname = $scriptname[0];
 	return $smttpl = $scriptname.'_'.($act==''?'main':$act).'.html';
 }
 
 