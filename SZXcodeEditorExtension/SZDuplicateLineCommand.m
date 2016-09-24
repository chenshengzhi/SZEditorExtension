//
//  SZDuplicateLineCommand.m
//  SZEditorExtension
//
//  Created by csz on 2016/9/24.
//  Copyright © 2016年 陈圣治. All rights reserved.
//

#import "SZDuplicateLineCommand.h"

@implementation SZDuplicateLineCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    if (lines.count == 0) {
        completionHandler(nil);
        return;
    }
    
    XCSourceTextRange *textRange = invocation.buffer.selections.firstObject;
    XCSourceTextPosition start = textRange.start;
    XCSourceTextPosition end = textRange.end;
    
    NSMutableArray *duplicateLines = [NSMutableArray array];
    for (NSInteger i = start.line; i <= end.line; i++) {
        [duplicateLines addObject:lines[i]];
    }
    NSString *text = [duplicateLines componentsJoinedByString:@""];
    [lines insertObject:text atIndex:start.line];
    
    completionHandler(nil);
}

@end
