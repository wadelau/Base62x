
Base62x: An alternative approach to Base64 for only-alphanumeric [a-zA-Z0-9] characters in output.

Base62x is an non-symbolic Base64 encoding scheme. It can be used safely in computer file systems, programming languages for data exchange, internet communication systems, and is an ideal substitute and successor of many variants of Base64 encoding scheme.

Base62x 是一种无符号 [a-zA-Z0-9] 的Base64编码方案。

她可以在计算机文件系统、编程语言数据交换、互联网络通信系统中可以安全地使用，同时是各种变种Base64编码方案的理想替代品、继任者。

# Contents
[Base62x Usage](#Usage)

[Base62x Research Paper](#Paper)

[-Base62x in C](#c)

[-Base62x in -PHP](#php)

[-Base62x in -Java](#java)

[-Base62x in -JavaScript](#javascript)

[-Base62x in -Perl](#perl)

[-Base62x in -Python](#python)

[-Base62x in C++](#cpp)

[-Base62x in C#](#csharp)


# -Base62x
Base62x is an alternative approach to Base 64 without symbols in output.

![base62x](http://ufqi.com/blog/wp-content/uploads/2016/09/b62x-icon-201306.png)

### Compact, purified and even shorter!

[-Base62x](https://ufqi.com/naturedns/search?q=-base62x) . 

[-Base62x Online](https://ufqi.com/naturedns/search?q=-base62x)

<a name="Usage"></a>
# -Base62x Usage 

Base62x.encode(myString);

Base62x.decode(encodedString);

Base62x.encode(myString, inBase);

Base62x.decode(encodedString, outBase);

![base62x-design](http://ufqi.com/dev/base62x/Base62x-design-201702.v2.JPG)

<a name="Paper"></a>
# -Base62x Papers 

IEEE Article Number, 6020065 ;

[ -R/p2SK ](http://ufqi.com/naturedns/search?q=-r/C2TZ) , page url in [ -URL4P ](http://ufqi.com/naturedns/search?q=-url4p) .

[-Base62x in RearchGate, -R/12Sb ](http://ufqi.com/naturedns/search?q=-R/12Sb ) .

## Reference & Citation

```text
@article{Liu2011Base62x,
	title={Base62x: An alternative approach to Base64 for only-alphanumeric characters in output},
	author={Liu, Zhenxing and Liu, Lu and Hill, Richard and Zhan, Yongzhao},
	journal={2011 Eighth International Conference on Fuzzy Systems and Knowledge Discovery (FSKD)},
	year={2011},
	url={https://ieeexplore.ieee.org/document/6020065/}
}
```


<a name="c"></a>
# base62x.c 

## base62x.c

shell> gcc -lm base62x.c -o base62x

shell>./base62x

Usage: ./base62x [-v] [-n <2|8|10|16|32>] <-enc|dec> string

Version: 0.90
```shell
shell> mi=0; umi=0; for i in {1..10000}; \
	do \
	r=`cat /dev/urandom|tr -dc 'a-zA-Z0-9'|fold -w 16|head -n 1`; \
	r2=`cat /dev/urandom|tr -dc 'a-zA-Z0-9'|fold -w 16|head -n 1`; \
	a="$r中文时间a$r2"; b=`./base62x -enc $a`; c=`./base62x -dec $b`; \
	if [ "$a" == "$c" ]; then d="matched";mi=`expr $mi + 1`;\
	else d="unmatched"; umi=`expr $umi + 1`; fi;\
	echo -e "a=$a b="$b" c="$c" d="$d" mi="$mi" umi="$umi"\n"; \
	done
```

<a name="php"></a>
# Base62x in -PHP 

## base62x.class.php

## base62x_test.php

In base62x_test.php
```php
<?php

include("./base62x.class.php");

$s = "abcd1234";

$s2 = "abc中文123";

$s3 = "\"Tcler's Wiki: UTF-8 bit by bit (Revision 6)\". 2009-04-25. Retrieved 2009-05-22."
	."In orthodox UTF-8, a NUL byte (\\x00) is represented by a NUL byte. […] But […] we "
	."[…] want NUL bytes inside […] strings […] | ① ② ③ ④ ⑤ ⑥ ⑦ |  Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ | "
	."!  # $ % & ' ( ) * + , - . /";

print "[$s] encoded:[".($s_enc=Base62x::encode($s))."]\n";
print "[$s_enc] decoded:[".($s_dec=Base62x::decode($s_enc))."]\n";

print "\n[$s2] encoded:[".($s2_enc=Base62x::encode($s2))."]\n";
print "[$s2_enc] decoded:[".($s2_dec=Base62x::decode($s2_enc))."]\n";

print "\n[$s3] encoded:[".($s3_enc=Base62x::encode($s3))."]\n";
print "[$s3_enc] decoded:[".($s3_dec=Base62x::decode($s3_enc))."]\n";

?>
```

<a name="java"></a>
# Base62x in -Java 

## Base62x.class.jsp

## base62x_test.jsp

In base62x_test.jsp

```java
<%@page 
	import="java.util.Date,
		java.util.HashMap,
		java.util.Map,
		java.util.Iterator"
	language="java" 
	pageEncoding="UTF-8"%><%

//- system
System.setProperty("sun.jnu.encoding", "UTF-8");
System.setProperty("file.encoding", "UTF-8"); //- set " -Dfile.encoding=utf8 " in jvm start script

//- request
request.setCharacterEncoding("UTF-8");

//- response
response.setCharacterEncoding("utf-8");
response.setContentType("text/html;charset=utf-8");

%><%@include file="./Base62x.class.jsp"%><%

//- Test and examples of Base62x
//- Sun Aug 14 14:09:45 CST 2016
//- Wadelau@ufqi.com

String s = "abcd1234";
String s2 = "abc中文123";
String s3 = "\"Tcler's Wiki: UTF-8 bit by bit (Revision 6)\". 2009-04-25. Retrieved 2009-05-22."
	+ "In orthodox UTF-8, a NUL byte (\\x00)"
	+ "is represented by a NUL byte. […] But […] we […] want NUL bytes inside […] strings […] "
	+ "| ① ② ③ ④ ⑤ ⑥ ⑦ "
	+ "| Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ | ! # $ % & ' ( ) * + , - . /";

String s_enc, s_dec, s2_enc, s2_dec, s3_enc, s3_dec;

out.println("<br/>["+s+"] encoded:["+(s_enc=Base62x.encode(s))+"]");
out.println("<br/>["+s_enc+"] decoded:["+(s_dec=Base62x.decode(s_enc))+"]");

out.println("<br/>["+s2+"] encoded:["+(s2_enc=Base62x.encode(s2))+"]");
out.println("<br/>["+s2_enc+"] decoded:["+(s2_dec=Base62x.decode(s2_enc))+"]");

out.println("<br/>["+s3+"] encoded:["+(s3_enc=Base62x.encode(s3))+"]");
out.println("<br/>["+s3_enc+"] decoded:["+(s3_dec=Base62x.decode(s3_enc))+"]");

%>

```
It's an alternative option for -Base64 in -Java , [JDK Doc](https://docs.oracle.com/javase/10/docs/api/java/util/Base64.html) .

<a name="javascript"></a>
# Base62x in -JavaScript

## Base62x.class.js

## base62x_test.js.html

In base62x_test.js.html

```javascript
var randi = Math.ceil(Math.random()*10000);
var s = randi+'abcd'+(randi*randi)+'1234@'+(randi%2==0?'中國-文化-源遠流長'
	+randi+':：:':randi)+(new Date())+'@'+Math.ceil(Math.random()*100000);
var encs = Base62x.encode(s);
var decs = Base62x.decode(encs);

var inum = randi+'a'+1+randi+'fea'; var ibase = 16; var obase = 16;
var num_enc = Base62x.encode(inum, ibase);
var num_dec = Base62x.decode(num_enc, obase);
```

Play with npm,  
```javascript
npm install base62x
```
by https://github.com/beaulac/node-base62x 

<a name="perl"></a>
# Base62x in -Perl 

Base62x.pm

Usage: OOP Style
```perl
use Base62x;

my $base62x = Base62x->new();
my $str = “Hello World!\n”;
my $encoded = $base62x->encode($str);
$str = $base62x->decode($encoded);

# numbers conversion
my $i = 100;
    # treas $i as base 10 and transform it into Base62x
my $numInBase62x = $base62x->encode($i, 10);
    # try to decode a Base62x num into base 10
$i = $base62x->decode($numInBase62x, 10);

```
Usage: Functional Style
```perl
use Base62x qw (base62x_encode base62x_decode);

my $str = “Hello World!\n”;
my $encoded = base62x_encode($str);
$str = base62x_decode($encoded);
```


<a name="python"></a>
# Base62x in -Python 

Base62x.py

Usage: OOP style

```python

# import Base62x.py
from Base62x import Base62x

# initialize
base62x = Base62x();

rawstr = “abcd1234x’efg89;01”;
encstr = base62x.encode(rawstr);
decstr = base62x.decode(encstr);

```

Base62x_test.py

Test cases for Base62x in Python.


<a name="cpp"></a>
# Base62x in -cplusplus / C++ 

@todo

<a name="csharp"></a>
# Base62x in -csharp / C# 

@todo




