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
#import "SZAlignCommand.h"
#import "SZPropertyGetterCommand.h"
#import "SZSelectMethodStatementCommand.h"
#import "SZPropertyReadonlyCommand.h"

@implementation SourceEditorExtension

/*
- (void)extensionDidFinishLaunching
{
    // If your extension needs to do any work at launch, implement this optional method.
}
*/


- (NSArray <NSDictionary <XCSourceEditorCommandDefinitionKey, id> *> *)commandDefinitions {
    return @[
             @{
                 XCSourceEditorCommandIdentifierKey: @"com.csz.SZEditorExtension.SZXcodeEditorExtension.duplicateLine",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZDuplicateLineCommand class]),
                 XCSourceEditorCommandNameKey: @"Duplicate Line",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: @"com.csz.SZEditorExtension.SZXcodeEditorExtension.deleteLine",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZDeleteLineCommand class]),
                 XCSourceEditorCommandNameKey: @"Delete Line",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: @"com.csz.SZEditorExtension.SZXcodeEditorExtension.placeImport",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZPlaceImportCommand class]),
                 XCSourceEditorCommandNameKey: @"Place Impport",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: @"com.csz.SZEditorExtension.SZXcodeEditorExtension.align",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZAlignCommand class]),
                 XCSourceEditorCommandNameKey: @"Align Selected Lines",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: @"com.csz.SZEditorExtension.SZXcodeEditorExtension.propertyGetter",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZPropertyGetterCommand class]),
                 XCSourceEditorCommandNameKey: @"Property Getter",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: @"com.csz.SZEditorExtension.SZXcodeEditorExtension.propertyReadonly",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZPropertyReadonlyCommand class]),
                 XCSourceEditorCommandNameKey: @"Property Readonly",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: @"com.csz.SZEditorExtension.SZXcodeEditorExtension.selectMethod",
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZSelectMethodStatementCommand class]),
                 XCSourceEditorCommandNameKey: @"Select Method",
                 },
             ];
}


@end
