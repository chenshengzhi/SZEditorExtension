//
//  SZSelectMethodStatementCommand.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/6/16.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import "SZSelectMethodStatementCommand.h"
#import "NSArray+SZAddition.h"
#import "SZEditorExtensionHeader.h"
#import <AppKit/AppKit.h>

@implementation SZSelectMethodStatementCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    NSMutableArray<XCSourceTextRange *> *selections = invocation.buffer.selections;
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    
    XCSourceTextRange *textRange = [lines methodStatementPositionsWithIndex:selections.firstObject.start.line];
    if (textRange) {
        [selections removeAllObjects];
        [selections addObject:textRange];
    
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:SZEEUserdefaultSuiteName];
        BOOL withoutCopy = [defaults boolForKey:SZEESelectMethodWithoutCopyToPastBoardKey];
        if (!withoutCopy) {
            NSArray *textArray = [lines textArrayInTextRange:textRange];
            if (textArray.count) {
                NSString *text = [textArray componentsJoinedByString:@""];
                [[NSPasteboard generalPasteboard] clearContents];
                [[NSPasteboard generalPasteboard] writeObjects:@[text]];
            }
        }
    }
    
    completionHandler(nil);
}

@end
