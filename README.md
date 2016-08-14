# -Base62x
Base62x is an alternative approach to Base 64 without symbols in output.

![base62x](https://ufqi.com/dev/base62x/b62x-icon-201306.png)

###Compact, purified and even shorter!

[-Base62x](https://ufqi.com/naturedns/search?q=-base62x) .

# -Base62x Paper in IEEE

Article Number, 6020065 ;

[-R/C2TZ](http://ufqi.com/naturedns/search?q=-r/C2TZ) , page url in [-URL4P](http://ufqi.com/naturedns/search?q=-url4p) .

# base62x.c

##base62x.c

shell> gcc -lm base62x.c -o base62x

shell>./base62x

Usage: ./base62x [-v] [-n <2|8|10|16|32>] <-enc|dec> string

Version: 0.70

shell>./base62x -enc "abc! \" # $ % & 中文chn"

OM9Z8I0Y82CW920b82OWvBYjvfQ7OsXk

shell>./base62x -dec "OM9Z8I0Y82CW920b82OWvBYjvfQ7OsXk"

abc! " # $ % & 中文chn

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
Output of base62x_test.php:

[abcd1234] encoded:[abcd1234x]

[abcd1234x] decoded:[abcd1234]

[abc中文123] encoded:[OM9ZvBYjvfQ7CJ8p]

[OM9ZvBYjvfQ7CJ8p] decoded:[abc中文123]

["Tcler's Wiki: UTF-8 bit by bit (Revision 6)". 2009-04-25. Retrieved 2009-05-22.In orthodox UTF-8, a NUL byte (\x00) is represented by a NUL byte. […] But […] we […] want NUL bytes inside […] strings […] | ① ② ③ ④ ⑤ ⑥ ⑦ |  Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ | !  # $ % & ' ( ) * + , - . /] encoded:[8bHZR6Lo9tCWLsbhQJeWLLH6BJWWOcbq869v869fT20eKcLsQNDfRsuWDYaYBY0oC30vBJ0qBJ8rBY1IPNHoQMLsPMGWCZ0mEIqmDIqoCYv9RY1lSdHeRsHlU21LL4OjE2mWOI1ELKmWOdbqPI0eN7WmC2aWQNCWScLmScLpPMvqPMGWOdaWOI1ELKmWOdbqPIuWMx2A0fbqWGdLq85lYWAPT87Tb85lYWAPT87TXRdGWJbLC869vT6Lp86bkSsbaPI1Rue2cNI1pT79fRcTp85lYWAPT87mWuf6W8EAHeI3YaQ8Wuf6Z8EAHf23YaQKWuf6c87mW8EA5e23YXQ4WueMY8EA5eo3YXQGWueMb8EA5fY3YXQSWueMe8EA5gI1z824W82CW920b82OW9o0e82aWAY0h82mWBI0k82F]

[8bHZR6Lo9tCWLsbhQJeWLLH6BJWWOcbq869v869fT20eKcLsQNDfRsuWDYaYBY0oC30vBJ0qBJ8rBY1IPNHoQMLsPMGWCZ0mEIqmDIqoCYv9RY1lSdHeRsHlU21LL4OjE2mWOI1ELKmWOdbqPI0eN7WmC2aWQNCWScLmScLpPMvqPMGWOdaWOI1ELKmWOdbqPIuWMx2A0fbqWGdLq85lYWAPT87Tb85lYWAPT87TXRdGWJbLC869vT6Lp86bkSsbaPI1Rue2cNI1pT79fRcTp85lYWAPT87mWuf6W8EAHeI3YaQ8Wuf6Z8EAHf23YaQKWuf6c87mW8EA5e23YXQ4WueMY8EA5eo3YXQGWueMb8EA5fY3YXQSWueMe8EA5gI1z824W82CW920b82OW9o0e82aWAY0h82mWBI0k82F] decoded:["Tcler's Wiki: UTF-8 bit by bit (Revision 6)". 2009-04-25. Retrieved 2009-05-22.In orthodox UTF-8, a NUL byte (\x00) is represented by a NUL byte. […] But […] we […] want NUL bytes inside […] strings […] | ① ② ③ ④ ⑤ ⑥ ⑦ |  Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ | !  # $ % & ' ( ) * + , - . /]

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
String s3 = "\"Tcler's Wiki: UTF-8 bit by bit (Revision 6)\". 2009-04-25. Retrieved 2009-05-22.In orthodox UTF-8, a NUL byte (\\x00)"
	+ "is represented by a NUL byte. […] But […] we […] want NUL bytes inside […] strings […] | ① ② ③ ④ ⑤ ⑥ ⑦ "
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

Output of base62x_test.jsp:

[abcd1234] encoded:[abcd1234x] 

[abcd1234x] decoded:[abcd1234] 

[abc中文123] encoded:[OM9ZvBYjvfQ7CJ8p] 

[OM9ZvBYjvfQ7CJ8p] decoded:[abc中文123] 

["Tcler's Wiki: UTF-8 bit by bit (Revision 6)". 2009-04-25. Retrieved 2009-05-22.In orthodox UTF-8, a NUL byte (\x00)is represented by a NUL byte. […] But […] we […] want NUL bytes inside […] strings […] | ① ② ③ ④ ⑤ ⑥ ⑦ | Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ | ! # $ % & ' ( ) * + , - . /] encoded:[8bHZR6Lo9tCWLsbhQJeWLLH6BJWWOcbq869v869fT20eKcLsQNDfRsuWDYaYBY0oC30vBJ0qBJ8rBY1IPNHoQMLsPMGWCZ0mEIqmDIqoCYv9RY1lSdHeRsHlU21LL4OjE2mWOI1ELKmWOdbqPI0eN7WmC2bfSo1oPN1oPNDbRdHbP21YUI1X84vLJ21YUNHbBY1Rue2cNI12TNGWMx2A0fbqWTsKWMx2A0fbqWTs5kT21ELKmWOdbqPNCWQMvpQMHb85lYWAPT87DqScbkPtCWMx2A0fbqWV23YaQ0Wuf6X8EAHeY3YaQCWuf6a8EAHfI3YaQOWV23YXQ0WueMX8EA5eY3YXQCWueMa8EA5fI3YXQOWueMd8EA5g23YXQaWV20X82CW920b82OW9o0e82aWAY0h82mWBI0k82F]

[8bHZR6Lo9tCWLsbhQJeWLLH6BJWWOcbq869v869fT20eKcLsQNDfRsuWDYaYBY0oC30vBJ0qBJ8rBY1IPNHoQMLsPMGWCZ0mEIqmDIqoCYv9RY1lSdHeRsHlU21LL4OjE2mWOI1ELKmWOdbqPI0eN7WmC2bfSo1oPN1oPNDbRdHbP21YUI1X84vLJ21YUNHbBY1Rue2cNI12TNGWMx2A0fbqWTsKWMx2A0fbqWTs5kT21ELKmWOdbqPNCWQMvpQMHb85lYWAPT87DqScbkPtCWMx2A0fbqWV23YaQ0Wuf6X8EAHeY3YaQCWuf6a8EAHfI3YaQOWV23YXQ0WueMX8EA5eY3YXQCWueMa8EA5fI3YXQOWueMd8EA5g23YXQaWV20X82CW920b82OW9o0e82aWAY0h82mWBI0k82F] decoded:["Tcler's Wiki: UTF-8 bit by bit (Revision 6)". 2009-04-25. Retrieved 2009-05-22.In orthodox UTF-8, a NUL byte (\x00)is represented by a NUL byte. […] But […] we […] want NUL bytes inside […] strings […] | ① ② ③ ④ ⑤ ⑥ ⑦ | Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ | ! # $ % & ' ( ) * + , - . /] 

Time:[Sun Aug 14 22:00:45 CST 2016] 515373

# Base62x in -Perl

@todo


