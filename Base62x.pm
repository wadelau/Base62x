#!/usr/bin/perl -w

=pod

* -Base62x in -Perl
* Wadelau@{ufqi,gmail,hotmail}.com
* Refers to 
*    http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=6020065
*    -GitHub-Wadelau , base62x.c
*    https://github.com/wadelau/Base62x
*    https://ufqi.com/dev/base62x/?_via=-naturedns
* since Tue Aug  9 21:18:14 CST 2016
* bugfix, 13:39 13 September 2016
* bugfix, Thu Sep 29 04:06:26 UTC 2016
* imprvs on numeric conversion, Fri Oct  7 03:42:59 UTC 2016
* bugifx by _decodeByLength, 20:40 28 November 2016
* Base62x in Perl, init, Thu Aug 30 20:49:27 CST 2018
* Base62x in Perl, refine, Tue Sep  4 19:56:01 CST 2018
* imprvs with decode, refer to Base62x in Python, Sat Mar  9 13:48:05 GMT 2019

=cut

#package MIME::Base62x;
package Base62x;

use strict;
use warnings;
use vars qw(@ISA @EXPORT $VERSION);

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(base62x_encode base62x_decode);
my $VERSION = '1.0';
my $UTF8 = 'UTF-8';
my $LOGTAG = 'Base62x';

use constant {
    XTAG => 'x',
    ENCD => '-enc',
    DECD => '-dec',
    DEBG => '-v',
    CVTN => '-n',
    };
my ($i, $isdebug, $codetype) = (0, 0, 0);
my ($bpos, $xpos, $ascmax, $max_safe_base, $base59) = (60, 64, 127, 36, 59);
    # 0-60 chars; b62x[64] = 'x'
my @b62x = ('0','1','2','3','4','5','6','7','8','9',
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
        'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
        'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
        'q','r','s','t','u','v','w','y','z','1','2','3','x');
my @asclist = ('4','5','6','7','8','9', '0',
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
        'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
        'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
        'q','r','s','t','u','v','w','y','z'); # 58
my (%rb62x, @ascidx, %ascrlist) = ((), (), ());

# @override new
sub new {
	my $class = $_[0]; # shift;
	my $self = {};
	my $args =  $_[1]; # pop @_;
	bless $self, $class;
	my @args = ();
    if(defined($args)){
        @args = @{$args};
    }
    my $argc = scalar @args;

    $self->_fillRb62x();

	return $self;
}

