//
//  NSArray+SZAddition.h
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/6/16.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XCSourceTextRange.h>

@interface NSArray (SZAddition)

- (XCSourceTextRange *)methodStatementPositionsWithIndex:(NSInteger)index;

- (NSArray *)textArrayInTextRange:(XCSourceTextRange *)textRange;

@end

