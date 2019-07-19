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
#import "SZClassExtensionCommand.h"
#import "SZDelegateProtocolCommand.h"
#import "SZInsertNewLineCommand.h"
#import "SZCommandConstants.h"

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
                 XCSourceEditorCommandIdentifierKey: SZDuplicateLineCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZDuplicateLineCommand class]),
                 XCSourceEditorCommandNameKey: @"Duplicate Line",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZDeleteLineCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZDeleteLineCommand class]),
                 XCSourceEditorCommandNameKey: @"Delete Line",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZPlaceImportCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZPlaceImportCommand class]),
                 XCSourceEditorCommandNameKey: @"Place Impport",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZPlaceImportShiftCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZPlaceImportCommand class]),
                 XCSourceEditorCommandNameKey: @"Place Impport Shift",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZAlignCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZAlignCommand class]),
                 XCSourceEditorCommandNameKey: @"Align Selected Lines",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZPropertyGetterCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZPropertyGetterCommand class]),
                 XCSourceEditorCommandNameKey: @"Property Getter",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZPropertyReadOnlyCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZPropertyReadonlyCommand class]),
                 XCSourceEditorCommandNameKey: @"Property Readonly",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZSelectMethodCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZSelectMethodStatementCommand class]),
                 XCSourceEditorCommandNameKey: @"Select Method",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZClassExtensionCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZClassExtensionCommand class]),
                 XCSourceEditorCommandNameKey: @"Class Extension",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZDelegateProtocolCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZDelegateProtocolCommand class]),
                 XCSourceEditorCommandNameKey: @"Delegate Protocol",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZInsertNewLineBeforeCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZInsertNewLineCommand class]),
                 XCSourceEditorCommandNameKey: @"Insert New Line Before",
                 },
             @{
                 XCSourceEditorCommandIdentifierKey: SZInsertNewLineAfterCommandIdentifier,
                 XCSourceEditorCommandClassNameKey: NSStringFromClass([SZInsertNewLineCommand class]),
                 XCSourceEditorCommandNameKey: @"Insert New Line After",
                 },
             ];
}


@end
