#!/usr/bin/perl -w

# see desc at the bottom
# invoke by cli:
# /path/to/perl -w /path/to/index.pl "?mod=hello&act=say&fmt=json"
# or
# ./index.pl "?mod=hello&act=say&fmt=json"

use lib '../'; # @todo
use lib './';

use strict;
use Cwd qw(abs_path realpath);
use File::Basename qw(dirname basename);
use Time::HiRes qw(sleep time);
use Fcntl qw(:flock);
use POSIX qw(strftime);
#use Encode qw(decode_utf8 encode_utf8);
#use autodie;

use utf8;
no warnings 'utf8';
binmode( STDIN,  ':encoding(utf8)' );
binmode( STDOUT, ':encoding(utf8)' );
binmode( STDERR, ':encoding(utf8)' );

#use MIME::Base62x;
#use Base62x;
use Base62x qw(base62x_encode base62x_decode);

my $mydir = dirname(abs_path($0));
my $basename = basename($0,(".pl"));

my $base62x = Base62x->new(); # \@ARGV 

print "workdir:$mydir self:$basename base62x:$base62x\n";

my $s = "中abc文123-"; # "This is a page for -Base62x. / 这里是 -Base62x . @2018-09-03-10:44:37+0100";
my $enc = $base62x->encode($s);
#$enc = "L6XfSo1fSo1X871XPsKWPcx1o82r2ONDbDZ9uBY0l8EYx3cUc7ZEQOho0jGc5pPJOoU20k840oC34uBJ0vBJ0qBJ0uEZKtEZKuAp0nC30A2aXlRcLpT7aWOMva86HfR6bdPMvZPI1pQ6x1rR6GWOcKWUMx1rSY1bT6LoRc5i86rXT6LpBY0jBKPoOMvhR6bk82zWwAx2QvQwUvBYEvOkavOk9vRgKwAx2bveYGvBYwvBsWvh2uvBc5vvg4vBoqvBwZuu228EA0bEA0bEMlZEM5iEM5Yx2QUb3";
my $dec = $base62x->decode($enc);
my $dec2 = base62x_decode($enc);
print "orig-s:[$s]\n\tenc:[$enc]\n\tdec:[$dec]\n\tdec2:[$dec2] eq:[".($dec eq $s)."] eq2:[".($dec2 eq $s)."]\n---- ---- ----\n";

$s = "onclick=\"javascript:parent.成功移植</a></h4></div>";
$enc = $base62x->encode($s);
my $enc2 = base62x_encode($s);
$dec = $base62x->decode($enc2);
print "orig-s:[$s]\n\tenc:[$enc]\n\tenc2:[$enc2]\n\tdec:[$dec] eq:[".($dec eq $s)."] \n---- ---- ----\n";

$s = "onclick=\"javascript:parent.</a></h4></div>";
$enc = $base62x->encode($s);
$dec = $base62x->decode($enc);
print "orig-s:[$s]\n\tenc:[$enc]\n\tdec:[$dec] eq:[".($dec eq $s)."] \n---- ---- ----\n";

$s = "[2016-09-12 18:24:56] Stas || OfferSeven: conversions";
$enc = $base62x->encode($s);
$dec = $base62x->decode($enc);
print "orig-s:[$s]\n\tenc:[$enc]\n\tdec:[$dec] eq:[".($dec eq $s)."]  \n---- ---- ----\n";

$s = "Добро пожаловать в Википедию,";
$enc = $base62x->encode($s);
$dec = $base62x->decode($enc);
print "orig-s:[$s]\n\tenc:[$enc]\n\tdec:[$dec] eq:[".($dec eq $s)."]  \n---- ---- ----\n";

$s = "ABC 1F 10 100 FF11 10000 F21E F1D2"; my $xbase=16;
my @arr = split(/ /, $s); my $matchi = 0; my $unmatchi = 0;
foreach $xbase ((16, 32, 61, 60)){
    foreach $s (@arr){
    $enc = $base62x->encode($s, $xbase);
    $dec = $base62x->decode($enc, $xbase);
    if($dec eq $s){ $matchi++; }else{ $unmatchi++; }
    print "xbase:$xbase orig-s:[$s]\n\tenc:[$enc]\n\tdec:[$dec] eq:[".($dec eq $s)."] matchi:$matchi unmatchi:$unmatchi \n---- ---- ----\n";
    }
}

$s = "F2zzyx F1xzyz ABCZYy"; my $xbase=62;
@arr = split(/ /, $s);
foreach $s (@arr){
    $enc = $base62x->encode($s, $xbase);
    $dec = $base62x->decode($enc, $xbase);
    if($dec eq $s){ $matchi++; }else{ $unmatchi++; }
    print "xbase:$xbase orig-s:[$s]\n\tenc:[$enc]\n\tdec:[$dec] eq:[".($dec eq $s)."] matchi:$matchi unmatchi:$unmatchi \n---- ---- ----\n";
}

