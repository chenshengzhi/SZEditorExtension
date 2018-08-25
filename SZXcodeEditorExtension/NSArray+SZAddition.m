//
//  NSArray+SZAddition.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/6/16.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import "NSArray+SZAddition.h"
#import "NSString+SZAddition.h"

@implementation NSArray (SZAddition)

- (NSInteger)sz_propertyGetterInsertIdexForInterface:(NSString *)interface position:(SZEEPropertyGetterPosition)position {
    NSInteger insertIndex = NSNotFound;
    for (NSInteger idx = 0; idx < self.count; idx++) {
        NSString *line = self[idx];
        if ([line sz_isImplementationForInterface:interface]) {
            insertIndex = idx;
            break;
        }
    }
    
    if (insertIndex > self.count) {
        return NSNotFound;
    }
    
    if (position == SZEEPropertyGetterPositionImplementationStart) {
        return (insertIndex + 1);
    } else {
        for (NSInteger idx = insertIndex + 1; idx < self.count; idx++) {
            NSString *line = [self[idx] sz_trimWhitespace];
            if ([line hasPrefix:@"@end"]) {
                return idx;
            }
        }
        return NSNotFound;
    }
}

- (void)sz_firstInterfaceNameFromIndex:(NSInteger)fromIndex block:(void(^)(NSString *name, NSInteger index))block {
    __block NSString *name = nil;
    __block NSInteger targetIndex = NSNotFound;
    [self sz_enumerateLineFromIndex:fromIndex up:YES usingBlock:^void(NSString *text, NSInteger index, BOOL *stop) {
        if ([text sz_isInterfaceLine]) {
            name = [text sz_interfaceName];
            targetIndex = index;
            *stop = YES;
        }
    }];
    if (block) {
        block(name, targetIndex);
    }
}

- (void)sz_firstImplementationNameWithFromIndex:(NSInteger)fromIndex block:(void(^)(NSString *name, NSInteger index))block {
    __block NSString *name = nil;
    __block NSInteger targetIndex = NSNotFound;
    [self sz_enumerateLineFromIndex:fromIndex up:YES usingBlock:^void(NSString *text, NSInteger index, BOOL *stop) {
        if ([text sz_isImplementationLine]) {
            name = [text sz_implementationName];
            targetIndex = index;
            *stop = YES;
        }
    }];
    if (block) {
        block(name, targetIndex);
    }
}

- (BOOL)sz_hasExtensionWithName:(NSString *)name fromIndex:(NSInteger)fromIndex {
    __block BOOL has = NO;
    [self sz_enumerateLineFromIndex:fromIndex up:YES usingBlock:^(NSString *text, NSInteger index, BOOL *stop) {
        if ([text sz_isExtensionForInterface:name]) {
            has = YES;
            *stop = YES;
        }
    }];
    return has;
}

#pragma mark - util -
- (void)sz_enumerateLineFromIndex:(NSInteger)fromIndex up:(BOOL)up usingBlock:(void(^)(NSString *text, NSInteger index, BOOL *stop))block {
    if (!block) {
        return;
    }
    
    if (fromIndex >= self.count) {
        fromIndex = self.count - 1;
    }
    if (up) {
        BOOL stop = NO;
        for (NSInteger idx = fromIndex; idx >= 0; idx--) {
            NSString *text = self[idx];
            block(text, idx, &stop);
            if (stop) {
                break;
            }
        }
    } else {
        BOOL stop = NO;
        for (NSInteger idx = fromIndex; idx < self.count; idx++) {
            NSString *text = self[idx];
            block(text, idx, &stop);
            if (stop) {
                break;
            }
        }
    }
}

@end
