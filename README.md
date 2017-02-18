# -Base62x
Base62x is an alternative approach to Base 64 without symbols in output.

![base62x](http://ufqi.com/blog/wp-content/uploads/2016/09/b62x-icon-201306.png)

###Compact, purified and even shorter!

[-Base62x](https://ufqi.com/naturedns/search?q=-base62x) . [-Base62x Online](https://ufqi.com/naturedns/search?q=-base62x)

# -Base62x Usage

Base62x.encode(myString);

Base62x.decode(encodedString);

Base62x.encode(myString, inBase);

Base62x.decode(encodedString, outBase);


# -Base62x Paper in IEEE

Article Number, 6020065 ;

[-R/C2TZ](http://ufqi.com/naturedns/search?q=-r/C2TZ) , page url in [-URL4P](http://ufqi.com/naturedns/search?q=-url4p) .

# base62x.c

##base62x.c

shell> gcc -lm base62x.c -o base62x

shell>./base62x

Usage: ./base62x [-v] [-n <2|8|10|16|32>] <-enc|dec> string

Version: 0.90

shell> mi=0; umi=0; for i in {1..10000}; do r=`cat /dev/urandom|tr -dc 'a-zA-Z0-9'|fold -w 16|head -n 1`; r2=`cat /dev/urandom|tr -dc 'a-zA-Z0-9'|fold -w 16|head -n 1`; a="$r中文时间a$r2"; b=`./base62x -enc $a`; c=`./base62x -dec $b`; if [ "$a" == "$c" ]; then d="matched";mi=`expr $mi + 1`;else d="unmatched"; umi=`expr $umi + 1`; fi; echo -e "a=$a b="$b" c="$c" d="$d" mi="$mi" umi="$umi"\n"; done


# Base62x in -PHP

##base62x.class.php

##base62x_test.php

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

# Base62x in -Java

##Base62x.class.jsp

##base62x_test.jsp

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

out.println("<br/><br/>Time:["+(new Date())+"] "+((new java.util.Random()).nextInt(999999)));

%>
```

# Base62x in -JavaScript

## Base62x.class.js

## base62x_test.js.html

in base62x_test.js.html

```javascript
var randi = Math.ceil(Math.random()*10000);
var s = randi+'abcd'+(randi*randi)+'1234@'+(randi%2==0?'中國-文化-源遠流長'+randi+':：:':randi)+(new Date())+'@'+Math.ceil(Math.random()*100000);
var encs = Base62x.encode(s);
var decs = Base62x.decode(encs);

var inum = randi+'a'+1+randi+'fea'; var ibase = 16; var obase = 16;
var num_enc = Base62x.encode(inum, ibase);
var num_dec = Base62x.decode(num_enc, obase);
```

# Base62x in -Perl

@todo


