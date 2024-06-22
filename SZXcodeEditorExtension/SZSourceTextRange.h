//
//  SZSourceTextRange.h
//  SZXcodeEditorExtension
//
//  Created by csz on 2024.06.22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    NSInteger line;
    NSInteger column;
} SZSourceTextPosition;


NS_INLINE SZSourceTextPosition SZSourceTextPositionMake(const NSInteger line, const NSInteger column) {
    SZSourceTextPosition position = { .line = line, .column = column };
    return position;
}

@interface SZSourceTextRange : NSObject <NSCopying>

@property SZSourceTextPosition start;

@property SZSourceTextPosition end;

- (instancetype)initWithStart:(SZSourceTextPosition)start end:(SZSourceTextPosition)end;

@end

NS_ASSUME_NONNULL_END
