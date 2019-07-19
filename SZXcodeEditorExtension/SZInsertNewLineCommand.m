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
    NSInteger index = 0;
    XCSourceTextRange *textRange = nil;
    if ([invocation.commandIdentifier isEqualToString:SZInsertNewLineBeforeCommandIdentifier]) {
        textRange = invocation.buffer.selections.firstObject;
        index = textRange.start.line;
    } else {
        textRange = invocation.buffer.selections.lastObject;
        index = textRange.end.line + 1;
        index = MIN(index, invocation.buffer.lines.count - 1);
    }
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    NSString *text = [lines[index] sz_whiteSpacePrefix];
    [lines insertObject:text atIndex:index];
    
    textRange.start = XCSourceTextPositionMake(index, text.length);
    textRange.end = textRange.start;
    
    completionHandler(nil);
}

- (NSString *)whiteSpacePrefixInLine:(NSString *)text {
    NSRange range = [text rangeOfString:@" +" options:NSRegularExpressionSearch];
    return [text substringWithRange:range];
}

@end
