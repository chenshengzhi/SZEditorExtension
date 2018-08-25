//
//  NSArray+SZXCSourceTextRange.h
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/8/26.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XCSourceTextRange.h>

@interface NSArray (SZXCSourceTextRange)

- (XCSourceTextRange *)sz_methodStatementPositionsWithIndex:(NSInteger)index;

- (NSArray *)sz_textArrayInTextRange:(XCSourceTextRange *)textRange;

@end
