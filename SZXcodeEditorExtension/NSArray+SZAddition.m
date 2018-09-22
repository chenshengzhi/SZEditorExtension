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
    [self sz_firstInterfaceNameFromIndex:fromIndex up:YES block:^(NSString *name, NSInteger index) {
        if (index < self.count) {
            if (block) {
                block(name, index);
            }
        } else {
            [self sz_firstInterfaceNameFromIndex:fromIndex up:NO block:block];
        }
    }];
}

- (void)sz_firstInterfaceNameFromIndex:(NSInteger)fromIndex up:(BOOL)up block:(void(^)(NSString *name, NSInteger index))block {
    __block NSString *name = nil;
    __block NSInteger targetIndex = NSNotFound;
    [self sz_enumerateLineFromIndex:fromIndex up:up usingBlock:^void(NSString *text, NSInteger index, BOOL *stop) {
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
    [self sz_firstImplementationNameWithFromIndex:fromIndex up:YES block:^(NSString *name, NSInteger index) {
        if (index < self.count) {
            if (block) {
                block(name, index);
            }
        } else {
            [self sz_firstImplementationNameWithFromIndex:fromIndex up:NO block:block];
        }
    }];
}

- (void)sz_firstImplementationNameWithFromIndex:(NSInteger)fromIndex up:(BOOL)up block:(void(^)(NSString *name, NSInteger index))block {
    __block NSString *name = nil;
    __block NSInteger targetIndex = NSNotFound;
    [self sz_enumerateLineFromIndex:fromIndex up:up usingBlock:^void(NSString *text, NSInteger index, BOOL *stop) {
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

- (NSUInteger)sz_firstEndLineFromIndex:(NSUInteger)fromIndex {
    NSUInteger endIndex = NSNotFound;
    for (NSInteger idx = fromIndex + 1; idx < self.count; idx++) {
        NSString *line = [self[idx] sz_trimWhitespace];
        if ([line hasPrefix:@"@end"]) {
            endIndex = idx;
            break;
        }
    }
    return endIndex;
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

- (void)sz_interfaceRangeFromIndex:(NSUInteger)fromIndex block:(void(^)(NSString *name, NSRange range))block {
    if (!block) {
        return;
    }
    [self sz_firstInterfaceNameFromIndex:fromIndex block:^(NSString *name, NSInteger interfaceIndex) {
        if (interfaceIndex >= self.count) {
            block(nil, NSMakeRange(NSNotFound, 0));
            return;
        }
        
        NSUInteger endIndex = [self sz_firstEndLineFromIndex:interfaceIndex];
        if (endIndex < self.count) {
            block(name, NSMakeRange(interfaceIndex, endIndex + 1 - interfaceIndex));
        } else {
            block(nil, NSMakeRange(NSNotFound, 0));
        }
    }];
}

- (void)sz_implementationRangeFromIndex:(NSUInteger)fromIndex block:(void(^)(NSString *name, NSRange range))block {
    if (!block) {
        return;
    }
    [self sz_firstImplementationNameWithFromIndex:fromIndex block:^(NSString *name, NSInteger implementationIndex) {
        if (implementationIndex >= self.count) {
            block(nil, NSMakeRange(NSNotFound, 0));
            return;
        }
        
        NSUInteger endIndex = [self sz_firstEndLineFromIndex:implementationIndex];
        if (endIndex < self.count) {
            block(name, NSMakeRange(implementationIndex, endIndex + 1 - implementationIndex));
        } else {
            block(nil, NSMakeRange(NSNotFound, 0));
        }
    }];
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
