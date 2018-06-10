//
//  NSString+SZAddition.h
//  SZEditorExtension
//
//  Created by csz on 2017/3/19.
//  Copyright © 2017年 陈圣治. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SZAddition)

- (NSString *)trimWhitespace;

- (BOOL)isAsignmentStatement;

- (void)propertyDeclarationInfoWithBlock:(void(^)(BOOL isProperty, NSString *type, NSString *name))block;

- (NSString *)interfaceName;

- (BOOL)isImplementationForInterface:(NSString *)interface;

@end
