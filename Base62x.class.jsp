<%
/*
 * -Base62x in -Java
 * Wadelau@{ufqi, gmail, hotmail}.com
 * Refers to 
	 http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=6020065
	 -GitHub-Wadelau , base62x.c
	 https://github.com/wadelau/Base62x
	 https://ufqi.com/dev/base62x/?_via=-naturedns
 *  Wed Aug 10 22:16:24 CST 2016
 *  Sat Aug 13 10:48:52 CST 2016
 *  bugfix by decodeByLength, Sat Dec  3 23:05:58 CST 2016
 *  imprvs with decode, Mon Mar 11 04:12:02 UTC 2019
 *  bugfox for number conversion with base 60+, Sun Apr  7 02:56:09 BST 2019
 *  bugfix for input.length==1, 09:13 Sunday, July 28, 2019 
 */
 //- Assume We Are in Charset of UTF-8 Runtime

%><%@page 
	import="java.util.Date,
		java.util.HashMap,
		java.util.Map,
		java.util.Iterator,
		java.util.Date"
	language="java" 
	pageEncoding="UTF-8"%><%
%><%!
 
public static final class Base62x{

	//- variables
	private boolean isdebug = false;
	private int i = 0;
	private int codetype = 0; //- 0:encode, 1:decode
	private static final byte xtag = 'x';

	private static final String encd = "-enc";
	private static final String decd = "-dec";
	private static final String debg = "-v";
	private static final String cntv = "-n"; //- numeric conversion

	private static final byte[] b62x = {'0','1','2','3','4','5','6','7','8','9',
		'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
		'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
		'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
		'q','r','s','t','u','v','w','y','z','1','2','3','x'};

	private static final int bpos = 60; //- 0-60 chars
	private static final int xpos = 64; //- b62x[64] = 'x'
	private int[] rb62x = new int[]{};

	private static final int ascmax = 127;
	private static final byte[] asclist = {'4','5','6','7','8','9', '0',
		'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
		'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
		'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
		'q','r','s','t','u','v','w','y','z'};

	private static int[] ascidx = new int[ascmax + 1];
	private static byte[] ascrlist = new byte[ascmax + 1];
	private static final int max_safe_base = 36; //- 17:56 14 February 2017
	private static final double ver = 0.90; //- Sun Apr  7 02:56:25 BST 2019
    private static final int base59 = 59;

	//- contructors
	//- @todo

	//- methods

