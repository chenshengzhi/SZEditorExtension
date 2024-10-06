//
//  SourceEditorExtension.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2016/9/24.
//

#import "SourceEditorExtension.h"
#import "SZAlignCommand.h"
#import "SZClassExtensionCommand.h"
#import "SZCommandConstants.h"
#import "SZDebugCodeCommand.h"
#import "SZDelegateProtocolCommand.h"
#import "SZDeleteLineCommand.h"
#import "SZDuplicateLineCommand.h"
#import "SZInsertNewLineCommand.h"
#import "SZPlaceImportCommand.h"
#import "SZPropertyGetterCommand.h"
#import "SZPropertyReadonlyCommand.h"
#import "SZSelectMethodStatementCommand.h"

@implementation SourceEditorExtension

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
            XCSourceEditorCommandIdentifierKey: SZPropertyAntiReadOnlyCommandIdentifier,
            XCSourceEditorCommandClassNameKey: NSStringFromClass([SZPropertyReadonlyCommand class]),
            XCSourceEditorCommandNameKey: @"Anti Property Readonly",
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
        @{
            XCSourceEditorCommandIdentifierKey: SZDebugCodeCommandIdentifier,
            XCSourceEditorCommandClassNameKey: NSStringFromClass([SZDebugCodeCommand class]),
            XCSourceEditorCommandNameKey: @"Debug Selected Code",
        },
    ];
}


@end
