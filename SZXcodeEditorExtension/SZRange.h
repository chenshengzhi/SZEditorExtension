//
//  SZRange.h
//  SZEditorExtension
//
//  Created by 陈圣治 on 01/11/2016.
//  Copyright © 2016 陈圣治. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZRange : NSObject

@property (nonatomic) NSInteger start;
@property (nonatomic) NSInteger end;

+ (instancetype)rangeWithStart:(NSInteger)start end:(NSInteger)end;

- (BOOL)isContainLocation:(NSInteger)location;

- (BOOL)isIntersectRange:(SZRange *)range;

- (NSArray<SZRange *> *)minusRange:(SZRange *)range;

- (NSArray<SZRange *> *)unionRange:(SZRange *)range;

@end


@interface NSMutableArray (SZRangeMinus)

- (void)minusArray:(NSArray<SZRange *> *)otherArray;

@end
