#!/usr/bin/python3 
#-*- coding: utf-8 -*-

# -Base62x in -Python
# import from Base62x in Perl.

# Wadelau@{ufqi,gmail,hotmail}.com
# Refers to 
#    http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=6020065
#    -GitHub-Wadelau , base62x.c
#    https://github.com/wadelau/Base62x
#    https://ufqi.com/dev/base62x/?_via=-naturedns
# since  Mon Mar  4 08:28:16 GMT 2019

import sys
import time
from datetime import date, datetime
import logging as logx

# self define modules
sys.path.append("./") # pay attention!

#
class Base62x:
    
    # global variables

    # constants
    VER = 1.0;
    XTAG = 'x';
    isdebug = True;

    bpos, xpos, ascmax, max_safe_base = 60, 64, 126, 36;

    codetype = 0; # 0 for enc, 1 for dec

    # 0-60 chars, b62x[64] = 'x'
    b62x = ['0','1','2','3','4','5','6','7','8','9',
            'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
            'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
            'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
            'q','r','s','t','u','v','w','y','z','1','2','3','x'];
    asclist = ['4','5','6','7','8','9', '0',
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
        'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
        'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
        'q','r','s','t','u','v','w','y','z']; # 58
    #rb62x, ascidx, ascrlist = {}, {}, {};

    # constructor
    def __init__(self, argv={}):
        # do something
        self.argv = argv; # no args?
        self.rb62x = {}; self.ascidx = {}; self.ascrlist = {};
        self._fillRb62x();
        print("rb62x:{}".format(self.rb62x));
        return None;


    # public methods
    # encode
    def encode(self, rawstr, ibase=0):
        output = '';
        codetype = self.codetype;
        isNum = False;
        if ibase > 0:
            isNum = True;
        
        try:
            # number algrithm
            if isNum:
                output = 0;
                # number conversion
            else:
                output = '';
                # string encoding

        except:
            print("Error with encode:[{}] ibase:[{}]".format(rawstr, ibase));
            pass;

        return output;

    # decode
    def decode(self, encstr, obase):
        output = 0;
        try:
            # algorithm
            output = '';

        except:
            print("Error with decode:[{}] obase:[{}]".format(encstr, obase));
            pass;
        
        return output;


    # private methods
    # _fillRb62x
    def _fillRb62x(self):
       rtn = 0;
       for i in range(0, self.xpos):
           if i > self.bpos:
               # skip
               j = 0;
           else:
               self.rb62x[self.b62x[i]] = i;

       return rtn;