#
# OOP style
# encode, ibase=2,8,10,16,32...
sub encode($ $) {
    my $self = $_[0]; # shift
    my $output = '';
    my $input = $_[1];
    my $ibase = 0;
    my $argc = scalar @_;
    if($argc > 2){
        $ibase = $_[2];
    }
    #print $LOGTAG.":encode: argc:[$argc] input1:[$input] 2:[$ibase] input-len:".length($input)."\n";
    if($input eq ''){ return $output; }

    $codetype = 0;
    my $rb62xSize = keys %rb62x;
    if($rb62xSize < 1){ $self->_fillRb62x(); }
    my $isNum = 0;
    my $xtag = XTAG;
    if($ibase > 0){ $isNum = 1; }
    if($isNum == 1){
        # number
        $output = 0;
        my $num_input = $self->_xx2dec($input, $ibase, \%rb62x);
        $output = $self->_dec2xx($num_input, $xpos, \@b62x);
    }
    else{
        # string
        $input = Encode::encode($UTF8, $input); 
        my @inputArr = split(//, $input); my $inputlen = scalar @inputArr;
        #print "aft pack:input:[$input] length:".$inputlen."\n"; 
        my $asctype = $self->_setAscii($codetype, \@inputArr);
        
        my @op = (); 
        $i = 0 ; my $m = 0;
        if($asctype == 1){
            # ascii string
            my $ixtag = ord($xtag);
            do{
                $inputArr[$i] = ord($inputArr[$i]);
                if($ascidx[$inputArr[$i]] ne "-1"){ # has set
                    $op[$m] = $xtag;
                    $op[++$m] = $ascidx[$inputArr[$i]];
                }
                elsif($inputArr[$i] == $ixtag){
                    $op[$m] = $xtag;
                    $op[++$m] = $xtag;
                }
                else{
                    $op[$m] = chr($inputArr[$i]);
                }
                $m++;
            }
            while(++$i < $inputlen);
            $op[$m] = $xtag; # asctype=1 has a tag 'x' appended
        }
        else{
            # non-ascii, string
            my ($c0, $c1, $c2, $c3, $remaini) = (0, 0, 0, 0, 0);
            do{
                $remaini = $inputlen - $i;
                $inputArr[$i] = ord($inputArr[$i]);
                #print "".($i).": byte:[".$inputArr[$i]."] char:[".chr($inputArr[$i])."]\n";
                if($remaini > 2){
                    $inputArr[$i+1] = ord($inputArr[$i+1]);
                    $inputArr[$i+2] = ord($inputArr[$i+2]);
                    $c0 = $inputArr[$i] >> 2;
                    $c1 = ((($inputArr[$i] << 6) & 0xff) >> 2) | ($inputArr[$i+1] >> 4);
                    $c2 = ((($inputArr[$i+1] << 4) & 0xff) >> 2) | ($inputArr[$i+2] >> 6);
                    $c3 = (($inputArr[$i+2] << 2) & 0xff) >> 2;
                    if($c0 > $bpos){ $op[$m] = $xtag; $op[++$m] = $b62x[$c0]; }
                    else{ $op[$m] = $b62x[$c0]; } 
                    if($c1 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c1]; }
                    else{ $op[++$m] = $b62x[$c1]; } 
                    if($c2 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c2]; }
                    else{ $op[++$m] = $b62x[$c2]; } 
                    if($c3 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c3]; }
                    else{ $op[++$m] = $b62x[$c3]; } 
                    $i += 2;
                } 
                elsif($remaini == 2){
                    $inputArr[$i+1] = ord($inputArr[$i+1]);
                    $c0 = $inputArr[$i] >> 2;
                    $c1 = ((($inputArr[$i] << 6) & 0xff) >> 2) | ($inputArr[$i+1] >> 4);
                    $c2 = (($inputArr[$i+1] << 4) & 0xff) >> 4;
                    if($c0 > $bpos){ $op[$m] = $xtag; $op[++$m] = $b62x[$c0]; }
                    else{ $op[$m] = $b62x[$c0]; } 
                    if($c1 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c1]; }
                    else{ $op[++$m] = $b62x[$c1]; } 
                    if($c2 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c2]; }
                    else{ $op[++$m] = $b62x[$c2]; } 
                    $i += 1;
                }
                elsif($remaini == 1){
                    $c0 = $inputArr[$i] >> 2;
                    $c1 = (($inputArr[$i] << 6) & 0xff) >> 6;
                    if($c0 > $bpos){ $op[$m] = $xtag; $op[++$m] = $b62x[$c0]; }
                    else{ $op[$m] = $b62x[$c0]; } 
                    if($c1 > $bpos){ $op[++$m] = $xtag; $op[++$m] = $b62x[$c1]; }
                    else{ $op[++$m] = $b62x[$c1]; } 
                }
                $m++; 
            }
            while(++$i < $inputlen);
        }
        $output = join('', @op);
    }
    return $output;
}

