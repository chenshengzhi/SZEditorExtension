//
//  SZSourceTextRange.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2024.06.22.
//

#import "SZSourceTextRange.h"

@implementation SZSourceTextRange

- (instancetype)initWithStart:(SZSourceTextPosition)start end:(SZSourceTextPosition)end {
    self = [super init];
    if (self) {
        self.start = start;
        self.end = end;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    SZSourceTextRange *range = [[self.class alloc] initWithStart:self.start end:self.end];
    return range;
}

@end
