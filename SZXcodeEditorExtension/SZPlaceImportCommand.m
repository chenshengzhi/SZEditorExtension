//
//  SZPlaceImportCommand.m
//  SZEditorExtension
//
//  Created by Neil on 01/11/2016.
//

#import "SZPlaceImportCommand.h"
#import "NSArray+SZAddition.h"
#import "NSArray+SZXCSourceTextRange.h"
#import "NSString+SZAddition.h"
#import "SZCommandConstants.h"
#import "SZPlaceImportHelper.h"
#import "SZSourceTextRange.h"

@implementation SZPlaceImportCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    NSArray<SZSourceTextRange *> *selections = [invocation.buffer.selections sz_bridgedSourceTextRanges];
    NSArray *result = [SZPlaceImportHelper processLines:invocation.buffer.lines
                                             selections:selections
                                      commandIdentifier:invocation.commandIdentifier];
    [invocation.buffer.lines removeAllObjects];
    [invocation.buffer.lines addObjectsFromArray:result];
    
    completionHandler(nil);
}

@end
