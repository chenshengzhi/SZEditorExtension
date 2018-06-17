//
//  NSArray+SZAlignByEqualSign.h
//  SZEditorExtension
//
//  Created by csz on 2017/3/19.
//  Copyright © 2017年 陈圣治. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZEditorExtensionHeader.h"

@interface NSArray (SZAlignByEqualSign)

- (BOOL)needAlignByEqualSign;

- (NSArray *)alignedArrayByEqualSign;

- (NSInteger)propertyGetterInsertIdexForInterface:(NSString *)interface position:(SZEEPropertyGetterPosition)position;

@end
