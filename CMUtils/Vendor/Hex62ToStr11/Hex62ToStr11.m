//
//  Hex62ToStr11.m
//  CMUtils
//
//  Created by Jerry on 15/4/8.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "Hex62ToStr11.h"
#import "JKBigInteger.h"

@implementation Hex62ToStr11
//int char2int(char c)
//{
//    switch (c)
//    {
//        case '0':
//            return 0;
//        case '1':
//            return 1;
//        case '2':
//            return 2;
//        case '3':
//            return 3;
//        case '4':
//            return 4;
//        case '5':
//            return 5;
//        case '6':
//            return 6;
//        case '7':
//            return 7;
//        case '8':
//            return 8;
//        case '9':
//            return 9;
//        case 'a':
//            return 10;
//        case 'b':
//            return 11;
//        case 'c':
//            return 12;
//        case 'd':
//            return 13;
//        case 'e':
//            return 14;
//        case 'f':
//            return 15;
//        case 'g':
//            return 16;
//        case 'h':
//            return 17;
//        case 'i':
//            return 18;
//        case 'j':
//            return 19;
//        case 'k':
//            return 20;
//        case 'l':
//            return 21;
//        case 'm':
//            return 22;
//        case 'n':
//            return 23;
//        case 'o':
//            return 24;
//        case 'p':
//            return 25;
//        case 'q':
//            return 26;
//        case 'r':
//            return 27;
//        case 's':
//            return 28;
//        case 't':
//            return 29;
//        case 'u':
//            return 30;
//        case 'v':
//            return 31;
//        case 'w':
//            return 32;
//        case 'x':
//            return 33;
//        case 'y':
//            return 34;
//        case 'z':
//            return 35;
//        case 'A':
//            return 36;
//        case 'B':
//            return 37;
//        case 'C':
//            return 38;
//        case 'D':
//            return 39;
//        case 'E':
//            return 40;
//        case 'F':
//            return 41;
//        case 'G':
//            return 42;
//        case 'H':
//            return 43;
//        case 'I':
//            return 44;
//        case 'J':
//            return 45;
//        case 'K':
//            return 46;
//        case 'L':
//            return 47;
//        case 'M':
//            return 48;
//        case 'N':
//            return 49;
//        case 'O':
//            return 50;
//        case 'P':
//            return 51;
//        case 'Q':
//            return 52;
//        case 'R':
//            return 53;
//        case 'S':
//            return 54;
//        case 'T':
//            return 55;
//        case 'U':
//            return 56;
//        case 'V':
//            return 57;
//        case 'W':
//            return 58;
//        case 'X':
//            return 59;
//        case 'Y':
//            return 60;
//        case 'Z':
//            return 61;
//        default:
//            return -1;
//    }
//}
//
//char int2char(int i)
//{
//    switch (i)
//    {
//        case 0:
//            return '0';
//        case 1:
//            return '1';
//        case 2:
//            return '2';
//        case 3:
//            return '3';
//        case 4:
//            return '4';
//        case 5:
//            return '5';
//        case 6:
//            return '6';
//        case 7:
//            return '7';
//        case 8:
//            return '8';
//        case 9:
//            return '9';
//        case 10:
//            return 'a';
//        case 11:
//            return 'b';
//        case 12:
//            return 'c';
//        case 13:
//            return 'd';
//        case 14:
//            return 'e';
//        case 15:
//            return 'f';
//        case 16:
//            return 'g';
//        case 17:
//            return 'h';
//        case 18:
//            return 'i';
//        case 19:
//            return 'j';
//        case 20:
//            return 'k';
//        case 21:
//            return 'l';
//        case 22:
//            return 'm';
//        case 23:
//            return 'n';
//        case 24:
//            return 'o';
//        case 25:
//            return 'p';
//        case 26:
//            return 'q';
//        case 27:
//            return 'r';
//        case 28:
//            return 's';
//        case 29:
//            return 't';
//        case 30:
//            return 'u';
//        case 31:
//            return 'v';
//        case 32:
//            return 'w';
//        case 33:
//            return 'x';
//        case 34:
//            return 'y';
//        case 35:
//            return 'z';
//        case 36:
//            return 'A';
//        case 37:
//            return 'B';
//        case 38:
//            return 'C';
//        case 39:
//            return 'D';
//        case 40:
//            return 'E';
//        case 41:
//            return 'F';
//        case 42:
//            return 'G';
//        case 43:
//            return 'H';
//        case 44:
//            return 'I';
//        case 45:
//            return 'J';
//        case 46:
//            return 'K';
//        case 47:
//            return 'L';
//        case 48:
//            return 'M';
//        case 49:
//            return 'N';
//        case 50:
//            return 'O';
//        case 51:
//            return 'P';
//        case 52:
//            return 'Q';
//        case 53:
//            return 'R';
//        case 54:
//            return 'S';
//        case 55:
//            return 'T';
//        case 56:
//            return 'U';
//        case 57:
//            return 'V';
//        case 58:
//            return 'W';
//        case 59:
//            return 'X';
//        case 60:
//            return 'Y';
//        case 61:
//            return 'Z';
//        default:
//            return -1;
//    }
//}
//
////cString反转
//void reverse(char array[], int length)
//{
//    for (int i = 0 ; i < length / 2; i ++) {
//        char temp = array[i];
//        array[i] = array[length - i - 1];
//        array[length - i - 1] = temp;
//    }
//}
//
//+ (NSString *)int2str:(int)number hex:(int)hex
//{
//    char cStr11[20] = {0};
//    int divisor     = number;
//    int remainder   = 0;
//    int index       = 0;
//    do
//    {
//        remainder = divisor % hex;
//        divisor = divisor / hex;
//        cStr11[index] = int2char(remainder);
//        index++;
//    }while (divisor != 0);
//    cStr11[index] = '\0';
//    reverse(cStr11,strlen(cStr11));
//    NSString *result = [NSString stringWithUTF8String:cStr11];
//    return result;
//}
//
//+ (int)str2int:(NSString *)str hex:(int)hex
//{
//    const char *cStr = [str UTF8String];
//    size_t len       = strlen(cStr);
//    int i            = len;
//    char c           = 0;
//    int number       = 0;
//    while (i > 0)
//    {
//        c = cStr[i-1];
//        number += char2int(c) * pow(hex, (double)(len - i));
//        i--;
//    }
//    return number;
//}

+ (NSString *)str11Tostr62:(NSString *)str11
{
    JKBigInteger *bigInt62 = [[JKBigInteger alloc] initWithString:str11 andRadix:11];
    NSString *str = [bigInt62 stringValueWithRadix:62];
    return str;
}

+ (NSString *)str62Tostr11:(NSString *)str62
{
    JKBigInteger *bigInt62 = [[JKBigInteger alloc] initWithString:str62 andRadix:62];
    NSString *str = [bigInt62 stringValueWithRadix:11];
    return str;
}

+ (NSString *)str62Tostr16:(NSString *)str62
{
    JKBigInteger *bigInt62 = [[JKBigInteger alloc] initWithString:str62 andRadix:62];
    NSString *str = [bigInt62 stringValueWithRadix:16];
    return str;
}

@end
