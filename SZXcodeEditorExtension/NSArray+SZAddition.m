//
//  NSArray+SZAddition.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/6/16.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import "NSArray+SZAddition.h"

@implementation NSArray (SZAddition)

- (XCSourceTextRange *)methodStatementPositionsWithIndex:(NSInteger)index {
    NSInteger startLine = NSNotFound;
    NSInteger startColumn = 0;
    for (NSInteger idx = index; idx >= 0; idx--) {
        NSString *line = self[idx];
        NSRange range = [line rangeOfString:@"^ *[-+]{1} *\\(.+\\)" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            startLine = idx;
            
            range = [line rangeOfString:@"^ *" options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                startColumn = NSMaxRange(range);
            }
            break;
        }
    }
    
    if (startLine == NSNotFound) {
        return nil;
    }
    
    NSInteger endLine = NSNotFound;
    NSInteger endColumn = 0;
    for (NSInteger idx = startLine; idx < self.count; idx++) {
        NSString *line = self[idx];
        NSRange range = [line rangeOfString:@" *[;\\{]{1}" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            endLine = idx;
            endColumn = range.location;
            break;
        }
    }
    
    if (startLine < self.count && endLine < self.count) {
        XCSourceTextPosition startPosition = XCSourceTextPositionMake(startLine, startColumn);
        XCSourceTextPosition endPosition = XCSourceTextPositionMake(endLine, endColumn);
        XCSourceTextRange *textRange = [[XCSourceTextRange alloc] initWithStart:startPosition end:endPosition];
        return textRange;
    }
    return nil;
}

- (NSArray *)textArrayInTextRange:(XCSourceTextRange *)textRange {
    if (!textRange) {
        return nil;
    }
    
    NSInteger startLine = textRange.start.line;
    NSInteger startColumn = textRange.start.column;
    NSInteger endLine = textRange.end.line;
    NSInteger endColumn = textRange.end.column;
    
    if (startLine >= self.count || endLine >= self.count) {
        return nil;
    }
    if (endLine < startLine) {
        return nil;
    }
    
    if (startLine == endLine) {
        NSString *line = self[startLine];
        if (startColumn <= line.length && endColumn <= line.length) {
            NSString *text = [line substringWithRange:NSMakeRange(startColumn, endColumn - startColumn)];
            if (text) {
                return @[text];
            }
        }
        return nil;
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger idx = startLine; idx <= endLine; idx++) {
        NSString *line = self[idx];
        if (idx == startLine) {
            NSString *subText = [line substringFromIndex:startColumn];
            if (subText.length) {
                [tempArray addObject:subText];
            }
        } else if (idx < endLine) {
            [tempArray addObject:[line copy]];
        } else {
            NSString *subText = [line substringToIndex:endColumn];
            if (subText.length) {
                [tempArray addObject:subText];
            }
        }
    }
    return [tempArray copy];
}

@end