//
//  SZClassExtensionCommand.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/8/25.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import "SZClassExtensionCommand.h"
#import "NSArray+SZAddition.h"
#import "NSError+SZAddition.h"

@implementation SZClassExtensionCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    NSMutableArray<XCSourceTextRange *> *selections = invocation.buffer.selections;
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    
    NSError *error = nil;
    if (selections.count) {
        __block NSString *impName = nil;
        __block NSInteger impIndex = NSNotFound;
        [lines sz_firstImplementationNameWithFromIndex:selections.firstObject.start.line block:^(NSString *name, NSInteger index) {
            impName = name;
            impIndex = index;
        }];
        
        if (impName.length) {
            BOOL has = [lines sz_hasExtensionWithName:impName fromIndex:impIndex];
            if (has) {
                error = [NSError sz_errorWithLocalizedDescription:@"Class extension exist already."];
            } else {
                NSString *insertText = [NSString stringWithFormat:@"@interface %@ ()\n\n@end\n\n", impName];
                [lines insertObject:insertText atIndex:impIndex];
            }
        }
    }
    
    completionHandler(error);
}

@end
