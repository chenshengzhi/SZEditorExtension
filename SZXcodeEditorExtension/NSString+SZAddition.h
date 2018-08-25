//
//  NSString+SZAddition.h
//  SZEditorExtension
//
//  Created by csz on 2017/3/19.
//  Copyright © 2017年 陈圣治. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZEditorExtensionHeader.h"

@interface NSString (SZAddition)

- (NSString *)sz_trimWhitespace;

- (BOOL)sz_isAsignmentStatement;

- (void)sz_propertyDeclarationInfoWithBlock:(void(^)(BOOL isProperty, BOOL isPointer, NSString *type, NSString *name))block;

- (BOOL)sz_isPropertyLine;

- (BOOL)sz_isInterfaceLine;

- (BOOL)sz_isImplementationLine;

- (BOOL)sz_isMethodStartLine;

- (NSString *)sz_interfaceName;

- (NSString *)sz_implementationName;

- (BOOL)sz_isImplementationForInterface:(NSString *)interface;

- (BOOL)sz_isExtensionForInterface:(NSString *)interface;

- (NSString *)sz_readonlyPropertyLine;

@end
