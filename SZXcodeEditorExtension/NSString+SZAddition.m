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

- (NSString *)trimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

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

- (void)propertyDeclarationInfoWithBlock:(void (^)(BOOL, BOOL, NSString *, NSString *))block {
    if (!block) {
        return;
    }
    
    NSRange range = [self rangeOfString:@"@property"];
    if (range.location == NSNotFound) {
        block(NO, NO, nil, nil);
        return;
    }
    
    NSMutableString *mutableString = [self mutableCopy];
    [mutableString deleteCharactersInRange:range];
    
    /// do not support block
    
    range = [mutableString rangeOfString:@"\\(.*\\)" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        [mutableString deleteCharactersInRange:range];
    }
    
    range = [mutableString rangeOfString:@"<.*>" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        [mutableString deleteCharactersInRange:range];
    }
    
    BOOL isPointer = [mutableString rangeOfString:@"*"].location != NSNotFound;
    
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet whitespaceCharacterSet];
    [characterSet addCharactersInString:@"*;"];
    NSMutableArray<NSString *> *tokenArray = [[mutableString componentsSeparatedByCharactersInSet:characterSet] mutableCopy];
    NSIndexSet *indexSet = [tokenArray indexesOfObjectsPassingTest:^BOOL(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return (obj.length == 0);
    }];
    [tokenArray removeObjectsAtIndexes:indexSet];
    
    if (tokenArray.count >= 2) {
        block(YES, isPointer, tokenArray[0], tokenArray[1]);
    } else {
        block(NO, NO, nil, nil);
    }
}

- (BOOL)isPropertyLine {
    return [[self trimWhitespace] hasPrefix:@"@property"];
}

- (BOOL)isInterfaceLine {
    return [[self trimWhitespace] hasPrefix:@"@interface"];
}

- (BOOL)isImplementationLine {
    return [[self trimWhitespace] hasPrefix:@"@implementation"];
}

- (BOOL)isMethodStartLine {
    return [self rangeOfString:@"^ *[-+]{1} *\\(.+\\)" options:NSRegularExpressionSearch].location != NSNotFound;
}

- (NSString *)interfaceName {
    NSRange range = [self rangeOfString:@"@interface"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableString *mutableString = [self mutableCopy];
    [mutableString deleteCharactersInRange:range];
    
    range = [mutableString rangeOfString:@"\\(.*\\)" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        [mutableString deleteCharactersInRange:range];
    }
    
    range = [mutableString rangeOfString:@"<.*>" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        [mutableString deleteCharactersInRange:range];
    }
    
    NSString *string = [mutableString trimWhitespace];
    return [string componentsSeparatedByString:@" "].firstObject;
}

- (BOOL)isImplementationForInterface:(NSString *)interface {
    if (!interface.length) {
        return NO;
    }
    
    NSString *text = [NSString stringWithFormat:@"@implementation +%@ *$", interface];
    NSRange range = [self rangeOfString:text options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    
    text = [NSString stringWithFormat:@"@implementation +%@ *[(\\{]", interface];
    range = [self rangeOfString:text options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

- (NSString *)readonlyPropertyLine {
    if ([self isPropertyLine]) {
        /// 非贪婪匹配
        NSRange range = [self rangeOfString:@"\\(.*?\\)" options:NSRegularExpressionSearch];
        if (range.location == NSNotFound) {
            range = [self rangeOfString:@"@property"];
            NSMutableString *text = [self mutableCopy];
            [text insertString:@" (readonly)" atIndex:NSMaxRange(range)];
            return [text copy];
        } else {
            NSString *subText = [self substringWithRange:NSMakeRange(range.location + 1, range.length - 2)];
            NSMutableArray *array = [[subText componentsSeparatedByString:@","] mutableCopy];
            for (NSUInteger idx = 0; idx < array.count; idx++) {
                array[idx] = [array[idx] trimWhitespace];
            }
            NSArray *toRemoveArray = @[@"strong", @"weak", @"copy", @"retain", @"assign", @"unsafe_unretained", @"readonly"];
            [array removeObjectsInArray:toRemoveArray];
            [array addObject:@"readonly"];
            subText = [array componentsJoinedByString:@", "];
            subText = [NSString stringWithFormat:@"(%@)", subText];
            NSString *text = [self stringByReplacingCharactersInRange:range withString:subText];
            return text;
        }
    } else {
        return self;
    }
}

@end
