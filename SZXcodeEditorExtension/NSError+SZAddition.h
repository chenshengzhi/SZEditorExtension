//
//  NSError+SZAddition.h
//  SZEditorExtension
//
//  Created by csz on 2018/9/22.
//

#import <Foundation/Foundation.h>

@interface NSError (SZAddition)

+ (NSError *)sz_errorWithLocalizedDescription:(NSString *)text;

@end
