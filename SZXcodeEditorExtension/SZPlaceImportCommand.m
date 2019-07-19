//
//  SZPlaceImportCommand.m
//  SZEditorExtension
//
//  Created by 陈圣治 on 01/11/2016.
//  Copyright © 2016 陈圣治. All rights reserved.
//

#import "SZPlaceImportCommand.h"
#import "NSString+SZAddition.h"
#import "NSArray+SZAddition.h"

@implementation SZPlaceImportCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    NSMutableArray <NSString *> *lines = invocation.buffer.lines;
    
    __block NSInteger insertIndex = 0;
    NSRange importRange = [lines sz_importLinesRange];
    if (importRange.location != NSNotFound) {
        insertIndex = NSMaxRange(importRange);
    }
    [invocation.buffer.selections enumerateObjectsUsingBlock:^(XCSourceTextRange *sourceTextRange, NSUInteger idx, BOOL *stop) {
        for (NSInteger i = sourceTextRange.start.line; i <= sourceTextRange.end.line; i++) {
            if (i <= insertIndex) {
                continue;
            }
            NSString *lineText = lines[i];
            if ([lineText sz_isImportLine]) {
                [lines removeObjectAtIndex:i];
                [lines insertObject:[lineText sz_trimWhitespace] atIndex:insertIndex];
                insertIndex++;
            }
        }
    }];
    
    NSString *fileName = [lines sz_fileNameByHeaderComments];
    if (!fileName.length) {
        completionHandler(nil);
        return;
    }
    
    importRange = [lines sz_importLinesRange];
    if (importRange.location == NSNotFound) {
        completionHandler(nil);
        return;
    }
    
    fileName = [fileName stringByDeletingPathExtension];
    NSString *className = [fileName componentsSeparatedByString:@"+"].firstObject;
    
    NSArray *subLines = [lines subarrayWithRange:importRange];
    subLines = [[NSSet setWithArray:subLines] allObjects];
    NSMutableArray<NSString *> *importLineArray = [subLines mutableCopy];
    [lines removeObjectsInRange:importRange];
    
    /// 移除空白行
    for (NSInteger idx = 0; idx < importLineArray.count; idx++) {
        NSString *line = [importLineArray[idx] sz_trimWhitespaceAndNewline];
        if (!line.length) {
            [importLineArray removeObjectAtIndex:idx];
            idx--;
        }
    }
    
    [importLineArray sortUsingSelector:@selector(compare:)];
    [importLineArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        if ([obj1 containsString:className]) {
            return NSOrderedAscending;
        } else if ([obj2 containsString:className]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    [importLineArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        if ([obj1 containsString:fileName]) {
            return NSOrderedAscending;
        } else if ([obj2 containsString:fileName]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    importRange.length = importLineArray.count;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:importRange];
    [lines insertObjects:importLineArray atIndexes:indexSet];
    
    completionHandler(nil);
}

@end
