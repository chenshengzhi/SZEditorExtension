//
//  SZAlignCommand.m
//  SZEditorExtension
//
//  Created by csz on 2017/3/19.
//  Copyright © 2017年 陈圣治. All rights reserved.
//

#import "SZAlignCommand.h"
#import "NSArray+SZAlignByEqualSign.h"

@implementation SZAlignCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    if (lines.count == 0 || invocation.buffer.selections.count == 0) {
        completionHandler(nil);
        return;
    }

    for (XCSourceTextRange *selectionTextRange in invocation.buffer.selections) {
        XCSourceTextPosition start = selectionTextRange.start;
        XCSourceTextPosition end = selectionTextRange.end;
        NSRange selectedLineRange = NSMakeRange(start.line, end.line - start.line + 1);
        NSArray *selectedLines = [lines subarrayWithRange:selectedLineRange];
        
        if ([selectedLines sz_needAlignByEqualSign]) {
            NSArray *newSelectedLines = [selectedLines sz_alignedArrayByEqualSign];
            [lines replaceObjectsInRange:selectedLineRange withObjectsFromArray:newSelectedLines];
        }
    }
    
    completionHandler(nil);
}

@end
