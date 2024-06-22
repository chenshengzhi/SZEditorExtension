//
//  NSMutableArray+SZDelegateProtocol.m
//  SZEditorExtension
//
//  Created by csz on 2018/9/22.
//

#import "NSMutableArray+SZDelegateProtocol.h"
#import "NSArray+SZAddition.h"
#import "NSError+SZAddition.h"

@implementation NSMutableArray (SZDelegateProtocol)

- (void)sz_addDelegateProtocolFromIndex:(NSUInteger)index completion:(void(^)(BOOL success, NSError *error))completion {
    if (!completion) {
        return;
    }
    [self sz_interfaceRangeFromIndex:index block:^(NSString *name, NSRange range) {
        if (range.location >= self.count) {
            completion(NO, [NSError sz_errorWithLocalizedDescription:@"Can not find @interface"]);
            return;
        }
        NSString *protocolName = [NSString stringWithFormat:@"%@Delegate", name];
        NSString *defineText = [NSString stringWithFormat:@"\n@protocol %@ <NSObject>\n\n<#protocol#>\n\n@end", protocolName];
        [self insertObject:defineText atIndex:NSMaxRange(range)];
        NSString *propertyText = [NSString stringWithFormat:@"\n@property (nonatomic, weak) id<%@> delegate;", protocolName];
        [self insertObject:propertyText atIndex:(range.location + 1)];
        NSString *predefineText = [NSString stringWithFormat:@"@protocol %@;\n\n", protocolName];
        [self insertObject:predefineText atIndex:range.location];
        completion(YES, nil);
    }];
}

@end
