/*
 * Base62x, an alternative non-symbol way to Base64:
 *      http://www.ietf.org/rfc/rfc3548.txt
 *      http://www.ietf.org/rfc/rfc4648.txt
 * by wadelau@{ufqi,gmail,hotmail}.com, since 2011.01
 * first draft Sat Jan 22 13:04:15 GMT 2011
 * second draft Sun Jan 23 13:49:56 GMT 2011
 * v0.3, Wed Aug 10 13:58:49 BST 2011, make last char no more than 1111 (15), decrease the possibility of double-digital
 * v0.4, Tue Jan  1 07:28:42 CST 2013, add ASCII handling para, shorten the encoded string....
 * v0.5, Fri Feb 22 21:07:05 CST 2013, add -v mode for debug purpose
 * format refine, Sun Apr  7 21:43:22 CST 2013
 * v0.6, Sun May 26 22:27:29 CST 2013, add -n for numeric conversion, support bin|oct|dec|hex, adding -lm to gcc when compiling
 * 		for compile: gcc -lm base62x.c -o base62x
 * v0.7, Sun Apr  3 12:27:58 CST 2016, imprv for code format, output removing '\n' and relocated into -github-wadelau
 *		12:53 02 August 2016, improvs on codes.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int isdebug = 0; /* output more details? */

//- for integer conversion, issetn
void *dec2xx(long long num, int base, char *out, char idx[]);
long long xx2dec(char *input, int base, int safebase, char idx[]);
void reverse_array(char *ptr, int n);

