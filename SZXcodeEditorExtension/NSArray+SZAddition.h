//
//  NSArray+SZAddition.h
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/6/16.
//

#import <Foundation/Foundation.h>
#import "SZEditorExtensionHeader.h"

@interface NSArray (SZAddition)

- (NSInteger)sz_propertyGetterInsertIdexForInterface:(NSString *)interface
                                            position:(SZEEPropertyGetterPosition)position;

- (void)sz_firstInterfaceNameFromIndex:(NSInteger)fromIndex
                                 block:(void(^)(NSString *name, NSInteger index))block;
- (void)sz_firstInterfaceNameFromIndex:(NSInteger)fromIndex
                                    up:(BOOL)up block:(void(^)(NSString *name, NSInteger index))block;

- (void)sz_firstImplementationNameWithFromIndex:(NSInteger)fromIndex
                                          block:(void(^)(NSString *name, NSInteger index))block;
- (void)sz_firstImplementationNameWithFromIndex:(NSInteger)fromIndex
                                             up:(BOOL)up
                                          block:(void(^)(NSString *name, NSInteger index))block;

- (NSUInteger)sz_firstEndLineFromIndex:(NSUInteger)fromIndex;

- (BOOL)sz_hasExtensionWithName:(NSString *)name
                      fromIndex:(NSInteger)fromIndex;

- (void)sz_interfaceRangeFromIndex:(NSUInteger)fromIndex
                             block:(void(^)(NSString *name, NSRange range))block;
- (void)sz_implementationRangeFromIndex:(NSUInteger)fromIndex
                                  block:(void(^)(NSString *name, NSRange range))block;

- (NSString *)sz_fileNameByHeaderComments;

- (NSRange)sz_importLinesRange;

- (NSArray *)sz_mapUsingBlock:(id (^)(id obj, NSUInteger idx))block;

@end

