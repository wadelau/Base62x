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
# alpha, Sat Mar  9 04:41:44 GMT 2019

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
    LogTag = 'Base62x';
    isdebug = False; # True;

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
    # number conversion or string encoding
    def encode(self, rawstr, ibase=0):
        output = '';
        codetype = self.codetype;
        isNum = False;
        if ibase > 0:
            isNum = True;
        
        xtag = self.XTAG;
        isdebug = self.isdebug;
        try:
            # encode algrithms
            if isNum:
                # number conversion
                output = 0;

            else:
                # string encoding
                output = '';
                inputArr = bytearray(rawstr, self.UTF8Tag);
                inputLen = len(inputArr);
                asctype = self._setAscii(codetype, inputArr);
                bpos = self.bpos; b62x = self.b62x;
                if isdebug:
                    print("enc rawstr:[{}] inputArr:[{}] asctype:[{}]"
                        .format(rawstr, inputArr, asctype));

                op = []; i = 0; m = 0;    
                ixtag = ord(self.XTAG);
                ascidx = self.ascidx;
                if asctype == 1:
                    # ascii string
                    while i < inputLen:
                        if ascidx[inputArr[i]] != -1:
                            op.append(ixtag);
                            m += 1;
                            op.append(ord(ascidx[inputArr[i]]));
                        elif inputArr[i] == ixtag:
                            op.append(ixtag);
                            m += 1;
                            op.append(ixtag);
                        else:
                            #print("\ti:[{}] m:[{}] ib:[{}]".format(i, m, inputArr[i]));
                            op.append(inputArr[i]);

                        i += 1; m += 1;
                    
                    op.append(ixtag);
                    output = "".join(map(chr, op));

                else:
                    # non-ascii string
                    c0, c1, c2, c3, remaini = 0, 0, 0, 0, 0;
                    while i < inputLen:
                        remaini = inputLen - i;
                        # most cases first
                        if remaini > 2:
                            c0 = inputArr[i] >> 2;
                            c1 = (((inputArr[i] << 6) & 0xff) >> 2) | (inputArr[i+1] >> 4);
                            c2 = (((inputArr[i+1] << 4) & 0xff) >> 2) | (inputArr[i+2] >> 6);
                            c3 = ((inputArr[i+2] << 2) & 0xff) >> 2;
                            if c0 > bpos:
                                op.append(xtag); m += 1; op.append(b62x[c0]);
                            else:
                                op.append(b62x[c0]);
                            m += 1;
                            if c1 > bpos:
                                op.append(xtag); m += 1; op.append(b62x[c1]);
                            else:
                                op.append(b62x[c1]);
                            m += 1;
                            if c2 > bpos:
                                op.append(xtag); m += 1; op.append(b62x[c2]);
                            else:
                                op.append(b62x[c2]);
                            m += 1;
                            if c3 > bpos:
                                op.append(xtag); m += 1; op.append(b62x[c3]);
                            else:
                                op.append(b62x[c3]);

                            i += 2;

                        elif remaini == 2:
                            c0 = inputArr[i] >> 2;
                            c1 = (((inputArr[i] << 6) & 0xff) >> 2) | (inputArr[i+1] >> 4);
                            c2 = ((inputArr[i+1] << 4) & 0xff) >> 4;
                            if c0 > bpos:
                                op.append(xtag); m += 1; op.append(b62x[c0]);
                            else:
                                op.append(b62x[c0]);
                            m += 1;
                            if c1 > bpos:
                                op.append(xtag); m += 1; op.append(b62x[c1]);
                            else:
                                op.append(b62x[c1]);
                            m += 1;
                            if c2 > bpos:
                                op.append(xtag); m += 1; op.append(b62x[c2]);
                            else:
                                op.append(b62x[c2]);

                            i += 1;

                        elif remaini == 1:
                            c0 = inputArr[i] >> 2;
                            c1 = ((inputArr[i] << 6) & 0xff) >> 6;
                            if c0 > bpos:
                                op.append(xtag); m += 1; op.append(b62x[c0]);
                            else:
                                op.append(b62x[c0]);
                            m += 1;
                            if c1 > bpos:
                                op.append(xtag); m += 1; op.append(b62x[c1]);
                            else:
                                op.append(b62x[c1]);
                            
                        #print("\t\ti:[{}] v:[{}] op:[{}]".format(i, inputArr[i], op));
                        i += 1; m += 1;

                    output = "".join(op);

        except:
            print("Error with encode:[{}] ibase:[{}]".format(rawstr, ibase));
            traceback.print_exc(file=sys.stdout);
            pass;

        return output;

    # decode
    # number conversion or string decoding
    def decode(self, encstr, obase=0):
        output = '';
        self.codetype = 1; codetype = self.codetype;
        isNum = False;
        if obase > 0:
            isNum = True;

        xtag = self.XTAG;
        isdebug = self.isdebug;
        try:
            # decode algorithm
            if isNum:
                # number conversion
                output = 0;

            else:
                # string decoding
                output = '';
                inputArr = bytearray(encstr, self.UTF8Tag);
                inputLen = len(inputArr);
                asctype = self._setAscii(codetype, inputArr);
                bpos = self.bpos; ascrlist = self.ascrlist; rb62x = self.rb62x; 
                if isdebug:
                    print("dec rawstr:[{}] inputArr:[{}] asctype:[{}]"
                        .format(encstr, inputArr, asctype)); # , ascrlist, rb62x

                op = []; i = 0; m = 0;    
                ixtag = ord(self.XTAG);

                if asctype == 1:
                    # ascii string
                    inputLen -= 1; # remove last 'x'
                    while i < inputLen:
                        if inputArr[i] == ixtag:
                            if inputArr[i+1] == ixtag:
                                op.append(ixtag);
                                i += 1;
                            else:
                                #print("\ti:[{}] m:[{}] ib:[{}]".format(i, m, inputArr[i]));
                                i += 1;
                                op.append(ascrlist[chr(inputArr[i])]);
                        else:
                            op.append(inputArr[i]);

                        i += 1; m += 1;

                    output = "".join(map(chr, op));

                else:
                    # non-ascii string
                    tmpArr, tmpArr2 = [], []; remaini = 0; 
                    bint = [0, 1, 2, 3]; 
                    while i < inputLen:
                        tmpArr = []; tmpArr2 = [];
                        remaini = inputLen - i;
                        if remaini > 1:
                            j = 0;
                            while (j < 4 and i < inputLen):
                                if inputArr[i] == ixtag:
                                    i += 1;
                                    #print("\ti:[{}]/j:[{}] input:[{}]/[{}] tmpArr:[{}]"
                                    #    .format(i, j, inputArr[i], chr(inputArr[i]), tmpArr));
                                    tmpArr.append(bpos + bint[int(chr(inputArr[i]))]);
                                else:
                                    tmpArr.append(rb62x[chr(inputArr[i])]);
                                
                                #print("i:[{}]/j:[{}] input:[{}] tmpArr:[{}]".format(i, j, inputArr[i], tmpArr));
                                i += 1; j += 1;
							
                            tmpArr2 = self._decodeByLength(tmpArr);
                            for ia in tmpArr2:
                                op.append(ia);
            
                        elif remaini == 1:
                            print("{} found illegal input:[{}]. 1903091005. i:[{}]"
                                .format(self.LogTag, inputArr[i], i));
                            break;
                        
                        m += 1;
                    
                    #print("i:[{}]/m:[{}] op:[{}]".format(i, m, op));
                    op = str(bytes(op), self.UTF8Tag);
                    output = "".join(op);

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

    # decode by length
    def _decodeByLength(self, tmpArr):
        rtnArr = [];
        c0, c1, c2 = 0, 0, 0;
        arrLen = len(tmpArr);
        if arrLen == 4:
            c0 = tmpArr[0] << 2 | tmpArr[1] >> 4;
            c1 = ((tmpArr[1] << 4) & 0xf0) | (tmpArr[2] >> 2);
            c2 = ((tmpArr[2] << 6) & 0xff) | tmpArr[3];
            rtnArr.append(c0); rtnArr.append(c1); rtnArr.append(c2);   

        elif arrLen == 3:
            c0 = tmpArr[0] << 2 | tmpArr[1] >> 4;
            c1 = ((tmpArr[1] << 4) & 0xf0) | tmpArr[2];
            rtnArr.append(c0); rtnArr.append(c1); 

        elif arrLen == 2:
            c0 = tmpArr[0] << 2 | tmpArr[1];
            rtnArr.append(c0); 

        else:
           c0 = tmpArr[0]; 
           rtnArr.append(c0); 

        return rtnArr;

# end
