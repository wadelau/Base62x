/*
 * -Base62x class in C++
 * work with base62x.cpp
 * Wadelau@{ufqi,hotmail}.com
 * Refers to 
 	http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=6020065
 	-GitHub-Wadelau , base62x.c
 	https://github.com/wadelau/Base62x
 	https://ufqi.com/dev/base62x/?_via=-naturedns
 * v1.0, Mon Feb 17 03:26:48 UTC 2020
 */

#include <iostream>
# include <string>
# include <cstring>
# include <sstream>
# include <cstdlib>

using namespace std;

class Base62x {

    //- variables
    public:
        bool isdebug;
        int i;
    int codetype; //- 0:encode; 1: decode
    static const char xtag = 'x';
    string enc;
    string dec;
    string deg;
    string cvtn;
    string b62x;
    static const int bpos = 60; /* 0-60 chars */
    static const int xpos = 64; /* b62x[64] = 'x' */
    unsigned char rb62x[xpos*2]; /* reverse in decode block */
    int bint[xpos]; /* special handling for x1, x2, x3 *1 */
    static const int ascmax = 127;
    string asclist;
    int ascidx[ascmax+1];
    int ascrlist[ascmax+1]; 
    static const int max_safe_base = 36;
    static const float ver = 1.2; //  Mon Feb 17 03:38:49 UTC 2020

    //- constructor
    Base62x(){
        //- init.
        isdebug = true;
        codetype = 0;
        enc = "-enc";
        dec = "-dec";
        deg = "-v";
        cvtn = "-n";
        b62x = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwyz123x";
        asclist = "4567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwyz";
    }

    //- methods, public
    public:
    char* encode(char* input, int ibase){
        char* output;
        //- @todo

        return output;
    }

    public:
    char* decode(char* input, int obase){
        char* output;
        //- @todo

        return output;
    }

    public:
    int xx2dec(unsigned char *input, int base, int safebase, unsigned char ridx[]){
        return i;
    }

    public:
    void dec2xx(long long num, int base, unsigned char *out, char idx[]){
        i = num;
    }   

    //- methods, private
    private:
    long getNum(char* x){
        long l = 0;
        return l;
    }

};
