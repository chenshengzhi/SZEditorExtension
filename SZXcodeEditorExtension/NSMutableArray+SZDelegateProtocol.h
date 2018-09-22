//
//  NSMutableArray+SZDelegateProtocol.h
//  SZEditorExtension
//
//  Created by csz on 2018/9/22.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SZDelegateProtocol)

- (void)sz_addDelegateProtocolFromIndex:(NSUInteger)index completion:(void(^)(BOOL success, NSError *error))completion;

@end
