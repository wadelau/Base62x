#!/usr/bin/python3 
#-*- coding: utf-8 -*-

# -Base62x in -Python, testing

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
import random

# self define modules
sys.path.append("./") # pay attention!

from Base62x import Base62x 

config = {};
base62x = Base62x(config);
#base62x2 = Base62x();

rawstr = "abcd1234x'efg89;01";
rawstr = 'var _tkd = _tkd || []; //点击量统计用';
rawstr2 = "abcd中文1234北京456;7-890";

encstr = base62x.encode(rawstr);
encstr2 = base62x.encode(rawstr2);

decstr = base62x.decode(encstr);
decstr2 = base62x.decode(encstr2);

print("rawstr:[{}] encstr:[{}] decstr:[{}] eq:[{}]".format(rawstr, encstr, decstr, (rawstr==decstr)));
print("2nd rawstr:[{}] encstr:[{}] decstr:[{}] eq:[{}]".format(rawstr2, encstr2, decstr2, (rawstr2==decstr2)));


a = 101010;
for i in range(2, 37):
    b = int(str(a), i);
    #print("i:{} b:{:02x} b10:{} a:{}".format(i, b, b, a));

ibase = 60; succc = 0; failc = 0; num = 0;
while num < 10000000:
    for ibase in range(10, 61):
        a = num;
        encstr = base62x.encode(a, ibase);
        decstr = base62x.decode(encstr, ibase);
        if str(a) == str(decstr):
            succc += 1;
        else:
            failc += 1;
        print("ibase:{} a:{} encstr:{} decstr:{} eq:{} succ:{} fail:{}".format(ibase, a, encstr, decstr, (str(a)==str(decstr)), succc, failc));

    randi = random.randint(0, 10000);
    num += randi;

ibase = 16;
encstr = base62x.encode(a, ibase);
decstr = base62x.decode(encstr, ibase);
print("ibase:{} a:{} encstr:{} decstr:{}".format(ibase, a, encstr, decstr));