	//- encode, ibase=2,8,10,16,32...63
	public static String encode(String input, int ibase){
		
		StringBuffer osb = new StringBuffer();
		if(input == null || input.equals("")){
			return osb.toString();	
		}

		int codetype = 0;
		byte xtag = Base62x.xtag;
		byte[] b62x = Base62x.b62x;
		byte[] asclist = Base62x.asclist;
		int bpos = Base62x.bpos;
		int xpos = Base62x.xpos;
		int ascmax = Base62x.ascmax;

		try{
			//- main enc logic
		int[] rb62x = Base62x.fillRb62x(b62x, bpos, xpos);
		boolean isnum = false;
		if(ibase > 0){ isnum = true; }
		
		if(isnum){
			//- numeric conversion
			long num_input = Base62x.xx2dec(input, ibase, rb62x);
			int obase = xpos;
			osb.append(Base62x.dec2xx(num_input, obase, b62x));
		}
		else{
			//- string encoding	
			boolean isasc = false;	
			byte[] inputArr = input.getBytes(); // new byte[]{-112, 25, 66, -12}; //StandardCharsets.UTF_8
			int inputlen = inputArr.length;
			HashMap setResult = Base62x.setAscii(codetype, inputArr, ascidx, ascmax, asclist, ascrlist);
			isasc = (boolean)setResult.get("isasc");
			ascidx = (int[])setResult.get("ascidx");
			ascrlist = (byte[])setResult.get("ascrlist");

			byte[] op = new byte[inputlen*2+1]; //- extend to 3/2 or 2 theoritical maxium length of base62x 
			int i=0; int m=0;

			if(isasc){
				//- ascii	
				byte b = 0;
				do{
					b = inputArr[i];
					if(ascidx[b] > -1){
						op[m] = xtag; op[++m] = (byte)ascidx[b];
					}
					else if(b == xtag){
						op[m] = xtag; op[++m] = xtag;
					}
					else{
						op[m] = b;	
					}
					m++;
				}
				while(++i < inputlen);
				op[m++] = xtag; //- asctype has a tag 'x' appended
			}
			else{
				//- non-ascii
				int c0=0; int c1=0;	int c2=0; int c3=0; i=0;
				int remaini = 0; int tmpi = 0; int tmpj = 0; int tmpk = 0;
				do{
					remaini = inputlen - i;
					tmpi = (int)inputArr[i]; tmpi = tmpi<0 ? (tmpi & 0xff) : tmpi; //- for minus byte	
					if(remaini > 2){
						tmpj = (int)inputArr[i+1];	tmpj = tmpj<0 ? (tmpj & 0xff) : tmpj;	
						tmpk = (int)inputArr[i+2];	tmpk = tmpk<0 ? (tmpk & 0xff) : tmpk;		
						c0 = tmpi >> 2;
						c1 = (((tmpi << 6) & 0xff) >> 2) | (tmpj >> 4);
						c2 = (((tmpj << 4) & 0xff) >> 2) | (tmpk >> 6);
						c3 = ((tmpk << 2) & 0xff) >> 2;
						if(c0>bpos){ op[m]=xtag; op[++m]=b62x[c0]; }
						else{ op[m]=b62x[c0]; }
						if(c1>bpos){ op[++m]=xtag; op[++m]=b62x[c1]; }
						else{ op[++m]=b62x[c1]; }
						if(c2>bpos){ op[++m]=xtag; op[++m]=b62x[c2]; }
						else{ op[++m]=b62x[c2]; }
						if(c3>bpos){ op[++m]=xtag; op[++m]=b62x[c3]; }
						else{ op[++m]=b62x[c3]; }
						i += 2;	
					}
					else if(remaini == 2){
						tmpj = (int)inputArr[i+1];	tmpj = tmpj<0 ? (tmpj & 0xff) : tmpj;	
						c0 = tmpi >> 2;
						c1 = (((tmpi << 6) & 0xff) >> 2) | (tmpj >> 4);
						c2 = ((tmpj << 4) & 0xff) >> 4;
						if(c0>bpos){ op[m]=xtag; op[++m]=b62x[c0]; }
						else{ op[m]=b62x[c0]; }
						if(c1>bpos){ op[++m]=xtag; op[++m]=b62x[c1]; }
						else{ op[++m]=b62x[c1]; }
						if(c2>bpos){ op[++m]=xtag; op[++m]=b62x[c2]; }
						else{ op[++m]=b62x[c2]; }
						i += 1;	
					}
					else{ //- == 1
						c0 = tmpi >> 2;
						c1 = ((tmpi << 6) & 0xff) >> 6;
						if(c0>bpos){ op[m]=xtag; op[++m]=b62x[c0]; }
						else{ op[m]=b62x[c0]; }
						if(c1>bpos){ op[++m]=xtag; op[++m]=b62x[c1]; }
						else{ op[++m]=b62x[c1]; }
					}
					m++;
				}
				while(++i < inputlen);
			}
			byte[] op2 = new byte[m];
			System.arraycopy(op, 0, op2, 0, m);	
			osb.append(new String(op2));
		}
			//- main enc logic, end
		}
		catch(Exception ex0727){
			ex0727.printStackTrace();
		}
		return osb.toString();

	}

	//- decode, obase=2,8,10,16,32...63
	public static String decode(String input, int obase){
	
		StringBuffer osb = new StringBuffer();
		if(input == null || input.equals("")){
			return osb.toString();	
		}

		int codetype = 1;
		byte xtag = Base62x.xtag;
		byte[] b62x = Base62x.b62x;
		byte[] asclist = Base62x.asclist;
		int bpos = Base62x.bpos;
		int xpos = Base62x.xpos;
		int ascmax = Base62x.ascmax;

		try{
			//- main dec logic
		int[] rb62x = Base62x.fillRb62x(b62x, bpos, xpos);
		boolean isnum = false;
		if(obase > 0){ isnum = true; }
		
		if(isnum){
			//- numeric conversion
			int ibase = xpos;
			long num_input = Base62x.xx2dec(input, ibase, rb62x);
			osb.append(Base62x.dec2xx(num_input, obase, b62x));
			//-  why a mediate number format is needed?
		}
		else{
			//- string decoding	
			boolean isasc = false;	
			byte[] inputArr = input.getBytes();
			int inputlen = inputArr.length;
			HashMap setResult = Base62x.setAscii(codetype, inputArr, ascidx, ascmax, asclist, ascrlist);
			isasc = (boolean)setResult.get("isasc");
			ascidx = (int[])setResult.get("ascidx");
			ascrlist = (byte[])setResult.get("ascrlist");

			byte[] op = new byte[inputlen]; //- shrink to 2/3 or 1/2 in maxium 
			int i=0; int m=0; 

			if(isasc){
				//- ascii string
				byte b = 0;
				inputlen--;
				do{
					b = inputArr[i];
					if(b == xtag){
						if(inputArr[i+1] == xtag){
							op[m] = xtag;
							i++;	
						}
						else{
							op[m] = ascrlist[inputArr[++i]];	
						}
					}
					else{
						op[m] = b;	
					}
					m++;
				}
				while(++i < inputlen);
			}
			else{
				//- non-ascii string
				int c0=0; int c1=0;	int c2=0;
				int remaini = 0; int j = 0; HashMap tmphm = new HashMap();
				int[] tmpArr = new int[]{-1, -1, -1, -1}; //- expected range 0 ~ 63
				int[] bint = new int[xpos]; bint[49]=1; bint[50]=2; bint[51]=3; //- array('1'=>1, '2'=>2, '3'=>3);
				do{
					remaini = inputlen - i;
					tmpArr = new int[]{-1, -1, -1, -1}; 
					if(remaini > 1){
						j = 0;
						do{
							if(inputArr[i] == xtag){
								i++;
								tmpArr[j] = bpos + bint[inputArr[i]];
							}
							else{
								tmpArr[j] = rb62x[inputArr[i]];
							}
							i++; j++;
						}
						while(j < 4 && i < inputlen);
							
						tmphm = Base62x._decodeByLength(tmpArr, op, m);
						op = (byte[])tmphm.get(0);
						m = (int)tmphm.get(1); //- deprecated.
					}
					else{ //- == 1
						System.out.println("Base62x.decode: illegal base62x input:["+input+"]. 1608091042.");
                        i++;
						continue;
					}
					m++;
				}
				while(i < inputlen);				
			}
			byte[] op2 = new byte[m];
			System.arraycopy(op, 0, op2, 0, m);	
			osb.append(new String(op2)); //, StandardCharsets.UTF_8
		}
			//- main dec logic, end
		}
		catch(Exception ex072721){
			ex072721.printStackTrace();
		}
		return osb.toString();
	
	}

