//
//  XCSourceTextRange+SZAddition.h
//  SZXcodeEditorExtension
//
//  Created by csz on 2024.06.22.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XCSourceTextRange.h>
@class SZSourceTextRange;

NS_ASSUME_NONNULL_BEGIN

@interface XCSourceTextRange (SZAddition)

- (SZSourceTextRange *)sz_bridgedSourceTextRange;

@end

NS_ASSUME_NONNULL_END
