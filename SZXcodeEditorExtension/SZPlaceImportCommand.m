//
//  SZPlaceImportCommand.m
//  SZEditorExtension
//
//  Created by 陈圣治 on 01/11/2016.
//  Copyright © 2016 陈圣治. All rights reserved.
//

#import "SZPlaceImportCommand.h"

@interface NSString (SZPlaceImportCommand)

- (BOOL)isImportLine;

@end

@implementation NSString (SZPlaceImportCommand)

- (BOOL)isImportLine {
    return [self hasPrefix:@"import"] || [self hasPrefix:@"@import"] || [self hasPrefix:@"#import"];
}

@end


@implementation SZPlaceImportCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    XCSourceTextBuffer *buffer = invocation.buffer;
    
    XCSourceTextRange *sourceTextRange = buffer.selections.firstObject;

    NSInteger lineIndex = sourceTextRange.start.line;
    NSString *lineText = buffer.lines[lineIndex];

    NSString *trimedLineText = [lineText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([trimedLineText isImportLine]) {
        buffer.selections.firstObject.end = buffer.selections.firstObject.start;
        [buffer.lines removeObjectAtIndex:lineIndex];

        NSInteger insertIndex = [self findInsertIndexWithLines:buffer.lines];
        [buffer.lines insertObject:trimedLineText atIndex:insertIndex];
    }

    completionHandler(nil);
}

- (NSInteger)findInsertIndexWithLines:(NSArray<NSString *> *)lines {
    NSInteger otherImportIndex = -1;
    NSInteger otherDefineIndex = -1;

    for (NSInteger idx = 0; idx < lines.count; idx++) {
        NSString *lineText = lines[idx];
        NSString *trimedLineText = [lineText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimedLineText.length > 0) {
            if ([trimedLineText isImportLine]) {
                otherImportIndex = idx;
            } else if (![trimedLineText hasPrefix:@"//"]) {
                otherDefineIndex = idx;
                break;
            }
        }
    }

    if (otherImportIndex >= 0) {
        return otherImportIndex + 1;
    } else if (otherDefineIndex >= 0) {
        return MAX(0, otherDefineIndex - 1);
    } else {
        return 0;
    }
}

@end
