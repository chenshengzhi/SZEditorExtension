//
//  NSString+SZAddition.h
//  SZEditorExtension
//
//  Created by csz on 2017/3/19.
//

#import <Foundation/Foundation.h>
#import "SZEditorExtensionHeader.h"

@interface NSString (SZAddition)

- (NSString *)sz_trimWhitespace;

- (NSString *)sz_trimWhitespaceAndNewline;

- (BOOL)sz_isImportLine;

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
- (NSString *)sz_antiReadonlyPropertyLine;

- (NSString *)sz_whiteSpacePrefix;

- (BOOL)sz_isDirectory;
- (BOOL)sz_isFileExist;

@end
