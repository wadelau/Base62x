/*
 * -Base62x test in C++
 * need Base62x.class.hpp
 * Wadelau@{ufqi,hotmail}.com
 * Refers to 
 	http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=6020065
 	-GitHub-Wadelau , base62x.c
 	https://github.com/wadelau/Base62x
 	https://ufqi.com/dev/base62x/?_via=-naturedns
 * v1.2, Mon Feb 17 03:26:48 UTC 2020
 */

# include <iostream>
# include <string>
# include <cstring>
# include <sstream>
# include <cstdlib>
# include "Base62x.class.hpp"

using namespace std;

int isdebug = 1; /* output more details? */

//- app entry
int main(int argc, char *argv[]){
    
    static const float ver = 1.2; //  Mon Feb 17 03:38:49 UTC 2020

    if(argc<3){
		cout << "Usage: " << argv[0] << " [-v] [-n <2|8|10|16|32|36|60|62>] <-enc|dec> string\n";
		cout << "Version: " << ver << "\n"; 
		return 1;
    }
    
    Base62x myb62x; // main obj

    int i = 0;
    char *tmpin = argv[argc-1]; // src from command line
    stringstream strval;
    strval << tmpin;
	unsigned char *input;
    strval >> input;

    char *code; //argv[1];
	int asctype = 0; // for ascii 
	int issetv = 0; // verbose
	int issetn = 0; // num conv
	int fbase = 2; // from num base
    int codetype = myb62x.codetype;
    string enc = myb62x.enc;
    string dec = myb62x.dec;
    string deg = myb62x.deg;
    string cvtn = myb62x.cvtn;

	for(i=0; i<argc; i++){
		code = argv[i];
		if(code==cvtn){
			issetn = 1; i++;
			fbase = atoi(argv[i]);
			if(isdebug){
				cout << "--xx-- code:[" << code << "] fbase:[" << fbase  << "] " << argv[i] << "\n";
			}
		}
		else if(code==deg){
			issetv = 1;
			isdebug = 1;
		}
		else if(code==enc){
			if(isdebug){
				cout << "it is to enc!\n";
			}   
		}
		else if(code==dec){
			if( isdebug){
				cout << "it is to dec!\n";
			}
			codetype = 1;
		}
	}
    
    int inputlen = strlen(tmpin); // input
	int inputlenx = strnlen(tmpin, inputlen+1); // try to contain null byte
	inputlen = inputlenx>(inputlen+1) ? inputlenx : inputlen;
	int arrsize = (int)inputlen * 2; // log(fbase) / log(xpos) + 1;  
	unsigned char output[arrsize]; //*output[ arrsize ] 

	//- for enc

    //- for dec
		
    cout << "Hello Wolrd!" << argc << "\n";
    cout << "\n";

    for(int i=1; i<argc; i++){
        string arg = argv[i];
        cout << i << ": " << arg << "\n";
    }

    return 0;

}
