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

import sys, traceback, time
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
    UTF8Tag = 'utf-8';
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
        #print("rb62x:{}".format(self.rb62x));
        return None;


    # public methods
    # encode
    def encode(self, rawstr, ibase=0):
        output = '';
        codetype = self.codetype;
        isNum = False;
        if ibase > 0:
            isNum = True;
        
        xtag = self.XTAG;
        try:
            # algrithms
            if isNum:
                # number conversion
                output = 0;

            else:
                # string encoding
                output = '';
                inputArr = bytearray(rawstr, self.UTF8Tag);
                inputLen = len(inputArr);
                asctype = self._setAscii(codetype, inputArr);
                print("enc rawstr:[{}] inputArr:[{}] asctype:[{}]"
                    .format(rawstr, inputArr, asctype));

                for ib in inputArr:
                    print("ib:[{}]".format(ib));

                op = []; i = 0; m = 0;    
                ixtag = ord(self.XTAG);
                ascidx = self.ascidx;
                if asctype == 1:
                    # ascii string
                    while i < inputLen:
                        if ascidx[inputArr[i]] != -1:
                            op.append(xtag);
                            m += 1;
                            op.append(ascidx[inputArr[i]]);
                        elif inputArr[i] == ixtag:
                            op.append(xtag);
                            m += 1;
                            op.append(xtag);
                        else:
                            print("\ti:[{}] m:[{}] ib:[{}]".format(i, m, inputArr[i]));
                            op.append(inputArr[i]);

                        i += 1;
                        m += 1;
                    
                    op.append(ixtag);

                else:
                    # non-ascii string
                    c0, c1, c2, c3, remaini = 0, 0, 0, 0, 0;

                print("\top:[{}] join:[{}]".format(op, op));
                output = "".join(map(chr, op));

        except:
            print("Error with encode:[{}] ibase:[{}]".format(rawstr, ibase));
            traceback.print_exc(file=sys.stdout);
            pass;

        return output;

    # decode
    def decode(self, encstr, obase):
        output = 0;
        self.codetype = 1; codetype = self.codetype;
        try:
            # algorithm
            output = '';

        except:
            print("Error with decode:[{}] obase:[{}]".format(encstr, obase));
            traceback.print_exc(file=sys.stdout);
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

    # setAscii
    def _setAscii(self, codetype, inputArr):
        asctype = 0;
        inputLen = len(inputArr);
        ascmax = self.ascmax;
        if codetype == 0 and inputArr[0] <= ascmax:
            asctype = 1;
            for i in range(inputLen):
                tmpi = inputArr[i];
                if tmpi > ascmax or (tmpi > 16 and tmpi < 21) or (tmpi > 27 and tmpi < 32):
                    asctype = 0;
                    break;
        elif codetype == 1 and inputArr[inputLen - 1] == ord(self.XTAG):
            asctype = 1;

        if asctype == 1:
            idxLen = len(self.ascidx);
            if idxLen < 1:
                self._fillAscRlist();

        return asctype;

    # fillAscRlist
    def _fillAscRlist(self):
        rtn = 0;
        ascidx = self.ascidx;
        ascmax = self.ascmax;
        asclist = self.asclist;
        ascrlist = self.ascrlist;
        for i in range(ascmax):
            ascidx[i] = -1;
        
        idxi = 0;
        bgnArr = [0, 21, 32, 58, 91, 123];
        endArr = [17, 28, 48, 65, 97, ascmax+1];
        ascLen = len(bgnArr);
        for i in range(ascLen):
            bgn = bgnArr[i];
            end = endArr[i];
            for j in range(bgn, end):
                #print("\tbgn:[{}] end:[{}] i:[{}] j:[{}]".format(bgn, end, i, j));
                ascidx[j] = asclist[idxi];
                ascrlist[asclist[idxi]] = j;
                idxi += 1;

        self.ascidx = ascidx;
        self.ascrlist = ascrlist;

        return rtn;

# end
