//
//  NSArray+SZAddition.h
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/6/16.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XCSourceTextRange.h>
#import "SZEditorExtensionHeader.h"

@interface NSArray (SZAddition)

- (XCSourceTextRange *)sz_methodStatementPositionsWithIndex:(NSInteger)index;

- (NSArray *)sz_textArrayInTextRange:(XCSourceTextRange *)textRange;

- (NSInteger)sz_propertyGetterInsertIdexForInterface:(NSString *)interface position:(SZEEPropertyGetterPosition)position;

@end

