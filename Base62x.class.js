/*
 * -Base62x in -JavaScript
 * Wadelau@ufqi.com
 * Refers to 
 	http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=6020065
 	-GitHub-Wadelau , base62x.c
 	https://github.com/wadelau/Base62x
 	https://ufqi.com/dev/base62x/?_via=-naturedns
 * v0.1, 21:49 08 February 2017
 */
 
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
			 var inputArr = input.split(''); // need '' as parameter
			 var inputlen = inputArr.length;
			 var setResult = this.setAscii(codetype, inputArr, ascidx, ascmax, asclist, ascrlist);
			 var asctype = setResult['asctype'];
			 ascidx = setResult['ascidx'];
			 ascrlist = setResult['ascrlist'];
			 var op = [];
			 var i = 0; var m = 0;
			 if(asctype == 1){
				 var ixtag = xtag.charCodeAt();
				 do{
					 inputArr[i] = inputArr[i].charCodeAt();
					 console.log('static enc: inputArr['+i+']:['+inputArr[i]+'] ascidx-i:['+ascidx[inputArr[i]]+']');
					 if(ascidx[inputArr[i]] != -1){
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
			 }
			 else{
				 
			 }
			 console.log('static enc: op:['+op+'] asctype:['+asctype+'] inputArr[0]:['+inputArr[0]+']');
			 rtn = op.join('');
		 }
		 return rtn;
	 }
	 
	 //- decode, statically
	 static decode(input){
		var rtn = undefined;
		
					/*
					if(inputArr[i] == xtag){
						 if(inputArr[i+1] == xtag){
							 op[m] = xtag; i++;
						 }
						 else{
							 op[m] = String.fromCharCode(ascrlist[inputArr[++i]]);
						 }
					 }
					 else{
						 op[m] = inputArr[i];
					 }
					 */
		
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
		 console.log('get: k:'+k+', v:['+ret+']');
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
		 var rb62x = [];
		 for(var i=0; i<=xpos; i++){
			 if(i > bpos && i < xpos){
				 //omit x1, x2, x3
			 }
			 else{
				 rb62x[b62x[i]] = i;
			 }
		 }
		 return rb62x;
	 }
	 
	 //-
	 static setAscii(codetype, inputArr, ascidx, ascmax, asclist, ascrlist){
		 var rtn = {};
		 var asctype = 0;
		 var xtag = this.get('xtag');
		 var inputlen = inputArr.length;
		 if(codetype == 0 && inputArr[0].charCodeAt() <= ascmax){
			 asctype = 1;
			 var tmpi = 0;
			 for(var i=1; i<inputlen; i++){
				 tmpi = inputArr[i].charCodeAt();
				 if(tmpi > ascmax
					|| (tmpi > 16 && tmpi < 21) //DC1-4
					|| (tmpi > 27 && tmpi < 32)){ //FC, GS, RS, US
					 asctype = 1;
					 break;
				 }
			 }
		 }
		 else if(codetype == 1 && inputArr[inputlen-1] == xtag){
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
	 
 }