//- code types: integer, string {ascii, non-ascii}
int main( int argc, char *argv[] ){

    int i = 0;
    int codetype = 0; //- 0:encode; 1: decode
    static const char xtag = 'x';
    static const char *enc = "-enc";
    static const char *dec = "-dec";
    static const char *deg = "-v";
    static const char *cvtn = "-n";
    static char b62x[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwyz123x";
    static const int bpos = 60; /* 0-60 chars */
    static const int xpos = 64; /* b62x[64] = 'x' */
    unsigned char rb62x[xpos*2]; /* reverse in decode block */
    int bint[xpos]; /* special handling for x1, x2, x3 *1 */
    static const int ascmax = 127;
    static const char asclist[] = "4567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwyz";
    int ascidx[ascmax+1];
    int ascrlist[ascmax+1]; 
    static const float ver = 0.7;

    for(i=0; i<=xpos; i++){
        if( i>bpos && i<xpos){
            //--omit x1, x2, x3
        }
		else{
            rb62x[b62x[i]] = i;
        }
    }

    if( argc<3){
		printf("Usage: %s [-v] [-n <2|8|10|16|32>] <-enc|dec> string\n", argv[0]);
		printf("Version: %.2f\n", ver); 
		return 1;
    }
    
	unsigned char *input = argv[argc-1]; // src from command line
	char *code =  ""; //argv[1];
	int asctype = 0; // for ascii 
	int issetv = 0;
	int issetn = 0;
	int fbase = 2;

	for(i=0; i<argc; i++){
		code = argv[i];
		if( !strcmp(code, cvtn)){
			issetn = 1; 
			i++;
			fbase = atoi(argv[i]);
			if(isdebug){
				printf("--xx-- code:[%s] fbase:[%d] %s\n", code, fbase, argv[i]);
			}
		}
		else if( !strcmp(code, deg)){
			issetv = 1;
			isdebug = 1;
		}
		else if( !strcmp(code, enc)){
			if( isdebug){
				printf("it is to enc!\n");
			}   
		}
		else if( !strcmp(code, dec)){
			if( isdebug){
				printf("it is to dec!\n");
			}
			codetype = 1;
		}
	}

	if( isdebug){
		printf("argc:[%d], argv-2:[%s] codetype:[%d]\n", argc, argv[1], codetype);
		printf("input:[%s]\n", input); //- malformal
	}

	int m = 0;
	int inputlen = strlen(input);
	int arrsize = (int)(inputlen+8)*4/3 ;
	unsigned char output[arrsize]; //*output[ arrsize ] 

	//- for integer
	if( issetn){
		char *endptr, *out;
		int obase = xpos;
		if(codetype == 1){
			obase = fbase;
			fbase = xpos;
		}
		long long numofinput = xx2dec(input, fbase, xpos, rb62x);
		
		dec2xx(numofinput, obase, output, b62x);
		
		//printf("inputnum:[%lld], fbase:[%d], output:[%s] \n", numofinput, fbase, output);
		//printf("%s\n", output);
		printf("%s", output);

		return 0;
	}
	
	//- for string
	int remaini = 0;
	if( codetype == 0 && input[0] <= ascmax){
		asctype = 1;
		for(i=1; i<inputlen; i++){
			int tmpi = input[i];
			if(tmpi > ascmax
				|| (tmpi > 16 && tmpi < 21) // DC1-4
				|| (tmpi > 27 && tmpi < 32)) // FC, GS, RS, US
			{
				asctype = 0;
				if( isdebug){
					printf("try to enc/dec within asc, but found input[%d]:[%d] beyond ASCII.\n", 
						i, input[i]);    
				}
				break;
			}    
		}
	}
	else if( codetype == 1 && input[inputlen-1] == xtag){
		asctype = 1;    
	}

	if(asctype == 1){
		for(i=0; i<=ascmax; i++){ ascidx[i] = -1; }
		int idxi = 0;
		for(i=0; i<17; i++){ ascidx[i]=asclist[idxi]; ascrlist[asclist[idxi]]=i; idxi++; }    
		// DC1-4
		for(i=21; i<28; i++){ ascidx[i]=asclist[idxi]; ascrlist[asclist[idxi]]=i; idxi++; }    
		// FS, GS, RS, US
		for(i=' '; i<='/'; i++){ ascidx[i]=asclist[idxi]; ascrlist[asclist[idxi]]=i; idxi++; }    
		// 0 - 9
		for(i=':'; i<='@'; i++){ ascidx[i]=asclist[idxi]; ascrlist[asclist[idxi]]=i; idxi++; }    
		// A - Z
		for(i='['; i<='`'; i++){ ascidx[i]=asclist[idxi]; ascrlist[asclist[idxi]]=i; idxi++; }    
		// a - z 
		for(i='{'; i<=ascmax; i++){ ascidx[i]=asclist[idxi]; ascrlist[asclist[idxi]]=i; idxi++; }    
		/* 
		for(i=0; i<=ascmax; i++){
		   printf("i:[%d] n:[%d] c:[%c] idxi:[%d]\n", i, ascidx[i], ascidx[i], idxi);  
		}
		*/
	}

	if( isdebug){
		printf("ver:[%.2f], input length:[%d], output-len:[%d]\n", ver, inputlen, arrsize);
		for( i=0; i<inputlen; i++){
			printf("    --n:[%d] [%d] [%c]\n", i, input[i], input[i]);
		}
	}

	i = 0;
	if( codetype==0){
		/* try to encode.... */
	   if(asctype == 1){
		  //- for ascii
			do{
				if( isdebug){
					//printf("i:[%d] n:[%d] char:[%c] ascidx:[%d] o:[%s]\n", 
					//	i, input[i], input[i], ascidx[input[i]], &output); 
				}
				if( ascidx[input[i]] > -1){
					output[m]=xtag;output[++m]=ascidx[input[i]];    
				}
				else if(input[i] == xtag){
					output[m]=xtag;output[++m]=xtag;    
				}
				else{
					output[m] = input[i];    
				}
				m++;
			}
			while(++i < inputlen);    
			output[m++] = xtag; // asctype has a tag 'x' appended
	   }
	   else{
			//- for non-ascii
		   int c0=0; int c1=0; int c2=0; int c3=0;
		   do{
			   remaini = inputlen - i;
			   if( isdebug){
				   printf("i:[%d] n:[%d] char:[%c]\n", i, input[i], input[i]); 
			   }
			   switch( remaini){
				   case 1:
					   if( isdebug){
							printf(" reach to the last one. i:[%d] char:[%c] inputlen:[%d]\n", 
								i, input[i], inputlen);
					   }
					   c0 = input[i] >> 2;
					   //c1 = ( ( (input[i] << 6) & 0xff ) >> 2 ); //- v0.3, hereinafter
					   c1 = ( ( (input[i] << 6) & 0xff ) >> 6 );
					   if( c0>bpos){ output[m]=xtag;output[++m]=b62x[c0]; }else{ output[m]=b62x[c0]; }
					   if( c1>bpos){ output[++m]=xtag;output[++m]=b62x[c1]; }else{ output[++m]=b62x[c1]; }
					   break;

				   case 2:
						if( isdebug){
							printf(" reach to the last two. i:[%d] char:[%c] inputlen:[%d]\n", 
								i, input[i], inputlen);
						}
					   c0 = input[i] >> 2;
					   c1 = ( ((input[i] << 6) & 0xff) >> 2 ) | ( input[i+1] >> 4 );
					   // c2 = ( ( (input[i+1] << 4) & 0xff ) >> 2 );
					   c2 = ( ( (input[i+1] << 4) & 0xff ) >> 4 );
					   if( c0>bpos){ output[m]=xtag;output[++m]=b62x[c0]; }else{ output[m]=b62x[c0]; }
					   if( c1>bpos){ output[++m]=xtag;output[++m]=b62x[c1]; }else{ output[++m]=b62x[c1]; }
					   if( c2>bpos){ output[++m]=xtag;output[++m]=b62x[c2]; }else{ output[++m]=b62x[c2]; }
					   i++;
					   break;

				   default:
						if( isdebug){
							printf(" continue as usual. i:[%d] inputlen:[%d]\n", i, inputlen);
						}
					   c0 = input[i] >> 2;
					   c1 = ( ((input[i] << 6) & 0xff) >> 2 ) | ( input[i+1] >> 4 );
					   c2 = ( ((input[i+1] << 4) & 0xff ) >> 2) | ( (input[i+2] >> 6) );
					   c3 = ( (input[i+2] << 2) & 0xff) >> 2;
					   if( c0>bpos){ output[m]=xtag;output[++m]=b62x[c0]; }else{ output[m]=b62x[c0]; }
					   if( c1>bpos){ output[++m]=xtag;output[++m]=b62x[c1]; }else{ output[++m]=b62x[c1]; }
					   if( c2>bpos){ output[++m]=xtag;output[++m]=b62x[c2]; }else{ output[++m]=b62x[c2]; }
					   if( c3>bpos){ output[++m]=xtag;output[++m]=b62x[c3]; }else{ output[++m]=b62x[c3]; }
					   i+=2; 
				}
				m++;
			}
			while( ++i < inputlen); 
		}
	}
	else{
		/* try to decode */
		if(asctype == 1){
			//- for ascii
			inputlen--;
			do{
				if( isdebug){
					printf("i:[%d] n:[%d] char:[%c] ascidx:[%d] o:[%s]\n", i, input[i], 
						input[i], ascrlist[input[i]], &output); 
				}
				if( input[i] == xtag){
					if( input[i+1] == xtag){
						output[m] = xtag;      
						i++;
					}
					else{
					  output[m]=ascrlist[input[++i]];    
					}
				}
				else{
					output[m] = input[i];    
				}
				m++;
			}
			while(++i < inputlen);  
		}
		else{
			//- for non-ascii
			int c0=0; int c1=0; int c2=0; int k=0; 
			unsigned char tmpin[4];
			bint['1']=1; bint['2']=2; bint['3']=3; /* special handling with x1, x2, x3 *2 */
			do{
				char tmpin[4]={'\0','\0','\0','\0'};
				remaini = inputlen - i;
				k=0;
				if( isdebug){
					printf("i:[%d] n:[%d] char:[%c]\n", i, input[i], input[i]); 
				}
				switch( remaini){
					case 1:
						printf("  found illegal base62x input:[%s]!\n", input);
						break;

					case 2:
						if( isdebug){
							printf("  remn:[%d] should be the last one. i:[%d] char:[%c] inputlen:[%d]\n",
								remaini, i, input[i], inputlen);
						}
						if( input[i]==xtag){ tmpin[0] = bpos+bint[input[++i]]; k++; }else{ tmpin[0]=rb62x[input[i]]; }
						if( input[++i]==xtag){ tmpin[1] = bpos+bint[input[++i]]; k++; }else{ tmpin[1]=rb62x[input[i]]; }
						//c0 = tmpin[0] << 2 | tmpin[1] >> 4; 
						c0 = tmpin[0] << 2 | tmpin[1]; 
						output[m]=c0;
						if( isdebug){
							printf("\ti:[%d] decode char:[%c %c %c %c] from:[%d %d %d %d] to:[%c %c %c] val:[%d %d %d] k:[%d]\n", 
								i, input[i-3],input[i-2], input[i-1], input[i], tmpin[0], 
								tmpin[1], 0, 0, c0, 0, 0, c0, 0, 0, k);
						}
						break;

					case 3:
						if( isdebug){
							printf("  remn:[%d] get to the last two. i:[%d] char:[%c] inputlen:[%d]\n", 
								remaini, i, input[i], inputlen);
						}
						if( input[i]==xtag){ tmpin[0] = bpos+bint[input[++i]]; k++; }else{ tmpin[0]=rb62x[input[i]]; }
						if( input[++i]==xtag){ tmpin[1] = bpos+bint[input[++i]]; k++; }else{ tmpin[1]=rb62x[input[i]]; }
						if( input[++i]==xtag){ tmpin[2] = bpos+bint[input[++i]]; k++; }else{ tmpin[2]=rb62x[input[i]]; }
						c0 = tmpin[0] << 2 | tmpin[1] >> 4; 
						//c1 = ( ( tmpin[1] << 4) & 0xf0) | ( tmpin[2] >> 2 );
						c1 = ( ( tmpin[1] << 4) & 0xf0) | tmpin[2];
						output[m]=c0;
						output[++m]=c1;
						if( isdebug){
							printf("\ti:[%d] decode char:[%c %c %c %c] from:[%d %d %d %d] to:[%c %c %c] val:[%d %d %d] k:[%d]\n", 
								i, input[i-3],input[i-2], input[i-1], input[i], tmpin[0], 
								tmpin[1], tmpin[2], 0, c0, c1, 0, c0, c1, 0, k);
						}
						break;

					default:
						if( isdebug){
							printf("  continue as usual. i:[%d] inputlen:[%d]\n", i, inputlen);
						}
						if( input[i]==xtag){ tmpin[0] = bpos+bint[input[++i]]; k++; }else{ tmpin[0]=rb62x[input[i]]; }
						if( input[++i]==xtag){ tmpin[1] = bpos+bint[input[++i]]; k++; }else{ tmpin[1]=rb62x[input[i]]; }
						if( input[++i]==xtag){ tmpin[2] = bpos+bint[input[++i]]; k++; }else{ tmpin[2]=rb62x[input[i]]; }
						if( input[++i]==xtag){ tmpin[3] = bpos+bint[input[++i]]; k++; }else{ tmpin[3]=rb62x[input[i]]; }
						c0 = tmpin[0] << 2 | tmpin[1] >> 4; 
						c1 = ( ( tmpin[1] << 4) & 0xf0) | ( tmpin[2] >> 2 );
						c2 = ( ( tmpin[2] << 6) & 0xff) | tmpin[3];
						output[m]=c0;
						output[++m]=c1;
						output[++m]=c2;
						if( isdebug){
							printf("    i:[%d] decode char:[%c %c %c %c] from:[%d %d %d %d] to:[%c %c %c] val:[%d %d %d] k:[%d]\n", 
								i, input[i-3],input[i-2],input[i-1], input[i], tmpin[0], tmpin[1], tmpin[2], tmpin[3],
								c0, c1, c2, c0, c1, c2, k);
						}
				}
				m++;
			}
			while( ++i < inputlen);
		}
	}

	int k = strlen( output);
	if( isdebug){
		printf("---xxx -i:[%d] char:[%c]. m:[%d] getchar:[%c] arrsize:[%d] out-size:[%d]\n", i, input[i], 
			m, output[m], arrsize, strlen(output));
	}

	for( i=m; i<k; i++){
		output[i] = '\0';
	}

	if( isdebug){
		printf("\nOutput:[%s]\n", output);
		for( i=0; i<m; i++){
			printf("  ---i:[%d] char:[%c] val:[%d]\n", i, output[i], output[i]);
		}
	}
	else{
		//printf("%s\n", output);    
		printf("%s", output);    
	}

    //return i;
    return 0;

}


void *dec2xx(long long num, int base, char *out, char idx[]){
   
    int bpos = 60, xtag = 'x';
    int b=0, i=0;
    //printf("--bgn--out:[%s] orig:[%lld] base:[%d]\n", out, num, base); 
    while(num >= base){
        b = num % base;
        num = floor( num / base);
        if(b <= bpos){
            out[i++] = idx[b]; 
        }
        else{
            out[i++] = idx[b - bpos]; //- will be reversed later
            out[i++] = xtag;
        }
        //printf("--dec2xx-- out:[%s] orig:[%lld] base:[%d] mod:[%d]\n", out, num, base, b); 
    }

    if( num < bpos){
        out[i++] = idx[num];
    }
    else{
        out[i++] = idx[num - bpos]; //- will be reversed later
        out[i++] = xtag;
    }

    b = strlen(out);
    int j = i;
    for(; j<b; j++){
        out[j] = '\0';
    }
    //printf("--end--out:[%s] orig:[%lld] len:[%d]\n", out, num, strlen(out)); 
    
    reverse_array(out, strlen(out));
    //printf("--final-- out:[%s] orig:[%lld] len:[%d]\n", out, num, strlen(out)); 
    
    //return 0;

}


long long xx2dec(char *input, int base, int safebase, char ridx[]){
    
    int bpos = 60, xtag = 'x';
    int i=0, j=0, tmpnum;
    char *endptr;
    long long num = 0LL;

    if(base < safebase){
       num = strtoll(input, &endptr, base); 
    }
    else{
       i = strlen(input);
       //printf("--in xx2dec--i bgn input:[%s], out:[%lld] \n", input, num);
       reverse_array(input, i);
       //printf("--in xx2dec--i rev input:[%s], out:[%lld] \n", input, num);
       int xnum = 0; 
       for(j=0; j<i; j++){
            if(input[j+1] == xtag){
                tmpnum = bpos + ridx[input[j]];    
                xnum++;
                j++;
            }
            else{
                tmpnum = ridx[input[j]];
            }
            num += tmpnum*pow(base, j-xnum);
            //printf("--in xx2dec-- j:[%d], char:[%c] base:[%d] num:[%lld] xnum:[%d] tmpnum:[%d]\n",
            //    j, input[j], base, num, xnum, tmpnum);
       }
    }

    reverse_array(input, i);
    //printf("--in xx2dec-- fin input:[%s], out:[%lld] \n", input, num);
    
    return num;

}

//- ref: http://www.programmingsimplified.com/c-program-reverse-array
void reverse_array(char *pointer, int n){
    int *s, c, d;
    s = (int*)malloc(sizeof(int)*n);

    if( s == NULL ){
        exit(EXIT_FAILURE);
    }

    for( c = n - 1, d = 0 ; c >= 0 ; c--, d++ ){
        *(s+d) = *(pointer+c);
    }

    for( c = 0 ; c < n ; c++ ){
        *(pointer+c) = *(s+c);
    }

    free(s);

    //return 0;

}

