//
//  NSString+trimSpecialCharacter.m
//  ADN
//
//  Created by Le Ngoc Duy on 12/2/13.
//  Copyright (c) 2013 Le Ngoc Duy. All rights reserved.
//

#import "NSString+trimSpecialCharacter.h"

@implementation NSString (Ultility)
-(NSString *)trimSpecialCharacter
{
    NSMutableString *asciiCharacters = [NSMutableString string];
    for (NSInteger i = 32; i < 127; i++)  {
        [asciiCharacters appendFormat:@"%c", i];
    }
    NSCharacterSet *nonAsciiCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:asciiCharacters] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:nonAsciiCharacterSet] componentsJoinedByString:@""];
}

- (NSString*) reverseString
{
    NSMutableString *reversedStr;
    int len = [self length];
    
    // auto released string
    reversedStr = [NSMutableString stringWithCapacity:len];
    
    // quick-and-dirty implementation
    while ( len > 0 )
        [reversedStr appendString:[NSString stringWithFormat:@"%C",[self characterAtIndex:--len]]];
    
    return reversedStr;
}

- (BOOL) isAllDigits
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}
@end