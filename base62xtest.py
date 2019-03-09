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

