//
//  SZDeleteLineCommand.m
//  SZEditorExtension
//
//  Created by csz on 2016/9/24.
//

#import "SZDeleteLineCommand.h"

@implementation SZDeleteLineCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler {
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    if (lines.count == 0) {
        completionHandler(nil);
        return;
    }
    
    XCSourceTextRange *textRange = invocation.buffer.selections.firstObject;
    XCSourceTextPosition start = textRange.start;
    XCSourceTextPosition end = textRange.end;

    NSInteger newLine = 0;
    NSInteger newColumn = 0;
    
    if (end.line < lines.count - 1) {
        newLine = end.line + 1;
        newColumn = end.column;
    } else if (start.line > 0) {
        newLine = start.line - 1;
        newColumn = start.column;
    } else {
        newLine = 0;
        newColumn = 0;
    }
    
    if (lines[newLine].length <= newColumn) {
        newColumn = lines[newLine].length - 1;
    }
    textRange.start = XCSourceTextPositionMake(newLine, newColumn);
    textRange.end = textRange.start;
    NSUInteger count = end.line - start.line + 1;
    count = MIN(count, lines.count - start.line);
    [lines removeObjectsInRange:NSMakeRange(start.line, count)];
    
    completionHandler(nil);
}

@end