	//- encode in default
	public static String encode(String input){
		
		return encode(input, 0);

	}

	//- decode in default
	public static String decode(String input){
		
		return decode(input, 0);

	}

	//- inner facilites
	//-
	private static int[] fillRb62x(byte[] b62x, int bpos, int xpos){
		int[] rb62x = new int[xpos*2]; //{};
		for(int i=0; i<=xpos; i++){
			if(i > bpos && i < xpos){
				//- omit x1, x2, x3	
			}
			else{
				rb62x[b62x[i]] = i;	
			}
		}
		return rb62x;
	}
	
	//-
	private static HashMap setAscii(int codetype, byte[] inputArr, int[] ascidx, 
		int ascmax, byte[] asclist, byte[] ascrlist){
		
		HashMap rethm = new HashMap();

		boolean isasc = false;
		char xtag = Base62x.xtag;
		int inputlen = inputArr.length;
		
		if(codetype == 0 && inputArr[0] <= ascmax){
			isasc = true;
			int tmpi = 0;
			for(int i=0; i<inputlen; i++){
				tmpi = (int)inputArr[i];
				if(tmpi < 0 || tmpi > ascmax
					|| (tmpi > 16 && tmpi < 21) //- DC1-4
					|| (tmpi > 27 && tmpi < 32) //-  FC, GS, RS, US
				){
					isasc = false;
					break;
				}
			}
		}
		else if(codetype == 1 && inputArr[inputlen-1] == xtag){
			isasc = true;
		}
		rethm.put("isasc", isasc);

		if(isasc){
			int i = 0;
			for(i=0; i<=ascmax; i++){ ascidx[i] = -1; }
			int idxi = 0;
			int[] starti = new int[]{0, 21, 32, 58, 91, 123}; //- 0, NAK, ' ', ':', '[', '{'
			int[] endi = new int[]{17, 28, 48, 65, 97, ascmax+1}; //- 17, FS, '/', '@', '`'

			int ilen = starti.length;
			for(int n=0; n<ilen; n++){
				for(i=starti[n]; i<endi[n]; i++){
					ascidx[i] = asclist[idxi];
					ascrlist[asclist[idxi]] = (byte)i;
					idxi++;
				}
			}
		}
		rethm.put("ascidx", ascidx);
		rethm.put("ascrlist", ascrlist);

		return rethm;

	}

