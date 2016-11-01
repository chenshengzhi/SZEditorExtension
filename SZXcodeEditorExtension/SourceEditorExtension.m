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
#import "SZPlaceImportCommand.h"

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
                 XCSourceEditorCommandIdentifierKey: @"csz.SZEditorExtension.SZXcodeEditorExtension.duplicateLine",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZDuplicateLineCommand class]),
                 XCSourceEditorCommandNameKey: @"Duplicate Line",
               },
             @{
                 XCSourceEditorCommandIdentifierKey: @"csz.SZEditorExtension.SZXcodeEditorExtension.deleteLine",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZDeleteLineCommand class]),
                 XCSourceEditorCommandNameKey: @"Delete Line",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: @"csz.SZEditorExtension.SZXcodeEditorExtension.placeImport",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZPlaceImportCommand class]),
                 XCSourceEditorCommandNameKey: @"Place Impport",
                 },
             ];
}


@end
