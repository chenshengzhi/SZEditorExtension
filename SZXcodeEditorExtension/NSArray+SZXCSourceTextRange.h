//
//  NSArray+SZXCSourceTextRange.h
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/8/26.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XCSourceTextRange.h>
@class SZSourceTextRange;

@interface NSArray (SZXCSourceTextRange)

- (XCSourceTextRange *)sz_methodStatementPositionsWithIndex:(NSInteger)index;

- (NSArray *)sz_textArrayInTextRange:(XCSourceTextRange *)textRange;

- (NSArray<SZSourceTextRange *> *)sz_bridgedSourceTextRanges;

@end
