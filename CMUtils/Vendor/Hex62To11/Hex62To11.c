//
//  Hex62To11.c
//  iBoost
//
//  Created by Jerry on 14-7-1.
//  Copyright (c) 2014年 Jerry. All rights reserved.
//

#include <stdio.h>
#import <string.h>
#import <math.h>
#import <stdlib.h>
char *cStr2Str11(const char *str);
int char2int(char c)
{
    switch (c)
    {
        case '0':
            return 0;
        case '1':
            return 1;
        case '2':
            return 2;
        case '3':
            return 3;
        case '4':
            return 4;
        case '5':
            return 5;
        case '6':
            return 6;
        case '7':
            return 7;
        case '8':
            return 8;
        case '9':
            return 9;
        case 'a':
            return 10;
        case 'b':
            return 11;
        case 'c':
            return 12;
        case 'd':
            return 13;
        case 'e':
            return 14;
        case 'f':
            return 15;
        case 'g':
            return 16;
        case 'h':
            return 17;
        case 'i':
            return 18;
        case 'j':
            return 19;
        case 'k':
            return 20;
        case 'l':
            return 21;
        case 'm':
            return 22;
        case 'n':
            return 23;
        case 'o':
            return 24;
        case 'p':
            return 25;
        case 'q':
            return 26;
        case 'r':
            return 27;
        case 's':
            return 28;
        case 't':
            return 29;
        case 'u':
            return 30;
        case 'v':
            return 31;
        case 'w':
            return 32;
        case 'x':
            return 33;
        case 'y':
            return 34;
        case 'z':
            return 35;
            
        case 'A':
            return 36;
        case 'B':
            return 37;
        case 'C':
            return 38;
        case 'D':
            return 39;
        case 'E':
            return 40;
        case 'F':
            return 41;
        case 'G':
            return 42;
        case 'H':
            return 43;
        case 'I':
            return 44;
        case 'J':
            return 45;
        case 'K':
            return 46;
        case 'L':
            return 47;
        case 'M':
            return 48;
        case 'N':
            return 49;
        case 'O':
            return 50;
        case 'P':
            return 51;
        case 'Q':
            return 52;
        case 'R':
            return 53;
        case 'S':
            return 54;
        case 'T':
            return 55;
        case 'U':
            return 56;
        case 'V':
            return 57;
        case 'W':
            return 58;
        case 'X':
            return 59;
        case 'Y':
            return 60;
        case 'Z':
            return 61;
        default:
            return -1;
    }
}

int str2int(const char *str)
{
    size_t len = strlen(str);
    int i = len;
    char c;
    int bigNumber = 0;
    while (i > 0)
    {
        c = str[i-1];
        bigNumber += char2int(c) * pow(62.0, (double)(len - i));
        i--;
    }
    return bigNumber;
}

void reverseArray(char str[])
{
    char reverse[10] = {};
    int len = strlen(str)-1;
    
    for (int i = 0; i <= len; i++)
    {
        reverse[i] = str[len-i];
    }
    for (int i = 0; i <= len; i++)
    {
        str[i] = reverse[i];
    }
}

/*********一定要释放内存***********/
char *cStr2Str11(const char *str)
{
    char List[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a'};
    
    char *str11 = (char *)malloc(10 * sizeof(char));
    int bigNumber = str2int(str);
    int divisor = bigNumber;
    int remainder;
    int index = 0;
    do
    {
        remainder = divisor % 11;
        divisor = divisor / 11;
        str11[index] = List[remainder];
        index++;
    }while (divisor != 0);
    str11[index] = '\0';
    reverseArray(str11);
    return str11;
}
