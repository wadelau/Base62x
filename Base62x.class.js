/*
 * -Base62x in -JavaScript
 * Wadelau@{ufqi,hotmail}.com
 * Refers to 
 	http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=6020065
 	-GitHub-Wadelau , base62x.c
 	https://github.com/wadelau/Base62x
 	https://ufqi.com/dev/base62x/?_via=-naturedns
 * v0.8, 21:49 12 February 2017
 */
 'use strict';
 
 class Base62x {
	 
	 //- constructor
	 constructor(){
		 //- @todo, refer, https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes
		 this.isdebug = true;
		 this.i = Base62x.genRand(); // static method
		 this.codetype = 0;
	 }
	 
	 //- variables
	 //var isdebug = true; // properties unsupported at present
	 
	 //- methods, public
	 //- encode, statically
	 static encode(input, ibase){
		 var rtn = undefined;
		 if(typeof input == 'undefined' || input == ''){
			 return rtn;
		 }
		 var codetype = 0;
		 var xtag = this.get('xtag');
		 var b62x = this.get('b62x');
		 var asclist = this.get('asclist');
		 var ascrlist = this.get('ascrlist');
		 var bpos = this.get('bpos');
		 var xpos = this.get('xpos');
		 var ascidx = this.get('ascidx');
		 var ascmax = this.get('ascmax');
		 var max_safe_base = this.get('max_safe_base');
		 console.log('static encode: xtag:['+xtag+'] input:['+input+']');
		 var rb62x = this.fillRb62x(b62x, bpos, xpos);
		 var isnum = false;
		 if(ibase > 0){ $isnum = true; }
		 if(isnum){
			 rtn = 0;
			 var num_input = this.xx2dec(input, ibase, max_safe_base, rb62x);
			 var obase = xpos;
			 rtn = this.dec2xx(num_input, obase, b62x);
		 }
		 else{
			 // string
			 var inputArr = this.toUTF8Array(input); //input.split(''); // need '' as parameter
			 var inputlen = inputArr.length;
			 var setResult = this.setAscii(codetype, inputArr, ascidx, ascmax, asclist, ascrlist);
			 var asctype = setResult['asctype'];
			 ascidx = setResult['ascidx'];
			 ascrlist = setResult['ascrlist'];
			 var op = [];
			 var i = 0; var m = 0;
			 if(asctype == 1){ // ascii
				 var ixtag = xtag.charCodeAt();
				 do{
					 //inputArr[i] = inputArr[i].charCodeAt();
					 if(ascidx[inputArr[i]] != -1){ // why != here?
						 op[m] = xtag;
						 op[++m] = ascidx[inputArr[i]];
					 }
					 else if(inputArr[i] == ixtag){
						 op[m] = xtag;
						 op[++m] = xtag;
					 }
					 else{
						 op[m] = String.fromCharCode(inputArr[i]);
					 }
					 m++;
				 }
				 while(++i < inputlen);
				 op[++m] = xtag; // append x as a tag
			 }
			 else{ //- non-ascii
				var c0=0; var c1=0; var c2=0; var c3=0; var remaini=0;
				do{
					remaini = inputlen - i;
					//inputArr[i] = inputArr[i].charCodeAt();
					switch(remaini){
						case 1:
							c0 = inputArr[i] >> 2;
							c1 = ((inputArr[i] << 6) & 0xff >> 6);
							if(c0 > bpos){ op[m] = xtag; op[++m] = b62x[c0]; }
							else{ op[m] = b62x[c0]; }
							if(c1 > bpos){ op[++m] = xtag; op[++m] = b62x[c1]; }
							else{ op[++m] = b62x[c1];}
							break;
						case 2:
							//inputArr[i+1] = inputArr[i+1].charCodeAt();
							c0 = inputArr[i] >> 2;
							c1 = (((inputArr[i] << 6) & 0xff) >> 2) | (inputArr[i+1] >> 4);
							c2 = ((inputArr[i+1] << 4) & 0xff) >> 4;
							if(c0 > bpos){ op[m] = xtag; op[++m] = b62x[c0]; }
							else{ op[m] = b62x[c0]; }
							if(c1 > bpos){ op[++m] = xtag; op[++m] = b62x[c1]; }
							else{ op[++m] = b62x[c1];}
							if(c2 > bpos){ op[++m] = xtag; op[++m] = b62x[c2]; }
							else{ op[++m] = b62x[c2];}
							i += 1;
							break;
						default:
							//inputArr[i+1] = inputArr[i+1].charCodeAt();
							//inputArr[i+2] = inputArr[i+2].charCodeAt();
							c0 = inputArr[i] >> 2;
							c1 = (((inputArr[i] << 6) & 0xff) >> 2) | (inputArr[i+1] >> 4);
							c2 = (((inputArr[i+1] << 4) & 0xff) >> 2) | (inputArr[i+2] >> 6);
							c3 = ((inputArr[i+2] << 2) & 0xff) >> 2;
							if(c0 > bpos){ op[m] = xtag; op[++m] = b62x[c0]; }
							else{ op[m] = b62x[c0]; }
							if(c1 > bpos){ op[++m] = xtag; op[++m] = b62x[c1]; }
							else{ op[++m] = b62x[c1];}
							if(c2 > bpos){ op[++m] = xtag; op[++m] = b62x[c2]; }
							else{ op[++m] = b62x[c2];}
							if(c3 > bpos){ op[++m] = xtag; op[++m] = b62x[c3]; }
							else{ op[++m] = b62x[c3];}
							i += 2;
					}
					m++;
				}
				while(++i < inputlen);
			 }
			 console.log('static enc: op:['+op+'] asctype:['+asctype+'] inputArr[0]:['+inputArr[0]+']');
			 rtn = op.join('');
		 }
		 return rtn;
	 }
	 
	 //- decode, statically
	 static decode(input, obase){
		var rtn = undefined;
		if(typeof input == 'undefined' || input == ''){
			return rtn;
		}
		var codetype = 1;
		var xtag = this.get('xtag');
		var xtag = this.get('xtag');
		var b62x = this.get('b62x');
		var asclist = this.get('asclist');
		var ascrlist = this.get('ascrlist');
		var bpos = this.get('bpos');
		var xpos = this.get('xpos');
		var ascidx = this.get('ascidx');
		var ascmax = this.get('ascmax');
		var max_safe_base = this.get('max_safe_base');
		console.log('static decode: xtag:['+xtag+'] input:['+input+']');
		var rb62x = this.fillRb62x(b62x, bpos, xpos);
		var isnum = false;
		if(obase > 0){ $isnum = true; }
		if(isnum){
			rtn = 0;
			var ibase = xpos;
			var num_input = this.xx2dec(input, ibase, max_safe_base, rb62x);
			rtn = this.dec2xx(num_input, obase, b62x);
			// why a medille num_input is needed?
		}
		else{
			// string
			var inputArr = this.toUTF8Array(input); //input.split(''); // need '' as parameter
			var inputlen = inputArr.length;
			var setResult = this.setAscii(codetype, inputArr, ascidx, ascmax, asclist, ascrlist);
			var asctype = setResult['asctype'];
			ascidx = setResult['ascidx'];
			ascrlist = setResult['ascrlist'];
			var op = [];
			var i = 0; var m = 0; var ixtag = xtag.charCodeAt();
			if(asctype == 1){ // ascii
				inputlen--; // pop the last one as 'x'
				var tmpc = '';
				do{
					if(inputArr[i] == ixtag){
						if(inputArr[i+1] == ixtag){
							op[m] = xtag; i++;
						}
						else{
							tmpc = String.fromCharCode(inputArr[++i]);
							op[m] = String.fromCharCode(ascrlist[tmpc]);
						}
					}
					else{
						op[m] = String.fromCharCode(inputArr[i]);
					}
					m++;
				}
				while(++i < inputlen);
			}
			else{ // non-ascii
				var tmpArr = []; var tmprtn = {};
				var bint = {1:1, 2:2, 3:3};
				var remaini = 0;
				var rki = 0;
				for(var rk in rb62x){ // for char and its ascii value
					rki = rk.charCodeAt();
					rb62x[rki] = rb62x[rk];
				}
				do{
					tmpArr = [];
					remaini = inputlen - i;
					switch(remaini){
						case 1:
							console.log('static decode: illegal base62x input:['+inputArr[i]+']. 1702122106.');
							break;
						case 2:
							if(inputArr[i] == ixtag){ tmpArr[0] = bpos + bint[inputArr[++i]]; }
							else{ tmpArr[0] = rb62x[inputArr[i]]; }
							if(inputArr[++i] == ixtag){ tmpArr[1] = bpos + bint[inputArr[++i]]; }
							else{ tmpArr[1] = rb62x[inputArr[i]]; }
							tmprtn = this.decodeByLength(tmpArr, op, m);
							op = tmprtn[0];
							m = tmprtn[1];
							break;
						case 3:
							if(inputArr[i] == ixtag){ tmpArr[0] = bpos + bint[inputArr[++i]]; }
							else{ tmpArr[0] = rb62x[inputArr[i]]; }
							if(inputArr[++i] == ixtag){ tmpArr[1] = bpos + bint[inputArr[++i]]; }
							else{ tmpArr[1] = rb62x[inputArr[i]]; }
							if(inputArr[++i] == ixtag){ tmpArr[2] = bpos + bint[inputArr[++i]]; }
							else{ tmpArr[2] = rb62x[inputArr[i]]; }
							tmprtn = this.decodeByLength(tmpArr, op, m);
							op = tmprtn[0];
							m = tmprtn[1];
							break;
						default:
							if(inputArr[i] == ixtag){ tmpArr[0] = bpos + bint[inputArr[++i]]; }
							else{ tmpArr[0] = rb62x[inputArr[i]]; }
							console.log('static decode: 0 i:['+i+'] tmpArr:['+tmpArr+'] 0:['+rb62x[inputArr[i]]+'] v:['+inputArr[i]+'] remaini:['+remaini+']');
							if(inputArr[++i] == ixtag){ tmpArr[1] = bpos + bint[inputArr[++i]]; }
							else{ tmpArr[1] = rb62x[inputArr[i]]; console.log('ddd i:['+i+']'); }
							console.log('static decode: 1 i:['+i+'] tmpArr:['+tmpArr+'] 1:['+rb62x[inputArr[i]]+'] v:['+inputArr[i]+']');
							if(inputArr[++i] == ixtag){ tmpArr[2] = bpos + bint[inputArr[++i]]; }
							else{ tmpArr[2] = rb62x[inputArr[i]]; }
							console.log('static decode: 2 i:['+i+'] tmpArr:['+tmpArr+']');
							if(inputArr[++i] == ixtag){ tmpArr[3] = bpos + bint[inputArr[++i]]; }
							else{ tmpArr[3] = rb62x[inputArr[i]]; }
							tmprtn = this.decodeByLength(tmpArr, op, m);
							op = tmprtn[0];
							m = tmprtn[1];
							console.log('static decode: i:['+i+'] tmpArr:['+tmpArr+'] tmprtn:['+JSON.stringify(tmprtn)+'] op:['+JSON.stringify(op)+'] m:['+m+'] ixtag:['+ixtag+']');
					}
					m++;
				}
				while(++i < inputlen);
			}
			console.log('static dec: op:['+op+'] asctype:['+asctype+'] inputArr:['+inputArr+'] rb62x:['+JSON.stringify(rb62x)+']');
			rtn = op.join('');
		}
		return rtn;
	 }
	 
	 //- encode with instanceof
	 encode(input, ibase){
		 var rtn = undefined;
		 var xtag = this.get('xtag');
		 //console.log('encode: isdebug:['+this.constructor.isdebug+']'); // unsupported, cannot be called inside class
		 console.log('encode: s:['+input+'] xtag:['+xtag+']');
		 
		 return rtn;
	 }
	 
	 //- decode with instanceof
	 decode (input, ibase){
		 var rtn = undefined;
		 
		 return rtn;
	 }
	 
	 //- methods, private
	 //-
	 static get(k){
		 var ret = undefined;
		 //- constant config
		 this.config = {
			'isdebug': true,
			'codetype': 0,
			'xtag': 'x',
			'encd': '-enc',
			'decd': '-dec',
			'debg': 'v',
			'cvtn': '-n',
			'b62x': ['0','1','2','3','4','5','6','7','8','9',
				'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
				'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
				'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
				'q','r','s','t','u','v','w','y','z','1','2','3','x'],
			'bpos': 60,
			'xpos': 64,
			'rb62x': [],
			'ascmax': 127,
			'asclist': ['4','5','6','7','8','9', '0',
				'A','B','C','D','E','F','G','H','I','J','K','L','M','N',
				'O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b',
				'c','d','e','f','g','h','i','j','k','l','m','n','o','p',
				'q','r','s','t','u','v','w','y','z'],
			'ascidx': [],
			'ascrlist': [],
			'max_safe_base': 36,
			'ver': 0.8,
		 };
		 var gotV = false;
		 //- runtime
		 if(typeof this.configx != 'undefined'){
			 if(this.configx.hasOwnProperty(k)){
				ret = this.configx[k]; //eval('Base62x.configx.'+k);
				gotV = true;
			 }
		 }
		 //- constant
		 if(!gotV){
			 if(this.config.hasOwnProperty(k)){
				ret = this.config[k]; //eval('Base62x.config.'+k);
				gotV = true;
			 }
		 }
		 //console.log('get: k:'+k+', v:['+ret+']');
		 return ret;
	 }
	 
	 //-
	 static set(k, v){
		 var rtn = undefined;
		 if(typeof this.configx == 'undefined'){
			 this.configx = {};
		 }
		 if(true){
			 if(typeof v == 'string'){
				 //eval('Base62x.configx.'+k+'=\''+v+'\';');
				 this.configx[k] = v;
			 }
			 else{
				//eval('Base62x.configx.'+k+'='+v);
				this.configx[k] = v;
			 }
		 }
		 return rtn;
	 }
	 
	 //-
	 static fillRb62x(b62x, bpos, xpos){
		 var rb62x = {};
		 for(var i=0; i<=xpos; i++){
			 if(i > bpos && i < xpos){
				 //omit x1, x2, x3
			 }
			 else{
				 rb62x[b62x[i]] = i;
			 }
		 }
		 console.log('static fillRb62x:['+JSON.stringify(rb62x)+'] b62x:['+b62x+'] bpos:['+bpos+'] xpos:['+xpos+']');
		 return rb62x;
	 }
	 
	 //-
	 static setAscii(codetype, inputArr, ascidx, ascmax, asclist, ascrlist){
		 var rtn = {};
		 var asctype = 0;
		 var xtag = this.get('xtag');
		 var ixtag = xtag.charCodeAt();
		 var inputlen = inputArr.length;
		 console.log('static setAscii: inputArr:['+JSON.stringify(inputArr)+'] len:['+inputlen+']');
		 //if(codetype == 0 && inputArr[0].charCodeAt() <= ascmax){
		 if(codetype == 0 && inputArr[0] <= ascmax){
			 asctype = 1;
			 var tmpi = 0;
			 for(var i=1; i<inputlen; i++){
				 //tmpi = inputArr[i].charCodeAt();
				 tmpi = inputArr[i];
				 if(tmpi > ascmax
					|| (tmpi > 16 && tmpi < 21) //DC1-4
					|| (tmpi > 27 && tmpi < 32)){ //FC, GS, RS, US
					 asctype = 0;
					 break;
				 }
			 }
		 }
		 else if(codetype == 1 && inputArr[inputlen-1] == ixtag){
			 asctype = 1;
			 console.log('static setAscii: codetype:['+codetype+'] ixtag:['+ixtag+']');
		 }
		 console.log('static setAscii: codetype:['+codetype+'] ixtag:['+ixtag+'] asctype:['+asctype+']');
		 rtn['asctype'] = asctype;
		 if(asctype == 1){
			 for(var i=0; i<ascmax; i++){ ascidx[i] = -1; }
			 var idxi = 0;
			 var bgnArr = [0, 21, 32, 58, 91, 123];
			 var endArr = [17, 28, 48, 65, 97, ascmax+1];
			 for(var k in bgnArr){
				 var v1 = bgnArr[k];
				 var v2 = endArr[k];
				 for(var i=v1; i<v2; i++){
					 ascidx[i] = asclist[idxi];
					 ascrlist[asclist[idxi]] = i;
					 idxi++;
				 }
			 }
		 }
		 rtn['ascidx'] = ascidx;
		 rtn['ascrlist'] = ascrlist;
		 console.log('static setAscii: rtn:['+JSON.stringify(rtn)+'] inputArr:['+inputArr+']');
		 return rtn;
	 }
	 
	 //-
	 static xx2dec(input, ibase, max_safe_base, rb62x){
		 var rtn = 0;
		 
		 return rtn;
	 }
	 
	 //-
	 static dec2xx(num_input, obase, b62x){
		 var rtn = 0;
		 
		 return rtn;
	 }
	 
	 //-
	 get(k){
		 return Base62x.get(k);
	 }
	 
	 //-
	 set(k, v){
		 return Base62x.set(k, v);
	 }
	 
	 //-
	 static genRand(){
		 return Math.ceil(Math.random()*100000);
	 }
	 
	 //-
	 static decodeByLength(tmpArr, op, m){
		 var rtn = {};
		 var c0=0; var c1=0; var c2=0;
		 if(typeof tmpArr[3] != 'undefined'){
			c0 = tmpArr[0] << 2 | tmpArr[1] >> 4;
	        c1 = ((tmpArr[1] << 4) & 0xf0) | (tmpArr[2] >> 2);
	        c2 = ((tmpArr[2] << 6) & 0xff) | tmpArr[3];
	        op[m] = String.fromCharCode(c0);
	        op[++m] = String.fromCharCode(c1);
	        op[++m] = String.fromCharCode(c2);
		 }
		 else if(typeof tmpArr[2] != 'undefined'){
			c0 = tmpArr[0] << 2 | tmpArr[1] >> 4;
	        c1 = ((tmpArr[1] << 4) & 0xf0) | tmpArr[2];
	        op[m] = String.fromCharCode(c0);
	        op[++m] = String.fromCharCode(c1);
		 }
		 else if(typeof tmpArr[1] != 'undefined'){
			c0 = tmpArr[0] << 2 | tmpArr[1];
	        op[m] = String.fromCharCode(c0);
		 }
		 else{
			c0 = tmpArr[0];
	        op[m] = String.fromCharCode(c0);
		 }
		 console.log('static decodeByLength: tmpArr:['+tmpArr+'] op:['+op+'] m:['+m+']');
		 rtn = {0:op, 1:m};
		 return rtn;
	 }
	 
	 //-
	 static toUTF8Array(str) { // http://stackoverflow.com/questions/18729405/how-to-convert-utf8-string-to-byte-array
		var utf8 = [];
		for (var i=0; i < str.length; i++) {
			var charcode = str.charCodeAt(i);
			if (charcode < 0x80){ utf8.push(charcode); }
			else if (charcode < 0x800) {
				utf8.push(0xc0 | (charcode >> 6), 
						  0x80 | (charcode & 0x3f));
			}
			else if (charcode < 0xd800 || charcode >= 0xe000) {
				utf8.push(0xe0 | (charcode >> 12), 
						  0x80 | ((charcode>>6) & 0x3f), 
						  0x80 | (charcode & 0x3f));
			}
			else { // surrogate pair
				i++;
				// UTF-16 encodes 0x10000-0x10FFFF by
				// subtracting 0x10000 and splitting the
				// 20 bits of 0x0-0xFFFFF into two halves
				charcode = 0x10000 + (((charcode & 0x3ff)<<10)
						  | (str.charCodeAt(i) & 0x3ff));
				utf8.push(0xf0 | (charcode >>18), 
						  0x80 | ((charcode>>12) & 0x3f), 
						  0x80 | ((charcode>>6) & 0x3f), 
						  0x80 | (charcode & 0x3f));
			}
		}
		return utf8;
	}
	 
 }