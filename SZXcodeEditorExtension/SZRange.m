//
//  SZRange.m
//  SZEditorExtension
//
//  Created by Neil on 01/11/2016.
//

#import "SZRange.h"

@implementation SZRange

+ (instancetype)rangeWithStart:(NSInteger)start end:(NSInteger)end {
    SZRange *range = [[SZRange alloc] init];
    range.start = start;
    range.end = end;
    return range;
}

- (BOOL)isContainLocation:(NSInteger)location {
    return location >= self.start && location <= self.end;
}

- (BOOL)isIntersectRange:(SZRange *)range {
    return ([self isContainLocation:range.start]
            || [self isContainLocation:range.end]
            || [range isContainLocation:self.start]
            || [range isContainLocation:self.end]);
}

- (NSArray<SZRange *> *)minusRange:(SZRange *)range {
    NSMutableArray<SZRange *> *array = [NSMutableArray array];

    if (range.start <= self.start) {
        if (range.end < self.start) {
            [array addObject:self];
        } else {
            if (range.end < self.end) {
                [array addObject:[SZRange rangeWithStart:range.end+1 end:self.end]];
            }
        }
    } else {
        if (range.start <= self.end) {
            [array addObject:[SZRange rangeWithStart:self.start end:range.start-1]];

            if (range.end < self.end) {
                [array addObject:[SZRange rangeWithStart:range.end+1 end:self.end]];
            }
        } else {
            [array addObject:self];
        }
    }

    return array;
}

- (NSArray<SZRange *> *)unionRange:(SZRange *)range {
    if ([self isIntersectRange:range]) {
        self.start = MIN(self.start, range.start);
        self.end = MAX(self.end, range.end);
        return @[self];
    } else {
        return @[self, range];
    }
}

#pragma mark - override -
- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[SZRange class]]) {
        SZRange *otherRange = (SZRange *)object;
        return self.start == otherRange.start && self.end == otherRange.end;
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@, %@]", @(self.start), @(self.end)];
}

@end


@implementation NSMutableArray (SZRangeMinus)

- (void)minusArray:(NSArray<SZRange *> *)otherArray {
    for (SZRange *range in otherArray) {
        [self minusRange:range];
    }
}

- (void)minusRange:(SZRange *)minusRange {
    for (NSInteger index = 0; index < self.count; index++) {
        SZRange *sourceRange = self[index];
        if ([sourceRange isIntersectRange:minusRange]) {
            [self removeObjectAtIndex:index];

            NSArray *result = [sourceRange minusRange:minusRange];
            for (SZRange *range in result.reverseObjectEnumerator) {
                [self insertObject:range atIndex:index];
            }

            break;
        }
    }
}

@end


