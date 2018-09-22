//
//  NSError+SZAddition.m
//  SZEditorExtension
//
//  Created by csz on 2018/9/22.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import "NSError+SZAddition.h"

@implementation NSError (SZAddition)

+ (NSError *)sz_errorWithLocalizedDescription:(NSString *)text {
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: text ?: @"Unknown error"};
    return [NSError errorWithDomain:@"com.csz.SZEditorExtension.SZXcodeEditorExtension"
                               code:-1
                           userInfo:userInfo];
}

@end
