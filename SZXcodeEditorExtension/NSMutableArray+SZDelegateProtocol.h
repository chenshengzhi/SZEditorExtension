//
//  NSMutableArray+SZDelegateProtocol.h
//  SZEditorExtension
//
//  Created by csz on 2018/9/22.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SZDelegateProtocol)

- (void)sz_addDelegateProtocolFromIndex:(NSUInteger)index completion:(void(^)(BOOL success, NSError *error))completion;

@end
