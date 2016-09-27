//
//  SourceEditorExtension.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2016/9/24.
//  Copyright © 2016年 陈圣治. All rights reserved.
//

#import "SourceEditorExtension.h"
#import "SZDuplicateLineCommand.h"
#import "SZDeleteLineCommand.h"

@implementation SourceEditorExtension

/*
- (void)extensionDidFinishLaunching
{
    // If your extension needs to do any work at launch, implement this optional method.
}
*/


- (NSArray <NSDictionary <XCSourceEditorCommandDefinitionKey, id> *> *)commandDefinitions
{
    return @[
             @{
                 XCSourceEditorCommandIdentifierKey: @"csz.SZXcodeEditorExtension.duplicateLine",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZDuplicateLineCommand class]),
                 XCSourceEditorCommandNameKey: @"Duplicate Line",
               },
             @{
                 XCSourceEditorCommandIdentifierKey: @"csz.SZXcodeEditorExtension.deleteLine",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZDeleteLineCommand class]),
                 XCSourceEditorCommandNameKey: @"Delete Line",
                 },
             ];
}


@end
