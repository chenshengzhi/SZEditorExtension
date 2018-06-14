//
//  SZPropertyGetterCommand.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2018/6/7.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#import "SZPropertyGetterCommand.h"
#import "SZEditorExtensionHeader.h"
#import "NSString+SZAddition.h"
#import "NSArray+SZAlignByEqualSign.h"
#import <AppKit/AppKit.h>

@implementation SZPropertyGetterCommand

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation
                   completionHandler:(void (^)(NSError * _Nullable))completionHandler {
    NSMutableArray<NSString *> *lines = invocation.buffer.lines;
    if (lines.count == 0) {
        completionHandler(nil);
        return;
    }
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:SZEEUserdefaultSuiteName];
    if (!defaults) {
        completionHandler(nil);
        return;
    }
    NSDictionary *map = [defaults objectForKey:SZEEPropertyGetterDictKey];
    
    NSMutableArray *toInsertTextArray = [NSMutableArray array];
    SZEEPropertyGetterPosition position = [defaults integerForKey:SZEEPropertyGetterPositionKey];
    
    [invocation.buffer.selections enumerateObjectsUsingBlock:^(XCSourceTextRange * _Nonnull textRange, NSUInteger idx, BOOL * _Nonnull stop) {
        XCSourceTextPosition start = textRange.start;
        XCSourceTextPosition end = textRange.end;
        
        NSMutableArray *selectedLines = [NSMutableArray array];
        NSInteger firstIndex = NSNotFound;
        for (NSInteger i = start.line; i <= end.line; i++) {
            if (i < lines.count) {
                NSString *line = lines[i];
                if ([line isPropertyLine]) {
                    firstIndex = MIN(firstIndex, i);
                    [selectedLines addObject:line];
                }
            }
        }
        
        if (!selectedLines.count) {
            return;
        }
        
        NSString *interfaceName = nil;
        for (NSInteger i = firstIndex - 1; i >= 0; i--) {
            NSString *line = lines[i];
            if ([line isInterfaceLine]) {
                interfaceName = [line interfaceName];
                break;
            }
        }
        if (!interfaceName.length) {
            return;
        }
        
        NSInteger insertIndex = [lines insertIdexForInterface:interfaceName position:position];
        NSEnumerator *lineEnumerator = [selectedLines reverseObjectEnumerator];
        for (NSString *line in lineEnumerator) {
            [line propertyDeclarationInfoWithBlock:^(BOOL isProperty, BOOL isPointer, NSString *type, NSString *name) {
                if (isProperty && isPointer && type.length && name.length) {
                    NSString *templateText = map[type];
                    if (!templateText.length) {
                        templateText = SZEEPropertyGetterDictUndefinedValue;
                    }
                    templateText = [templateText stringByReplacingOccurrencesOfString:@"###type###" withString:type];
                    templateText = [templateText stringByReplacingOccurrencesOfString:@"###name###" withString:name];
                    
                    if (insertIndex <= lines.count) {
                        if (position == SZEEPropertyGetterPositionImplementationStart) {
                            [lines insertObject:templateText atIndex:insertIndex];
                            [lines insertObject:@"" atIndex:insertIndex];
                        } else {
                            [lines insertObject:@"" atIndex:insertIndex];
                            [lines insertObject:templateText atIndex:insertIndex];
                        }
                    } else {
                        if (position == SZEEPropertyGetterPositionImplementationStart) {
                            [toInsertTextArray addObject:templateText];
                            [toInsertTextArray addObject:@""];
                        } else {
                            [toInsertTextArray addObject:@""];
                            [toInsertTextArray addObject:templateText];
                        }
                    }
                }
            }];
        }
    }];
    
    if (toInsertTextArray.count) {
        NSString *text = [toInsertTextArray componentsJoinedByString:@"\n"];
        [[NSPasteboard generalPasteboard] clearContents];
        [[NSPasteboard generalPasteboard] writeObjects:@[text]];
    }
    
    completionHandler(nil);
}

@end
