//
//  SZPropertyReadonlyCommand.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/8/2.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import "SZPropertyReadonlyCommand.h"
#import "NSString+SZAddition.h"

@implementation SZPropertyReadonlyCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    
    [invocation.buffer.selections enumerateObjectsUsingBlock:^(XCSourceTextRange *textRange, NSUInteger idx, BOOL * _Nonnull stop) {
        XCSourceTextPosition start = textRange.start;
        XCSourceTextPosition end = textRange.end;
        for (NSUInteger idx = start.line; idx <= end.line; idx++) {
            NSString *text = lines[idx];
            if ([text sz_isPropertyLine]) {
                text = [text sz_readonlyPropertyLine];
                [lines replaceObjectAtIndex:idx withObject:text];
            }
        }
    }];
    
    completionHandler(nil);
}

@end
