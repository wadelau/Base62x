#!/usr/bin/perl -w

=pod

* -Base62x in -Perl
* Wadelau@ufqi.com
* Refers to 
*    http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=6020065
*    -GitHub-Wadelau , base62x.c
*    https://github.com/wadelau/Base62x
*    https://ufqi.com/dev/base62x/?_via=-naturedns
* Tue Aug  9 21:18:14 CST 2016
* bugfix, 13:39 13 September 2016
* bugfix, Thu Sep 29 04:06:26 UTC 2016
* imprvs on numeric conversion, Fri Oct  7 03:42:59 UTC 2016
* bugifx by _decodeByLength, 20:40 28 November 2016
* Base62x in Perl, Thu Aug 30 20:49:27 CST 2018

=cut

#package MIME::Base62x;
package Base62x;

use strict;
use warnings;
use vars qw(@ISA @EXPORT $VERSION);

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(encode_base62x decode_base62x);
#use POSIX qw(strftime);
#use Date::Parse qw(str2time);
#my $thedate = POSIX::strftime("%Y-%m-%d", gmtime()); 
#my $thedate_nodash = POSIX::strftime("%Y%m%d", gmtime()); 
my $VERSION = '1.0';

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
    if($argc > 1){
        print "args:[$args] length:$argc 0:$class 1:".$args[0]." 2:".$args[1]."\n";
    }
    elsif(defined($args)){
        print "args:[$args] length:$argc\n";
    }
	return $self;
}

#
# OOP style
sub encode($ $){
    my $self = $_[0]; # shift
    my $rtn = 0;

    return $rtn;
}

#
sub decode($){
    my $self = $_[0]; # shift
    my $rtn = 0;

    return $rtn;
}

#
# functional style
sub encode_base62x($ $){
    my $rtn = 0;

    return $rtn;
}

#
sub decode_base62x($){
    my $rtn = 0;

    return $rtn;
}

#
sub _privateMethod(){
    my $rtn = 0;
    return $rtn;
}

1;
