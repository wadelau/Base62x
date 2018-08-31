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
use Encode qw(decode_utf8 encode_utf8);
use autodie;

use utf8;
no warnings 'utf8';
binmode( STDIN,  ':encoding(utf8)' );
binmode( STDOUT, ':encoding(utf8)' );
binmode( STDERR, ':encoding(utf8)' );

#use MIME::Base62x;
use Base62x;

my $mydir = dirname(abs_path($0));
my $basename = basename($0,(".pl"));

my $base62x = Base62x->new(); # \@ARGV 

print "workdir:$mydir self:$basename base62x:$base62x\n";

