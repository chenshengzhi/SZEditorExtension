//
//  SZDebugCodeCommand.m
//  SZXcodeEditorExtension
//
//  Created by Shengzhi.Chen on 2024/10/6.
//

#import "SZDebugCodeCommand.h"

@implementation SZDebugCodeCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    /// add `#if DEBUG` and `#endif` to selected lines
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    XCSourceTextRange *textRange = invocation.buffer.selections.firstObject;
    NSInteger start = textRange.start.line;
    NSInteger end = textRange.end.line;
    if (start > end) {
        NSInteger temp = start;
        start = end;
        end = temp;
    }
    [lines insertObject:@"#if DEBUG" atIndex:start];
    [lines insertObject:@"#endif" atIndex:end+2];
    completionHandler(nil);
}

@end