	//-
	private static long xx2dec(String input, int ibase, int[] rb62x){
		long rtn = 0L;
		//- @todo
		int obase = 10; char xtag = Base62x.xtag;
		int bpos = Base62x.bpos; int xpos = Base62x.xpos;
		int max_safe_base = Base62x.max_safe_base;
        int base59 = Base62x.base59;
		if(ibase < 2 || ibase > xpos){
			System.out.println("Base62x.xx2dec: illegal ibase:["+ibase+"]");
		}
		else if(ibase <= max_safe_base && obase <= max_safe_base){
			rtn = Long.parseLong(Long.toString(Long.parseLong(input, ibase), obase));
		}
		else{
            boolean isBase62x = false;
            if(ibase > base59 && ibase < xpos){
                rb62x['x'] = 59; rb62x['y'] = 60; rb62x['z'] = 61;  
            }
            else if(ibase == xpos){
                isBase62x = true;
            }
			char[] iarr = (new StringBuilder(new String(input)).reverse().toString())
					.toCharArray();
			int arrlen = iarr.length;
			int xnum = 0; int tmpi = 0;
			//java.util.Collections.reverse(iarr);
			for(int i=0; i<arrlen; i++){
				if(isBase62x && (i+1) < arrlen && iarr[i+1] == xtag){
					tmpi = bpos + rb62x[iarr[i]];
					xnum++;
					i++;
				}
				else{
					tmpi = rb62x[iarr[i]];
				}
				if(tmpi >= ibase){
					System.out.println("Base62x::xx2dec: found out of radix:"+tmpi+" for base:"+ibase);
					tmpi = ibase - 1;
				}
				rtn += tmpi * Math.pow(ibase, (i-xnum));
			}
			//- oversize check?
			//- @todo
		}
		//System.out.print("static xx2dec: in:["+input+"] ibase:["+ibase+"] rtn:["+rtn+"] in 10.");
		return rtn;
	}

	//-
	private static String dec2xx(long num_input, int obase, byte[] b62x){
		String rtn = "";
		//- @todo
		int ibase = 10; char xtag = Base62x.xtag;
		int bpos = Base62x.bpos; int xpos = Base62x.xpos;
		int max_safe_base = Base62x.max_safe_base;
		String inputs = Long.toString(num_input);
        int base59 = Base62x.base59;
		if(ibase < 2 || ibase > xpos){
			System.out.println("Base62x.xx2dec: illegal ibase:["+ibase+"]");
		}
		else if(obase <= max_safe_base && ibase <= max_safe_base){
			rtn = Long.toString(Long.parseLong(inputs, ibase), obase);
		}
		else{
            boolean isBase62x = false;
            if(obase > base59 && obase < xpos){
                b62x[59] = 'x'; b62x[60] = 'y'; b62x[61] = 'z';
            }
            else if(obase == xpos){
                isBase62x = true;
            }
			int i = 0; int b = 0;
			int inputlen = inputs.length();
			int outlen = (int)(inputlen*Math.log(ibase)/Math.log(obase))+1;
			char[] oarr = new char[outlen]; //- why threefold?
            int maxPos = bpos;
            if(!isBase62x){ maxPos = bpos + 1; }
			while(num_input >= obase){
				b = (int)(num_input % obase);
				num_input = (long)Math.floor(num_input/obase);
				if(b <= maxPos){
					oarr[i++] = (char)b62x[b];
				}
				else{
					oarr[i++] = (char)b62x[b-bpos];
					oarr[i++] = xtag;
				}
			}
			b = (int)num_input;
			if(b > 0){
				if(b <= maxPos){
					oarr[i++] = (char)b62x[b];
				}
				else{
					oarr[i++] = (char)b62x[b-bpos];
					oarr[i++] = xtag;
				}
			}
			//Collections.reverse(oarr);
			//rtn = oarr.join();
			rtn = new StringBuilder(new String(oarr)).reverse().toString();
		}
		//System.out.println("static dec2xx: in:["+inputs+"] in 10, obase:["+obase+"] rtn:["+rtn+"].");
		return rtn;
	}
	
	//- fix variable length of encoded string
	//- Dec 01, 2016
	//- refine, Mon Mar 11 04:55:07 UTC 2019
	private static HashMap _decodeByLength(int[] tmpArr, byte[] op, int m){
		//- @todo replace ArrayIndexOutOfBoundsException and variable tmpArr in decode	
		HashMap rtnhm = new HashMap();
		int c0=0; int c1=0;	int c2=0;

		if(tmpArr[3] > -1){
			c0 = (tmpArr[0] << 2) | (tmpArr[1] >> 4); 
			c1 = ((tmpArr[1] << 4) & 0xf0) | (tmpArr[2] >> 2); 
			c2 = ((tmpArr[2] << 6) & 0xff) | tmpArr[3];
			op[m] = (byte)c0;
			op[++m] = (byte)c1;
			op[++m] = (byte)c2;
		}
		else if(tmpArr[2] > -1){
			c0 = (tmpArr[0] << 2) | (tmpArr[1] >> 4);
			c1 = ((tmpArr[1] << 4) & 0xf0) | tmpArr[2];
			op[m] = (byte)c0;
			op[++m] = (byte)c1;
		}
		else if(tmpArr[1] > -1){
			c0 = (tmpArr[0] << 2) | tmpArr[1];
			op[m] = (byte)c0;
		}
		else{
			c0 = tmpArr[0];
			op[m] = (byte)c0;
		}

		rtnhm.put(0, op); rtnhm.put(1, m);
		return rtnhm;
	}

}

%>
