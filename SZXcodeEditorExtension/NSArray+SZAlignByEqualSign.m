//
//  NSArray+SZAlignByEqualSign.m
//  SZEditorExtension
//
//  Created by csz on 2017/3/19.
//  Copyright © 2017年 陈圣治. All rights reserved.
//

#import "NSArray+SZAlignByEqualSign.h"
#import "NSString+SZAddition.h"

@implementation NSArray (SZAlignByEqualSign)

#pragma mark - align by equal sign -
- (BOOL)needAlignByEqualSign {
    NSUInteger equalSignCount = 0;
    for (NSString *lineText in self) {
        if ([lineText isAsignmentStatement]) {
            equalSignCount++;
        }
        
        if (equalSignCount > 1) {
            break;
        }
    }
    return (equalSignCount > 1);
}

- (NSArray *)alignedArrayByEqualSign {
    NSUInteger maxColumn = 0;
    BOOL has_equal_sign_lines[self.count];
    
    for (int idx = 0; idx < self.count; idx++) {
        NSString *lineText = self[idx];
        if ([lineText isAsignmentStatement]) {
            maxColumn = MAX(maxColumn, [lineText rangeOfString:@"="].location);
            has_equal_sign_lines[idx] = YES;
        } else {
            has_equal_sign_lines[idx] = NO;
        }
    }
    
    NSMutableArray *newArray = [NSMutableArray array];
    for (int i = 0; i < self.count; i++) {
        NSString *lineText = self[i];
        if (has_equal_sign_lines[i]) {
            NSRange range = [lineText rangeOfString:@"="];
            if (range.location < maxColumn) {
                NSString *paddingText = [@" " stringByPaddingToLength:maxColumn - range.location
                                                           withString:@" "
                                                      startingAtIndex:0];
                lineText = [lineText stringByReplacingCharactersInRange:NSMakeRange(range.location, 0)
                                                             withString:paddingText];
            }
        }
        [newArray addObject:lineText];
    }
    return [newArray copy];
}

- (NSInteger)insertIdexForInterface:(NSString *)interface position:(SZEEPropertyGetterPosition)position {
    NSInteger insertIndex = NSNotFound;
    for (NSInteger idx = 0; idx < self.count; idx++) {
        NSString *line = self[idx];
        if ([line isImplementationForInterface:interface]) {
            insertIndex = idx;
            break;
        }
    }
    
    if (insertIndex > self.count) {
        return NSNotFound;
    }
    
    if (position == SZEEPropertyGetterPositionImplementationStart) {
        return (insertIndex + 1);
    } else {
        for (NSInteger idx = insertIndex + 1; idx < self.count; idx++) {
            NSString *line = [self[idx] trimWhitespace];
            if ([line hasPrefix:@"@end"]) {
                return idx;
            }
        }
        return NSNotFound;
    }
}

@end
