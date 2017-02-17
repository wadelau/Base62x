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
s_enc = ""; s_dec = ""; s2_enc = ""; s2_dec = ""; s3_enc = ""; s3_dec = "";

/*
out.println("<br/>["+s+"] encoded:["+(s_enc=Base62x.encode(s))+"]");
out.println("<br/>["+s_enc+"] decoded:["+(s_dec=Base62x.decode(s_enc))+"]");

out.println("<br/>["+s2+"] encoded:["+(s2_enc=Base62x.encode(s2))+"]");
out.println("<br/>["+s2_enc+"] decoded:["+(s2_dec=Base62x.decode(s2_enc))+"]");

out.println("<br/>["+s3+"] encoded:["+(s3_enc=Base62x.encode(s3))+"]");
out.println("<br/>["+s3_enc+"] decoded:["+(s3_dec=Base62x.decode(s3_enc))+"]");
*/

out.println("<br/><br/>Time:["+(new Date())+"] "+((new java.util.Random()).nextInt(999999)));

java.util.Random rd = new java.util.Random();

int i = 0;
int succi = 0;
int succi2 = 0;
int faili = 0;
int faili2 = 0;
String s_enc2;
String s_dec2;
int xcount = 0;
int testcount = 3000;
for(i=0; i<testcount; i++){
    s = Integer.toHexString(rd.nextInt(999999999)) 
    	+ "中a3" + Integer.toHexString(rd.nextInt(9999999)) 
    	+ "鸿" + Integer.toHexString(rd.nextInt(9999999)) 
    	+ "发" + Integer.toHexString(rd.nextInt(9999999));// + String.valueOf((new byte[]{12, 25, 66, 2})); //; + "哈哈啊哈dbHSastrónomos chinos y árabes el 5 de HSGsjs_*&^" + rd.nextInt(9999999) + "*-8***Jd带回待会SJSJJAJJSJJsjsjsj((*&&&" +  rd.nextInt(9999999) + String.valueOf((new Byte((byte)61)));
    //s = (new byte[]{-112, 25, 66, -12}).toString();
    //s_enc = Base62x.encode(s);
    //s_dec = Base62x.decode("ax2x1"); //- s_enc
    s_enc = Base62x.encode(s); //  + ""; // "a1b2x1x2x3x1"; "a1b2x1";
    //out.println("<br/>s:["+s+"] s_enc:["+s_enc+"]");
    if(s_enc.indexOf("x") > -1){
    	xcount++;
    	//out.println("<br/> "+i+"/"+(xcount++)+" ---- s:["+s+"] s_enc:["+s_enc+"] found tag x.");
    }
    //s_enc = "yyx2x14Ex2x3lUx2x3lM543x1";
    s_dec = Base62x.decode(s_enc); //- s_enc
    
    s_enc2 = Base62x.encode(s_dec);

    s_dec2 = Base62x.decode(s_enc2);

    if(s.equals(s_dec)){
        succi++;
        //System.out.println("i:["+i+"] s:["+s+"] s_dec:["+s_dec+"] okay!");    
    }
    else{
        faili++;
        //System.out.println("i:["+i+"] s:["+s+"] s_dec:["+s_dec+"] error!");
    }
    if(s_enc.equals(s_enc2)){
        succi2++;
        //System.out.println("i:["+i+"] enc_s:["+s_enc+"] dec_s:["+s_dec+"] len:"+s.length()+" s_enc2:["+s_enc2+"] s_dec2:["
        //	+s_dec2+"] len:["+s_dec2.length()+"] succ2!");
    }
    else{
        faili2++;
        System.out.println("i:["+i+"] enc_s:["+s_enc+"] dec_s:["+s_dec+"] len:"+s.length()+" s_enc2:["+s_enc2+"] s_dec2:["+s_dec2
        	+"] len:"+s_dec2.length()+" error2!");
    }
    if(s_dec.equals(s_dec2)){
        succi2++;
        //System.out.println("i:["+i+"] enc_s:["+s_enc+"] dec_s:["+s_dec+"] len:"+s.length()+" s_enc2:["+s_enc2+"] s_dec2:["
        //	+s_dec2+"] len:["+s_dec2.length()+"] succ3!");
    }
    else{
        faili2++;
        System.out.println("i:["+i+"] enc_s:["+s_enc+"] dec_s:["+s_dec+"] len:"+s.length()+" s_enc2:["+s_enc2+"] s_dec2:["+s_dec2
        	+"] len:"+s_dec2.length()+" error3!");
    }
    if(i%1000 == 0){
        System.out.println((new java.util.Date())+": "+"i:["+i+"] s:["+s+"] s_dec:["+s_dec+"] s_enc:["+s_enc+"] go!");
        out.println((new java.util.Date())+": "+"i:["+i+"]<br/>");
    }
}

System.out.println("i:["+i+"] succi:["+succi+"] faili:["+faili+"] done! xcount:["+xcount+"] perc:["+(xcount/testcount)+"]");
System.out.println("i:["+i+"] succi2:["+succi2+"] faili:["+faili2+"] done!");

byte[] bytearr = new byte[4];
for(i=0; i<bytearr.length; i++){
	out.println("i:"+i+" v:"+bytearr[i]);	
}

int ibase = 16; int obase = 16;
String randi = rd.nextInt(1000)+"ab"+rd.nextInt(10000);
s_enc = Base62x.encode(randi, ibase);
s_dec = Base62x.decode(s_enc, obase);
out.println("<br/>Number conversion:<br/>randi: ["+randi+"], encns:["+s_enc+"]<br/>decns:["+s_dec+"]");

%>
