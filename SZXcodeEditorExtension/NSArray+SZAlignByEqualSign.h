//
//  NSArray+SZAlignByEqualSign.h
//  SZEditorExtension
//
//  Created by csz on 2017/3/19.
//

#import <Foundation/Foundation.h>

@interface NSArray (SZAlignByEqualSign)

- (BOOL)sz_needAlignByEqualSign;

- (NSArray *)sz_alignedArrayByEqualSign;

@end
