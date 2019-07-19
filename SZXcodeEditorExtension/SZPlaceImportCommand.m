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
#import "SZCommandConstants.h"

@implementation SZPlaceImportCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    NSMutableArray <NSString *> *lines = invocation.buffer.lines;
    
    __block NSInteger insertIndex = 0;
    NSRange importRange = [lines sz_importLinesRange];
    if (importRange.location != NSNotFound) {
        insertIndex = NSMaxRange(importRange);
    }
    
    NSString *selectingClassName = nil;
    if (invocation.buffer.selections.count == 1) {
        XCSourceTextRange *textRange = invocation.buffer.selections.firstObject;
        XCSourceTextPosition start = textRange.start;
        XCSourceTextPosition end = textRange.end;
        if (start.line == end.line) {
            NSString *line = invocation.buffer.lines[textRange.start.line];
            NSRange range = NSMakeRange(start.column, end.column - start.column);
            NSString *selectedText = [line substringWithRange:range];
            NSString *patten = @"^[a-zA-Z0-9]+$";
            NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:patten options:0 error:nil];
            NSInteger matchCount = [expression numberOfMatchesInString:selectedText
                                                               options:0
                                                                 range:NSMakeRange(0, selectedText.length)];
            if (matchCount) {
                selectingClassName = selectedText;
            }
        }
    }
    if (selectingClassName) {
        NSString *lineNew = nil;
        if ([invocation.commandIdentifier isEqualToString:SZPlaceImportCommandIdentifier]) {
            lineNew = [NSString stringWithFormat:@"#import \"%@.h\"", selectingClassName];
        } else {
            lineNew = [NSString stringWithFormat:@"#import <%@.h>", selectingClassName];
        }
        [lines insertObject:lineNew atIndex:insertIndex];
        insertIndex++;
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
