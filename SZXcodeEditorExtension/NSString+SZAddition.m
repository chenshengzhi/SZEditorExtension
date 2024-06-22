//
//  NSString+SZAddition.m
//  SZEditorExtension
//
//  Created by csz on 2017/3/19.
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

- (NSString *)sz_trimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)sz_trimWhitespaceAndNewline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)sz_isImportLine {
    NSString *text = [self sz_trimWhitespaceAndNewline];
    return ([text hasPrefix:@"import"] || [text hasPrefix:@"@import"] || [text hasPrefix:@"#import"] || [text hasPrefix:@"#include"]);
}

- (BOOL)sz_isAsignmentStatement {
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

- (void)sz_propertyDeclarationInfoWithBlock:(void (^)(BOOL, BOOL, NSString *, NSString *))block {
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

- (BOOL)sz_isPropertyLine {
    return [[self sz_trimWhitespace] hasPrefix:@"@property"];
}

- (BOOL)sz_isInterfaceLine {
    return [[self sz_trimWhitespace] hasPrefix:@"@interface"];
}

- (BOOL)sz_isImplementationLine {
    return [[self sz_trimWhitespace] hasPrefix:@"@implementation"];
}

- (BOOL)sz_isMethodStartLine {
    return [self rangeOfString:@"^ *[-+]{1} *\\(.+\\)" options:NSRegularExpressionSearch].location != NSNotFound;
}

- (NSString *)sz_interfaceName {
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
    
    NSString *string = [mutableString sz_trimWhitespace];
    return [string componentsSeparatedByString:@" "].firstObject;
}

- (NSString *)sz_implementationName {
    NSRange range = [self rangeOfString:@"@implementation"];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableString *mutableString = [self mutableCopy];
    [mutableString deleteCharactersInRange:range];
    
    range = [mutableString rangeOfString:@"\\{" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        [mutableString deleteCharactersInRange:range];
    }
    
    NSString *string = [mutableString sz_trimWhitespaceAndNewline];
    return string;
}

- (BOOL)sz_isImplementationForInterface:(NSString *)interface {
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

- (BOOL)sz_isExtensionForInterface:(NSString *)interface {
    if (!interface.length) {
        return NO;
    }
    
    NSString *text = [NSString stringWithFormat:@"@interface +%@ *\\(\\)$", interface];
    NSRange range = [[self sz_trimWhitespace] rangeOfString:text options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    
    return NO;
}

- (NSString *)sz_readonlyPropertyLine {
    if ([self sz_isPropertyLine]) {
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
                array[idx] = [array[idx] sz_trimWhitespace];
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

- (NSString *)sz_antiReadonlyPropertyLine {
    if ([self sz_isPropertyLine]) {
        /// 非贪婪匹配
        NSRange range = [self rangeOfString:@"\\(.*?\\)" options:NSRegularExpressionSearch];
        if (range.location == NSNotFound) {
            return self;
        } else {
            NSString *subText = [self substringWithRange:NSMakeRange(range.location + 1, range.length - 2)];
            NSMutableArray *array = [[subText componentsSeparatedByString:@","] mutableCopy];
            for (NSUInteger idx = 0; idx < array.count; idx++) {
                array[idx] = [array[idx] sz_trimWhitespace];
            }
            [array removeObject:@"readonly"];
            NSString *declareText = [self substringFromIndex:NSMaxRange(range)];
            if ([declareText containsString:@"*"]) {
                [array addObject:@"strong"];
            }
            subText = [array componentsJoinedByString:@", "];
            subText = [NSString stringWithFormat:@"(%@)", subText];
            NSString *text = [self stringByReplacingCharactersInRange:range withString:subText];
            return text;
        }
    } else {
        return self;
    }
}

- (NSString *)sz_whiteSpacePrefix {
    NSRange range = [self rangeOfString:@" +" options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        return @"";
    }
    return [self substringWithRange:range];
}

- (BOOL)sz_isDirectory {
    if (!self.length) {
        return NO;
    }
    BOOL isDirectory = NO;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self isDirectory:&isDirectory];
    return (exist && isDirectory);
}

- (BOOL)sz_isFileExist {
    if (!self.length) {
        return NO;
    }
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:self isDirectory:NULL];
    return exist;
}

@end
