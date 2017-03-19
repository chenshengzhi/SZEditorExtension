//
//  NSString+SZAddition.m
//  SZEditorExtension
//
//  Created by csz on 2017/3/19.
//  Copyright © 2017年 陈圣治. All rights reserved.
//

#import "NSString+SZAddition.h"

static inline BOOL isSyntaxChar(unichar theChar) {
    if (theChar >= 128) {
        return NO;
    }
    
    if ((theChar == ' ')
        || (theChar >= '0' && theChar <= '9')
        || (theChar >= 'a' && theChar <= 'z')
        || (theChar >= 'A' && theChar <= 'Z')) {
        return NO;
    }
    
    return YES;
}

@implementation NSString (SZAddition)

- (BOOL)isAsignmentStatement {
    NSString *compacted = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([compacted hasPrefix:@"for("]) {
        return NO;
    }
    
    NSRange range = [self rangeOfString:@"="];
    if (range.location >= self.length) {
        return NO;
    }
    
    NSUInteger loc = range.location;
    unichar nextChar = [self characterAtIndex:loc+1];
    unichar preChar = [self characterAtIndex:loc-1];
    
    if (!isSyntaxChar(nextChar) && !isSyntaxChar(preChar)) {
        return YES;
    }
    
    return NO;
}

@end