#
# decode, obase=2,8,10,16,32... 
sub decode($ $){
    my $self = $_[0]; # shift
    my $output = '';
    my $input = $_[1];
    my $ibase = 0;
    my $argc = scalar @_;
    if($argc > 2){
        $ibase = $_[2];
    }
    if($input eq ''){ return $output; }

    $codetype = 1;
    my $xtag = XTAG;
    my $rb62xSize = keys %rb62x;
    if($rb62xSize < 1){ $self-> _fillRb62x(); }
    my $isNum = 0;
    if($ibase > 0){ $isNum = 1; }
    if($isNum == 1){
        # number
        $output = 0;
        my $num_input = $self->_xx2dec($input, $xpos, \%rb62x);
        $output = $self->_dec2xx($num_input, $ibase, \@b62x);
    }
    else{
        # string
        my @inputArr = split(//, $input); my $inputlen = scalar @inputArr;
        #print "aft pack:input:[$input] length:".$inputlen." codetype:[$codetype]\n"; 
        my $asctype = $self->_setAscii($codetype, \@inputArr);
        
        my @op = (); 
        $i = 0 ; my $m = 0;
        if($asctype == 1){
            # ascii
            $inputlen--; # omit last 'x'
            do{
                if($inputArr[$i] eq $xtag){
                    if($inputArr[$i+1] eq $xtag){
                        $op[$m] = $xtag;
                        $i++;
                    }
                    else{
                        $op[$m] = chr($ascrlist{$inputArr[++$i]});
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
            # non-ascii
            my (@tmpArr, @arr, $arr) = ((), (), undef); my $remaini = 0;
            my @bint = (0, 1, 2, 3); my $j = 0;
            do{
                @tmpArr = (undef, undef, undef, undef);
                $remaini = $inputlen - $i;
                #print "".($i).": byte:[".$inputArr[$i]."] char:[".ord($inputArr[$i])."]\n";
                if($remaini > 1){
                    $j = 0;
                    do{
                        if($inputArr[$i] eq $xtag){ 
                            $i++;
                            $tmpArr[$j] = $bpos + $bint[$inputArr[$i]];
                        }
                        else{
                            $tmpArr[$j] = $rb62x{$inputArr[$i]};
                        }
                        $i++; $j++;
                    }
                    while($j < 4 && $i < $inputlen);

                    $arr = $self->_decodeByLength(\@tmpArr, \@op, $m);
                    @arr = @{$arr}; @op = @{$arr[0]}; $m = $arr[1];
                    # m is deprecated.
 
                }
                elsif($remaini == 1){
                    print($LOGTAG.": found illegal base62x input:[".$inputArr[$i]."]. 1608091042.");
                    next;
                } 
                $m++;
            }
            while($i < $inputlen);
        }
        $output = join('', @op);
    }
    $output = Encode::decode($UTF8, $output); 
    return $output;
}

#
# functional style, static
sub base62x_encode {
    #my $self = $_[0];
    my $self = Base62x->new();
    my $rtn = '';
    my $input = $_[0];
    my $ibase = 0;
    my $argc = scalar @_;
    if($argc > 1){
        $ibase = $_[1];
    }
    $rtn = $self->encode($input, $ibase);
    return $rtn;
}

#
sub base62x_decode {
    my $self = Base62x->new();
    my $rtn = '';
    my $input = $_[0];
    my $obase = 0;
    my $argc = scalar @_;
    if($argc > 1){
        $obase = $_[1];
    }
    $rtn = $self->decode($input, $obase);
    return $rtn;
}

#
sub _fillRb62x(){
    my $self = $_[0];
    for($i=0; $i<=$xpos; $i++){
        if($i > $bpos && $i < $xpos){
            # omit x1, x2, x3
        } 
        else{
            $rb62x{$b62x[$i]} = $i;
        }
    }
    return 0;
}

# 
# inner methods 
#
sub _setAscii($ $){
    my $self = $_[0];
    my $asctype = 0;
    my $codetype = $_[1];
    my @inputArr = @{$_[2]};
    my $inputlen = scalar @inputArr;
    if($codetype == 0 && ord($inputArr[0]) <= $ascmax){
        $asctype = 1; my $tmpi = 0;
        for($i=1; $i<$inputlen; $i++){
            $tmpi = ord($inputArr[$i]);
            if($tmpi > $ascmax
                || ($tmpi > 16 && $tmpi < 21) # DC1-4
                || ($tmpi > 27 && $tmpi < 32)){ # FC, GS, RS, US
                $asctype = 0;
                last;
            }
        }
    }
    elsif($codetype == 1 && $inputArr[$inputlen - 1] eq XTAG){
        $asctype = 1;       
    }
    if($asctype == 1){
        my $idxlen = scalar @ascidx;
        if($idxlen < 1){
            $self->_fillAscRlist();    
        }
    }
    return $asctype;
}

#
sub _fillAscRlist(){
    my $self = $_[0];
    for($i=0; $i<$ascmax; $i++){ $ascidx[$i] = -1; }
    my $idxi = 0;
    my @bgnArr = (0, 21, 32, 58, 91, 123);
    my @endArr = (17, 28, 48, 65, 97, $ascmax+1);
    my $arrSize = scalar @bgnArr;
    for(my $ai=0; $ai<$arrSize; $ai++){
        my $bgn = $bgnArr[$ai];
        my $end = $endArr[$ai];
        for($i=$bgn; $i<$end; $i++){
            $ascidx[$i] = $asclist[$idxi];
            $ascrlist{$asclist[$idxi]} = $i;
            $idxi++;
        }
    }
    return 0;
}

#
sub _decodeByLength($ $ $){
    my $self = $_[0];
    my @rtnArr = ();
    my @tmpArr = @{$_[1]};
    my @op = @{$_[2]};
    my $m = $_[3];
    my ($c0, $c1, $c2) = (0, 0, 0);
    if(defined($tmpArr[3])){
        $c0 = $tmpArr[0] << 2 | $tmpArr[1] >> 4;
        $c1 = (($tmpArr[1] << 4) & 0xf0) | ($tmpArr[2] >> 2);
        $c2 = (($tmpArr[2] << 6) & 0xff) | $tmpArr[3];
        $op[$m] = chr($c0);
        $op[++$m] = chr($c1);
        $op[++$m] = chr($c2);
    }
    elsif(defined($tmpArr[2])){
        $c0 = $tmpArr[0] << 2 | $tmpArr[1] >> 4;
        $c1 = (($tmpArr[1] << 4) & 0xf0) | $tmpArr[2];
        $op[$m] = chr($c0);
        $op[++$m] = chr($c1);
    }
    elsif(defined($tmpArr[1])){
        $c0 = $tmpArr[0] << 2 | $tmpArr[1];
        $op[$m] = chr($c0);
    }
    else{
        $c0 = $tmpArr[0];
        $op[$m] = chr($c0);
    }
    $rtnArr[0] = \@op;
    $rtnArr[1] = $m;
    return \@rtnArr;
}

#
# xx2dec, ibase=2, 3, 4, 5...62
sub _xx2dec($ $ $){
    my $self = $_[0];
    my $rtn = 0;
    my $inum = $_[1];
    my $ibase = $_[2];
    my %ridx = %{$_[3]}; 
    my $xtag = XTAG;
    if($ibase <= $max_safe_base){
        $rtn = $self->_baseFrom($inum, $ibase);
    }
    else{
        if($ibase > $base59 && $ibase < $xpos){
            my %ridx_in = ();
            for my $ri (keys %ridx){
                $ridx_in{$ri} = $ridx{$ri};
            }
            $ridx_in{'x'} = 59; $ridx_in{'y'} = 60; $ridx_in{'z'} = 61;
            %ridx = %ridx_in;
        } 
        my @inArr = split(//, $inum);
        @inArr = reverse(@inArr);
        my $arrSize = scalar @inArr;
        my $xnum = 0; my $tmpi = 0; my $isBase62x = ($ibase==$xpos);
        for($i=0; $i<$arrSize; $i++){
            if($isBase62x && defined($inArr[$i+1]) && $inArr[$i+1] eq $xtag){
                $tmpi = $bpos + $ridx{$inArr[$i]}; 
                $xnum++;
                $i++;
            }
            else{
                $tmpi = $ridx{$inArr[$i]};
            }
            if($tmpi >= $ibase){
                print "".$LOGTAG.": _xx2dec found out of radix:$tmpi for base:$ibase.\n";
                $tmpi = $ibase - 1;
            }
            $rtn = $rtn + $tmpi * ($ibase ** ($i - $xnum));
        }
    }
    #print "".$LOGTAG.": _xx2dec: innum:$inum ibase:$ibase rtn:$rtn\n";
    return $rtn;
}

#
# dec2xx, obase=2, 3, 4, 5...62
sub _dec2xx($ $ $){
    my $self = $_[0];
    my $rtn = 0;
    my $inum = $_[1];
    my $obase = $_[2];
    my @ridx = @{$_[3]}; 
    my $xtag = XTAG;
    if($obase <= $max_safe_base){
        $rtn = $self->_baseTo($inum, $obase);
    }
    else{
        my $isBase62x = 0;
        if($obase > $base59 && $obase < $xpos){
            my @idx_in = (); my $ri = 0; 
            foreach my $rv (@ridx){
                $idx_in[$ri++] = $rv;
            }
            $idx_in[59] = 'x'; $idx_in[60] = 'y'; $idx_in[61] = 'z';
            @ridx = @idx_in;
        }
        elsif($obase == $xpos){
            $isBase62x = 1;
        }
        my $maxPos = $bpos;
        if($isBase62x == 0){ $maxPos = $bpos + 1; } # cover all 0-61 chars
        
        $i = 0;
        my $b = 0; my @outArr = (); 
        do{
            $b = $inum % $obase;
            $inum = int($inum / $obase);
            if($b <= $maxPos){
                $outArr[$i++] = $ridx[$b];
            }
            else{
                $outArr[$i++] = $ridx[$b - $bpos];
                $outArr[$i++] = $xtag;
            }
        }
        while($inum >= $obase);
        $b = $inum;
        if($b > 0){
            if($b <= $maxPos){
                $outArr[$i++] = $ridx[$b];
            }
            else{
                $outArr[$i++] = $ridx[$b - $bpos];
                $outArr[$i++] = $xtag;
            }
        }
        @outArr = reverse(@outArr);
        $rtn = join('', @outArr);
    }
    #print "".$LOGTAG.": _dec2xx: innum:".$_[1]." obase:$obase rtn:$rtn\n";
    return $rtn;
}

#
sub _baseTo($ $){
    my($n,$b) = ($_[1], $_[2]);
    my $s = "";
    while ($n) {
        $s .= ('0'..'9','A'..'Z')[$n % $b];
        $n = int($n/$b);
    }
    return scalar(reverse($s));
}

#
sub _baseFrom($ $){
    my($n,$b) = ($_[1], $_[2]);
    my $t = 0;
    for my $c (split(//, uc($n))) {
        $t = $b * $t + index("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", $c);
    }
    return $t;
}

1;
