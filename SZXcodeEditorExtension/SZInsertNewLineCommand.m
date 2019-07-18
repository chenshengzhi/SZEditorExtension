//
//  SZInsertNewLineCommand.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2019/7/18.
//  Copyright © 2019 陈圣治. All rights reserved.
//

#import "SZInsertNewLineCommand.h"
#import "SZCommandConstants.h"
#import "NSString+SZAddition.h"

@implementation SZInsertNewLineCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    if ([invocation.commandIdentifier isEqualToString:SZInsertNewLineBeforeCommandIdentifier]) {
        XCSourceTextRange *textRange = invocation.buffer.selections.firstObject;
        NSInteger index = textRange.start.line;
        NSMutableArray<NSString *> *lines = invocation.buffer.lines;
        NSString *text = [lines[index] sz_whiteSpacePrefix];
        [lines insertObject:text atIndex:index];
        
        textRange.start = XCSourceTextPositionMake(index, text.length);
        textRange.end = textRange.start;
    } else {
        XCSourceTextRange *textRange = invocation.buffer.selections.lastObject;
        NSInteger index = textRange.end.line;
        NSMutableArray<NSString *> *lines = invocation.buffer.lines;
        NSString *text = [lines[index] sz_whiteSpacePrefix];
        NSInteger nextIndex = index + 1;
        [lines insertObject:text atIndex:nextIndex];
        
        textRange.start = XCSourceTextPositionMake(nextIndex, text.length);
        textRange.end = textRange.start;
    }
    
    completionHandler(nil);
}

- (NSString *)whiteSpacePrefixInLine:(NSString *)text {
    NSRange range = [text rangeOfString:@" +" options:NSRegularExpressionSearch];
    return [text substringWithRange:range];
}

@end
