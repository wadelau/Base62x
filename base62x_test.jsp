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
