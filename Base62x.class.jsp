<%@page 
	import="java.util.Date,
		java.util.HashMap,
		java.util.Map,
		java.util.Iterator,
		java.util.Date"
	language="java" 
	pageEncoding="UTF-8"%><%
%><%!

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
 */

 //- Assume We Are in Charset of UTF-8 Runtime
 
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
	private static final double ver = 0.80;


	//- contructors
	//- @todo

	//- methods

	//- encode, ibase=2,8,10,16,32...
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

		int[] rb62x = Base62x.fillRb62x(b62x, bpos, xpos);
		boolean isnum = false;
		if(ibase > 0){ isnum = true; }
		
		if(isnum){
			//- numeric conversion
			long num_input = Base62x.xx2dec(input, ibase, rb62x);
			int obase = xpos;
			osb.append(Base62x.dec2xx(num_input, obase, rb62x));
		}
		else{
			//- string encoding	
			boolean isasc = false;	
			byte[] inputArr = input.getBytes(); // new byte[]{-112, 25, 66, -12}; // //StandardCharsets.UTF_8
			int inputlen = inputArr.length;
			HashMap setResult = Base62x.setAscii(codetype, inputArr, ascidx, ascmax, asclist, ascrlist);
			isasc = (boolean)setResult.get("isasc");
			ascidx = (int[])setResult.get("ascidx");
			ascrlist = (byte[])setResult.get("ascrlist");

			byte[] op = new byte[inputlen*2]; //- extend to 3/2 or 2 theoritical maxium length of base62x 
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
					switch(remaini){
						case 1:
							c0 = tmpi >> 2;
							c1 = ((tmpi << 6) & 0xff) >> 6;
							if(c0>bpos){ op[m]=xtag; op[++m]=b62x[c0]; }
							else{ op[m]=b62x[c0]; }
							if(c1>bpos){ op[++m]=xtag; op[++m]=b62x[c1]; }
							else{ op[++m]=b62x[c1]; }
							break;

						case 2:
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
							break;

						default:
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
					m++;
				}
				while(++i < inputlen);
			}
			byte[] op2 = new byte[m];
			System.arraycopy(op, 0, op2, 0, m);	
			osb.append(new String(op2));
		}

		return osb.toString();

	}

	//- decode, obase=2,8,10,16,32...
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

		int[] rb62x = Base62x.fillRb62x(b62x, bpos, xpos);
		boolean isnum = false;
		if(obase > 0){ isnum = true; }
		
		if(isnum){
			//- numeric conversion
			int ibase = xpos;
			long num_input = Base62x.xx2dec(input, ibase, rb62x);
			osb.append(Base62x.dec2xx(num_input, obase, rb62x));
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
				//- ascii
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
				//- non-ascii	
				int c0=0; int c1=0;	int c2=0;
				int remaini = 0; 
				int maxidx = inputlen - 1; int last8 = inputlen - 8; //- avoid outofArrayIndex
				int[] tmpArr = new int[4];
				int[] bint = new int[xpos]; bint[49]=1; bint[50]=2; bint[51]=3; //- array('1'=>1, '2'=>2, '3'=>3);
				do{
					remaini = inputlen - i;
					tmpArr = new int[4];
					switch(remaini){
						case 1:
							System.out.println("Base62x.decode: illegal base62x input:["+input+"]. 1608091042.");
							break;

						case 2:
							if(inputArr[i]==xtag){ tmpArr[0]=bpos+bint[inputArr[++i]]; }
							else{ tmpArr[0]=rb62x[inputArr[i]]; }
							if(i == maxidx){
								c0 = (tmpArr[0] << 2);
								op[m] = (byte)c0;
							}
							else{
								if(inputArr[++i]==xtag){ tmpArr[1]=bpos+bint[inputArr[++i]]; }
								else{ tmpArr[1]=rb62x[inputArr[i]]; }
								c0 = (tmpArr[0] << 2) | tmpArr[1];
								op[m] = (byte)c0;
							}
							break;

						case 3: 
							if(inputArr[i]==xtag){ tmpArr[0]=bpos+bint[inputArr[++i]]; }
							else{ tmpArr[0]=rb62x[inputArr[i]]; }
							if(inputArr[++i]==xtag){ tmpArr[1]=bpos+bint[inputArr[++i]]; }
							else{ tmpArr[1]=rb62x[inputArr[i]]; }
							if(i == maxidx){
								c0 = (tmpArr[0] << 2) | tmpArr[1];
								op[m] = (byte)c0;
							}
							else{
								if(inputArr[++i]==xtag){ tmpArr[2]=bpos+bint[inputArr[++i]]; }
								else{ tmpArr[2]=rb62x[inputArr[i]]; }
								c0 = (tmpArr[0] << 2) | (tmpArr[1] >> 4);
								c1 = ((tmpArr[1] << 4) & 0xf0) | tmpArr[2];
								op[m] = (byte)c0;
								op[++m] = (byte)c1;
							}
							break;

						default:
							if(i < last8){
								if(inputArr[i]==xtag){ tmpArr[0]=bpos+bint[inputArr[++i]]; }
								else{ tmpArr[0]=rb62x[inputArr[i]]; }
								if(inputArr[++i]==xtag){ tmpArr[1]=bpos+bint[inputArr[++i]]; }
								else{ tmpArr[1]=rb62x[inputArr[i]]; }
								if(inputArr[++i]==xtag){ tmpArr[2]=bpos+bint[inputArr[++i]]; }
								else{ tmpArr[2]=rb62x[inputArr[i]]; }
								if(inputArr[++i]==xtag){ tmpArr[3]=bpos+bint[inputArr[++i]]; }
								else{ tmpArr[3]=rb62x[inputArr[i]]; }
								c0 = (tmpArr[0] << 2) | (tmpArr[1] >> 4); 
								c1 = ((tmpArr[1] << 4) & 0xf0) | (tmpArr[2] >> 2); 
								c2 = ((tmpArr[2] << 6) & 0xff) | tmpArr[3];
								op[m] = (byte)c0;
								op[++m] = (byte)c1;
								op[++m] = (byte)c2;
							}
							else{
								if(inputArr[i]==xtag){ tmpArr[0]=bpos+bint[inputArr[++i]]; }
								else{ tmpArr[0]=rb62x[inputArr[i]]; }
								if(inputArr[++i]==xtag){ tmpArr[1]=bpos+bint[inputArr[++i]]; }
								else{ tmpArr[1]=rb62x[inputArr[i]]; }
								if(i == maxidx){
									c0 = (tmpArr[0] << 2) | tmpArr[1];
									op[m] = (byte)c0;
								}
								else{
									if(inputArr[++i]==xtag){ tmpArr[2]=bpos+bint[inputArr[++i]]; }
									else{ tmpArr[2]=rb62x[inputArr[i]]; }
									if(i == maxidx){
										c0 = (tmpArr[0] << 2) | (tmpArr[1] >> 4);
										c1 = ((tmpArr[1] << 4) & 0xf0) | tmpArr[2];
										op[m] = (byte)c0;
										op[++m] = (byte)c1;
									}
									else{
										if(inputArr[++i]==xtag){ tmpArr[3]=bpos+bint[inputArr[++i]]; }
										else{ tmpArr[3]=rb62x[inputArr[i]]; }
										c0 = (tmpArr[0] << 2) | (tmpArr[1] >> 4); 
										c1 = ((tmpArr[1] << 4) & 0xf0) | (tmpArr[2] >> 2); 
										c2 = ((tmpArr[2] << 6) & 0xff) | tmpArr[3];
										op[m] = (byte)c0;
										op[++m] = (byte)c1;
										op[++m] = (byte)c2;
									}
								}

							}
					}
					m++;
				}
				while(++i < inputlen);				
			}
			byte[] op2 = new byte[m];
			System.arraycopy(op, 0, op2, 0, m);	
			osb.append(new String(op2)); //, StandardCharsets.UTF_8
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
	
		long decnum = 0L;

		//- @todo

		return decnum;

	}

	//-
	private static String dec2xx(long decnum, int obase, int[] rb62x){
	
		String ostr = "";

		//- @todo
		
		return ostr;

	}
	
	//- fix variable length of encoded string
	//- Dec 01, 2016
	private static byte[] _decodeByLength(int[] tmpArr, byte[] op, int m){
		byte[] rtn = op;

		//- @todo replace ArrayIndexOutOfBoundsException and variable tmpArr in decode	

		rtn[m++] = (byte)m; //- ?
		return rtn;
	}

}

%>
