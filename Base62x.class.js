/*
 * -Base62x in -JavaScript
 * Wadelau@{ufqi,hotmail}.com
 * Refers to 
 	http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=6020065
 	-GitHub-Wadelau , base62x.c
 	https://github.com/wadelau/Base62x
 	https://ufqi.com/dev/base62x/?_via=-naturedns
 * v0.8, 21:49 12 February 2017
 * v0.9, imprvs with decode, Mon Mar 11 02:09:55 GMT 2019
 */
 
 'use strict';
 //- Assume We Are in Charset of UTF-8 Runtime.
 
 class Base62x {
	 
	 //- constructor
	 constructor(){
		 //- @todo, refer, https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes
		 this.isdebug = true;
		 this.i = Math.ceil(Math.random()*100000); // Base62x.genRand(); // static method
		 this.codetype = 0;
	 }
	 
	 //- variables
	 //var isdebug = true; // properties unsupported till now, 21:19 13 February 2017
	 
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
		 //var max_safe_base = this.get('max_safe_base');
		 //console.log('static encode: xtag:['+xtag+'] input:['+input+']');
		 var rb62x = this.fillRb62x(b62x, bpos, xpos);
		 var isnum = false;
		 if(ibase > 0){ isnum = true; }
		 if(isnum){
			 rtn = 0;
			 var num_input = this.xx2dec(input, ibase, rb62x);
			 var obase = xpos;
			 rtn = this.dec2xx(num_input, obase, b62x);
		 }
		 else{
			 // string
			 var inputArr = this.toUTF8Array(input); // this.str2ab(input); //input.split(''); // need '' as parameter
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
                    if(remaini > 2){
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
                    else if(remaini == 2){
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
                    }
                    else{ // ==1
                        c0 = inputArr[i] >> 2;
                        c1 = ((inputArr[i] << 6) & 0xff) >> 6;
                        if(c0 > bpos){ op[m] = xtag; op[++m] = b62x[c0]; }
                        else{ op[m] = b62x[c0]; }
                        if(c1 > bpos){ op[++m] = xtag; op[++m] = b62x[c1]; }
                        else{ op[++m] = b62x[c1];}
                    }
					m++;
				}
				while(++i < inputlen);
			 }
			 //console.log('static enc: op:['+op+'] asctype:['+asctype+'] inputArr:['+inputArr+']');
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
		//var max_safe_base = this.get('max_safe_base');
		//console.log('static decode: xtag:['+xtag+'] input:['+input+']');
		var rb62x = this.fillRb62x(b62x, bpos, xpos);
		var isnum = false;
		if(obase > 0){ isnum = true; }
		if(isnum){
			rtn = 0;
			var ibase = xpos;
			var num_input = this.xx2dec(input, ibase, rb62x);
			rtn = this.dec2xx(num_input, obase, b62x);
			// why a medille num_input is needed? for double check?
		}
		else{
			// string
			var inputArr = this.toUTF8Array(input); // this.str2ab(input); //input.split(''); // need '' as parameter
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
				rtn = op.join('');
			}
			else{ // non-ascii
				var tmpArr = []; var tmprtn = {};
				var bint = {1:1, 2:2, 3:3};
				var remaini = 0;
				var rki = 0; var j = 0;
				for(var rk in rb62x){ // for char and its ascii value as key
					rki = rk.charCodeAt();
					rb62x[rki] = rb62x[rk];
				}
				for(var rk in bint){ // for char and its ascii value as key
					rki = rk.charCodeAt();
					bint[rki] = bint[rk];
				}
				do{
					tmpArr = [];
					remaini = inputlen - i;
                    if(remaini > 1){
                        j = 0;
                        do{
							if(inputArr[i] == ixtag){
                                i++;
                                tmpArr[j] = bpos + bint[inputArr[i]]; 
                            }
							else{
                                tmpArr[j] = rb62x[inputArr[i]];
                            }
							i++; j++;
                        }
                        while(j < 4 && i < inputlen);

					    tmprtn = this.decodeByLength(tmpArr, op, m);
						op = tmprtn[0];
						m = tmprtn[1]; //- deprecated.
                    }
                    else{
                        console.log('static decode: illegal base62x input:['+inputArr[i]+']. 1702122106.');
                        continue;
                    }
					m++;
				}
				while(i < inputlen);
				//console.log('static dec: op:['+op+'] asctype:['+asctype+'] inputArr:['+inputArr+'] tmpstr:['+tmpstr+']');
				rtn = this.toUTF16Array(op).join(''); //String.fromCharCode.apply(null, new Uint8Array(op));
			}
		}
		return rtn;
	 }
	 
	 //- encode with instanceof
	 encode(input, ibase){
		 var rtn = undefined;
		 var xtag = this.get('xtag');
		 //console.log('encode: isdebug:['+this.constructor.isdebug+']'); // unsupported, cannot be called inside class
		 //console.log('encode: s:['+input+'] xtag:['+xtag+']');
		 rtn = Base62x.encode(input, ibase);
		 return rtn;
	 }
	 
	 //- decode with instanceof
	 decode (input, obase){
		 var rtn = undefined;
		 var xtag = this.get('xtag');
		 //console.log('decode: s:['+input+'] xtag:['+xtag+']');
		 rtn = Base62x.decode(input, obase);
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
				ret = this.configx[k];
				gotV = true;
			 }
		 }
		 //- constant
		 if(!gotV){
			 if(this.config.hasOwnProperty(k)){
				ret = this.config[k];
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
				 this.configx[k] = v;
			 }
			 else{
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
		 //console.log('static fillRb62x:['+JSON.stringify(rb62x)+'] b62x:['+b62x+'] bpos:['+bpos+'] xpos:['+xpos+']');
		 return rb62x;
	 }
	 
	 //-
	 static setAscii(codetype, inputArr, ascidx, ascmax, asclist, ascrlist){
		 var rtn = {};
		 var asctype = 0;
		 var xtag = this.get('xtag');
		 var ixtag = xtag.charCodeAt();
		 var inputlen = inputArr.length;
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
		 }
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
		 //console.log('static setAscii: rtn:['+JSON.stringify(rtn)+'] inputArr:['+inputArr+']');
		 return rtn;
	 }
	  
	 //-
	 static xx2dec(input, ibase, rb62x){
		 var rtn = 0;
		 var obase = 10; var xtag = this.get('xtag');
		 var bpos = this.get('bpos'); var max_safe_base = this.get('max_safe_base');
		 var xpos = this.get('xpos');
		 if(ibase < 2 || ibase > xpos){
			console.log('static xx2dec: illegal ibase:['+ibase+']');
		 }
		 else if(ibase <= max_safe_base){
			 rtn = parseInt(input+'', ibase|0).toString(obase|0); //http://locutus.io/php/math/base_convert/
		 }
		 else{
			 var iArr = input.split('');
			 var aLen = iArr.length;
			 var xnum = 0; var tmpi = 0;
			 iArr.reverse();
			 for(var i=0; i<aLen; i++){
				 if(iArr[i+1] == xtag){
					 tmpi = bpos + rb62x[iArr[i]];
					 xnum++;
					 i++;
				 }
				 else{
					 tmpi = rb62x[iArr[i]];
				 }
				 rtn += tmpi * Math.pow(ibase, (i-xnum));
			 }
			 //- oversize check
			 //- @todo			 
		 }
		 //console.log('static xx2dec: in:['+input+'] ibase:['+ibase+'] rtn:['+rtn+'] in 10.');
		 return rtn;
	 }
	 
	 //-
	 static dec2xx(num_input, obase, b62x){
		 var rtn = 0;
		 var ibase = 10; var xtag = this.get('xtag');
		 var bpos = this.get('bpos'); var max_safe_base = this.get('max_safe_base');
		 var xpos = this.get('xpos'); var num_input_orig = num_input;
		 if(obase < 2 || obase > xpos){
			console.log('static xx2dec: illegal ibase:['+ibase+']');
		 }
		 else if(obase <= max_safe_base){
			 rtn = parseInt(num_input+'', ibase|0).toString(obase|0); 
		 }
		 else{
			 var i = 0; var b = 0;
			 var oArr = [];
			 while(num_input >= obase){
				 b = num_input % obase;
				 num_input = Math.floor(num_input/obase);
				 if(b <= bpos){
					 oArr[i++] = b62x[b];
				 }
				 else{
					 oArr[i++] = b62x[b-bpos];
					 oArr[i++] = xtag;
				 }
			 }
			 b = num_input;
			 if(b <= bpos){
				 oArr[i++] = b62x[b];
			 }
			 else{
				 oArr[i++] = b62x[b-bpos];
				 oArr[i++] = xtag;
			 }
			 oArr.reverse();
			 rtn = oArr.join('');
		 }
		 //console.log('static dec2xx: in:['+num_input_orig+'] in 10, obase:['+obase+'] rtn:['+rtn+'].');
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
	 static decodeByLength(tmpArr, op, m){
		 var rtn = {};
		 var c0=0; var c1=0; var c2=0;
		 if(typeof tmpArr[3] != 'undefined'){
			c0 = tmpArr[0] << 2 | tmpArr[1] >> 4;
	        c1 = ((tmpArr[1] << 4) & 0xf0) | (tmpArr[2] >> 2);
	        c2 = ((tmpArr[2] << 6) & 0xff) | tmpArr[3];
	        op[m] = c0;
	        op[++m] = c1;
	        op[++m] = c2;
		 }
		 else if(typeof tmpArr[2] != 'undefined'){
			c0 = tmpArr[0] << 2 | tmpArr[1] >> 4;
	        c1 = ((tmpArr[1] << 4) & 0xf0) | tmpArr[2];
	        op[m] = c0;
	        op[++m] = c1;
		 }
		 else if(typeof tmpArr[1] != 'undefined'){
			c0 = tmpArr[0] << 2 | tmpArr[1];
	        op[m] = c0;
		 }
		 else{
			c0 = tmpArr[0];
	        op[m] = c0; //String.fromCharCode(c0);
		 }
		 //console.log('static decodeByLength: tmpArr:['+tmpArr+'] op:['+op+'] m:['+m+']');
		 rtn = {0:op, 1:m};
		 return rtn;
	 }
	 
	 //-
	 static toUTF8Array(utf16Str) { // http://stackoverflow.com/questions/18729405/how-to-convert-utf8-string-to-byte-array
		var utf8 = []; var str = utf16Str;
		for (var i=0; i < str.length; i++) {
			var charcode = str.charCodeAt(i);
			if (charcode < 0x80){ utf8.push(charcode); } // one byte
			else if (charcode < 0x800) { // two bytes
				utf8.push(0xc0 | (charcode >> 6), 
						  0x80 | (charcode & 0x3f));
			}
			else if (charcode < 0xd800 || charcode >= 0xe000) { // three bytes
				utf8.push(0xe0 | (charcode >> 12), 
						  0x80 | ((charcode>>6) & 0x3f), 
						  0x80 | (charcode & 0x3f));
			}
			else { // surrogate pair, four bytes
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
	
	//-
	static toUTF16Array(utf8Bytes){ //https://terenceyim.wordpress.com/2011/03/04/javascript-utf-8-codec-that-supports-supplementary-code-points/
		var bytes = utf8Bytes;
		var len = bytes.length;
		var result = [];
		var code, i, j; j=0;
		for(i = 0; i<len; i++){
			if(bytes[i] <= 0x7f){ // one byte                    
				result[j++] = String.fromCharCode(bytes[i]);
			}
			else if(bytes[i] >= 0xc0){  // Mutlibytes
				if(bytes[i] < 0xe0){  // two bytes
					code = ((bytes[i++] & 0x1f) << 6) |
							(bytes[i] & 0x3f);
				}
				else if(bytes[i] < 0xf0){  // three bytes
					code = ((bytes[i++] & 0x0f) << 12) |
						   ((bytes[i++] & 0x3f) << 6)  |
							(bytes[i] & 0x3f);
				}
				else{  // four bytes
					// turned into two characters in JS as surrogate pair
					code = (((bytes[i++] & 0x07) << 18) |
							((bytes[i++] & 0x3f) << 12) |
							((bytes[i++] & 0x3f) << 6) |                                  
							 (bytes[i] & 0x3f)) - 0x10000;
					// High surrogate
					result[j++] = String.fromCharCode(((code & 0xffc00) >>> 10) + 0xd800);
					// Low surrogate
					code = (code & 0x3ff) + 0xdc00;
				}
				result[j++] = String.fromCharCode(code);
			}
			else{ // Otherwise it's an invalid UTF-8, skipped
				console.log('static toUTF16Array: illegal utf8 found. 1702132109.');
			}
		}
		return result;
	}

 }
