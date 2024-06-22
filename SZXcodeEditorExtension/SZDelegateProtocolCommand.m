//
//  SZDelegateProtocolCommand.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/9/23.
//

#import "SZDelegateProtocolCommand.h"
#import "NSMutableArray+SZDelegateProtocol.h"

@implementation SZDelegateProtocolCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    NSMutableArray<XCSourceTextRange *> *selections = invocation.buffer.selections;
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    
    if (selections.count) {
        [lines sz_addDelegateProtocolFromIndex:selections.firstObject.start.line completion:^(BOOL success, NSError *error) {
            completionHandler(error);
        }];
    } else {
        completionHandler(nil);
    }
}

@end
