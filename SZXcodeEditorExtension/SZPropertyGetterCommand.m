//
//  SZPropertyGetterCommand.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/6/7.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import "SZPropertyGetterCommand.h"

@implementation SZPropertyGetterCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    if (lines.count == 0) {
        completionHandler(nil);
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Template" ofType:@"plist"];
    NSDictionary *templateMap = [[NSDictionary alloc] initWithContentsOfFile:path];
    if (!templateMap.count) {
//        [lines insertObject:@"no template find" atIndex:0];
        NSError *error = [NSError errorWithDomain:@"csz.noTemplate" code:-1 userInfo:nil];
        completionHandler(error);
        return;
    }
    
    XCSourceTextRange *textRange = invocation.buffer.selections.firstObject;
    XCSourceTextPosition start = textRange.start;
    XCSourceTextPosition end = textRange.end;
    
    NSMutableArray *selectedLines = [NSMutableArray array];
    for (NSInteger i = start.line; i <= end.line; i++) {
        if (i < lines.count) {
            [selectedLines addObject:lines[i]];
        }
    }
    
    for (NSString *line in selectedLines) {
        if (![line hasPrefix:@"@property"]) {
            continue;
        }
        
        NSRange range = [line rangeOfString:@")"];
        NSString *subString = [line substringFromIndex:NSMaxRange(range)];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        subString = [subString stringByReplacingOccurrencesOfString:@";" withString:@""];
        
        NSArray *array = [subString componentsSeparatedByString:@" "];
        if (array.count >= 2) {
            NSString *type = array[0];
            NSString *name = array[1];
            if ([name hasPrefix:@"*"]) {
                name = [name substringFromIndex:1];
            }
            
            NSString *template = templateMap[type];
            template = [template stringByReplacingOccurrencesOfString:@"###type###" withString:type];
            template = [template stringByReplacingOccurrencesOfString:@"###name###" withString:name];

            [lines insertObject:template atIndex:0];
//            [lines insertObject:[NSString stringWithFormat:@"%@", [templateMap description]] atIndex:0];
//
//            [lines insertObject:line atIndex:0];
//            [lines insertObject:type atIndex:0];
//            [lines insertObject:[NSString stringWithFormat:@"%lu", type.length] atIndex:0];
        }
    }
    
    completionHandler(nil);
}

@end
