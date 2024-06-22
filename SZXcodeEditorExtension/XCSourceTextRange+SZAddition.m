//
//  XCSourceTextRange+SZAddition.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2024.06.22.
//

#import "XCSourceTextRange+SZAddition.h"
#import "SZSourceTextRange.h"

@implementation XCSourceTextRange (SZAddition)

- (SZSourceTextRange *)sz_bridgedSourceTextRange {
    SZSourceTextPosition start = SZSourceTextPositionMake(self.start.line, self.start.column);
    SZSourceTextPosition end = SZSourceTextPositionMake(self.end.line, self.end.column);
    return [[SZSourceTextRange alloc] initWithStart:start end:end];
}

@end
