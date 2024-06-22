//
//  SZPlaceImportHelper.m
//  SZXcodeEditorExtension
//
//  Created by csz on 2024.06.22.
//

#import "SZPlaceImportHelper.h"
#import "NSArray+SZAddition.h"
#import "NSString+SZAddition.h"
#import "SZCommandConstants.h"
#import "SZSourceTextRange.h"

typedef NSString * SZPlaceImportLine;
static SZPlaceImportLine const SZPlaceImportLineMacro = @"macro";
static SZPlaceImportLine const SZPlaceImportLineNormal = @"normal";

typedef NS_ENUM(NSInteger, SZPIHChunkType) {
    SZPIHChunkTypeNormal,
    SZPIHChunkTypeMacro,
};

typedef NS_ENUM(NSInteger, SZPIHLineType) {
    SZPIHLineTypeImportAngle,
    SZPIHLineTypeImportQuotation,
    SZPIHLineTypeIncludeAngle,
    SZPIHLineTypeIncludeQuotation,
    SZPIHLineTypeAtImport,
    SZPIHLineTypeOther,
};

@interface SZPlaceImportChunk : NSObject

@property (nonatomic) SZPIHChunkType chunkType;
@property (nonatomic) SZPIHLineType lineType;
@property (nonatomic, strong) NSArray *lines;
@property (nonatomic, strong) NSString *text;

@end

@implementation SZPlaceImportChunk

- (instancetype)initWithChunkType:(SZPIHChunkType)chunkType
                         lineType:(SZPIHLineType)lineType
                            lines:(NSArray *)lines
                            text:(NSString *)text {
    self = [super init];
    if (self) {
        self.chunkType = chunkType;
        self.lineType = lineType;
        self.lines = lines;
        self.text = text;
    }
    return self;
}

- (NSComparisonResult)compare:(SZPlaceImportChunk *)chunk {
    return [self.text compare:chunk.text];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"chunkType: %ld, lineType: %ld, lines: %@", self.chunkType, self.lineType, self.lines];
}

@end


@implementation SZPlaceImportHelper

+ (NSArray<NSString *> *)processLines:(NSArray<NSString *> *)lines
                           selections:(nullable NSArray<SZSourceTextRange *> *)selections
                    commandIdentifier:(nullable NSString *)commandIdentifier {
    NSMutableArray *linesMutable = [lines mutableCopy];
    __block NSInteger insertIndex = 0;
    NSRange importRange = [linesMutable sz_importLinesRange];
    if (importRange.location != NSNotFound) {
        insertIndex = NSMaxRange(importRange);
    }
    
    NSString *selectingClassName = nil;
    if (selections.count == 1) {
        SZSourceTextRange *textRange = selections.firstObject;
        SZSourceTextPosition start = textRange.start;
        SZSourceTextPosition end = textRange.end;
        if (start.line == end.line) {
            NSString *line = linesMutable[textRange.start.line];
            NSRange range = NSMakeRange(start.column, end.column - start.column);
            NSString *selectedText = [line substringWithRange:range];
            NSString *patten = @"^[a-zA-Z0-9]+$";
            NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:patten options:0 error:nil];
            NSInteger matchCount = [expression numberOfMatchesInString:selectedText
                                                               options:0
                                                                 range:NSMakeRange(0, selectedText.length)];
            if (matchCount) {
                selectingClassName = selectedText;
            }
        }
    }
    if (selectingClassName) {
        NSString *lineNew = nil;
        if ([commandIdentifier isEqualToString:SZPlaceImportCommandIdentifier]) {
            lineNew = [NSString stringWithFormat:@"#import \"%@.h\"", selectingClassName];
        } else {
            lineNew = [NSString stringWithFormat:@"#import <%@.h>", selectingClassName];
        }
        [linesMutable insertObject:lineNew atIndex:insertIndex];
        insertIndex++;
    }
    
    [selections enumerateObjectsUsingBlock:^(SZSourceTextRange *sourceTextRange, NSUInteger idx, BOOL *stop) {
        for (NSInteger i = sourceTextRange.start.line; i <= sourceTextRange.end.line; i++) {
            if (i <= insertIndex) {
                continue;
            }
            NSString *lineText = linesMutable[i];
            if ([lineText sz_isImportLine]) {
                [linesMutable removeObjectAtIndex:i];
                [linesMutable insertObject:[lineText sz_trimWhitespace] atIndex:insertIndex];
                insertIndex++;
            }
        }
    }];
    
    NSString *fileName = [linesMutable sz_fileNameByHeaderComments];
    if (!fileName.length) {
        return [linesMutable copy];
    }
    
    importRange = [linesMutable sz_importLinesRange];
    if (importRange.location == NSNotFound) {
        return [linesMutable copy];
    }
    
    fileName = [fileName stringByDeletingPathExtension];
    NSString *className = [fileName componentsSeparatedByString:@"+"].firstObject;
    
    NSArray *subLines = [linesMutable subarrayWithRange:importRange];
    [linesMutable removeObjectsInRange:importRange];
    
    NSArray<SZPlaceImportChunk *> *classifiedResult = [self classifiedLines:subLines];
    NSMutableArray<NSString *> *result = [NSMutableArray array];
    
    NSMutableArray<SZPlaceImportChunk *> *importAngleArray = [NSMutableArray array];
    NSMutableArray<SZPlaceImportChunk *> *importQuotationArray = [NSMutableArray array];
    NSMutableArray<SZPlaceImportChunk *> *includeAngleArray = [NSMutableArray array];
    NSMutableArray<SZPlaceImportChunk *> *includeQuotationArray = [NSMutableArray array];
    NSMutableArray<SZPlaceImportChunk *> *atImportArray = [NSMutableArray array];
    NSMutableArray<SZPlaceImportChunk *> *otherArray = [NSMutableArray array];
    
    [classifiedResult enumerateObjectsUsingBlock:^(SZPlaceImportChunk * _Nonnull obj,
                                                   NSUInteger idx,
                                                   BOOL * _Nonnull stop) {
        if (obj.chunkType == SZPIHChunkTypeMacro && obj.lineType == SZPIHLineTypeOther) {
            if (result.count > 0) {
                [result addObject:@"\n"];
            }
            [result addObjectsFromArray:obj.lines];
            return;
        }
        
        switch (obj.lineType) {
            case SZPIHLineTypeImportAngle:
                [importAngleArray addObject:obj];
                break;
            case SZPIHLineTypeImportQuotation:
                [importQuotationArray addObject:obj];
                break;
            case SZPIHLineTypeIncludeAngle:
                [includeAngleArray addObject:obj];
                break;
            case SZPIHLineTypeIncludeQuotation:
                [includeQuotationArray addObject:obj];
                break;
            case SZPIHLineTypeAtImport:
                [atImportArray addObject:obj];
                break;
            case SZPIHLineTypeOther:
                [otherArray addObject:obj];
                break;
        }
    }];
    
    if (importAngleArray.count ||
        importQuotationArray.count ||
        includeAngleArray.count ||
        includeQuotationArray.count ||
        atImportArray.count ||
        otherArray.count) {
        if (result.count > 0) {
            [result addObject:@"\n"];
        }
    }
    [importAngleArray sortUsingSelector:@selector(compare:)];
    [importQuotationArray sortUsingSelector:@selector(compare:)];
    [includeAngleArray sortUsingSelector:@selector(compare:)];
    [includeQuotationArray sortUsingSelector:@selector(compare:)];
    [atImportArray sortUsingSelector:@selector(compare:)];
    [otherArray sortUsingSelector:@selector(compare:)];
    [importQuotationArray sortUsingComparator:^NSComparisonResult(SZPlaceImportChunk *obj1, SZPlaceImportChunk *obj2) {
        if ([obj1.text containsString:className]) {
            return NSOrderedAscending;
        } else if ([obj2.text containsString:className]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    [importQuotationArray sortUsingComparator:^NSComparisonResult(SZPlaceImportChunk *obj1, SZPlaceImportChunk *obj2) {
        if ([obj1.text containsString:fileName]) {
            return NSOrderedAscending;
        } else if ([obj2.text containsString:fileName]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    [importAngleArray enumerateObjectsUsingBlock:^(SZPlaceImportChunk *obj, NSUInteger idx, BOOL *stop) {
        [result addObjectsFromArray:obj.lines];
    }];
    [includeAngleArray enumerateObjectsUsingBlock:^(SZPlaceImportChunk *obj, NSUInteger idx, BOOL *stop) {
        [result addObjectsFromArray:obj.lines];
    }];
    [importQuotationArray enumerateObjectsUsingBlock:^(SZPlaceImportChunk *obj, NSUInteger idx, BOOL *stop) {
        [result addObjectsFromArray:obj.lines];
    }];
    [includeQuotationArray enumerateObjectsUsingBlock:^(SZPlaceImportChunk *obj, NSUInteger idx, BOOL *stop) {
        [result addObjectsFromArray:obj.lines];
    }];
    [atImportArray enumerateObjectsUsingBlock:^(SZPlaceImportChunk *obj, NSUInteger idx, BOOL *stop) {
        [result addObjectsFromArray:obj.lines];
    }];
    [otherArray enumerateObjectsUsingBlock:^(SZPlaceImportChunk *obj, NSUInteger idx, BOOL *stop) {
        [result addObjectsFromArray:obj.lines];
    }];
    
    importRange.length = result.count;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:importRange];
    [linesMutable insertObjects:result atIndexes:indexSet];
    return [linesMutable copy];
}

+ (NSArray<SZPlaceImportChunk *> *)classifiedLines:(NSArray *)lines {
    NSMutableArray<SZPlaceImportChunk *> *result = [NSMutableArray array];
    NSMutableArray *macroArray = [NSMutableArray array];
    NSInteger macroStart = NSNotFound;
    NSInteger macroDepth = 0;
    for (NSInteger idx = 0; idx < lines.count; idx++) {
        NSString *line = lines[idx];
        NSString *text = [line sz_trimWhitespaceAndNewline];
        if (!text.length) {
            continue;
        }
        if (macroStart != NSNotFound) {
            if ([text hasPrefix:@"#endif"]) {
                macroDepth--;
                if (macroDepth == 0) {
                    NSRange range = NSMakeRange(macroStart, idx - macroStart + 1);
                    NSArray *subLines = [lines subarrayWithRange:range];
                    NSRange contentLineRange = NSMakeRange(1, subLines.count - 2);
                    NSArray *contentLines = [subLines subarrayWithRange:contentLineRange];
                    BOOL areAllImport = YES;
                    for (NSInteger idx = 0; idx < contentLines.count; idx++) {
                        NSString *line = contentLines[idx];
                        if (![line sz_isImportLine]) {
                            areAllImport = NO;
                            break;
                        }
                    }
                    SZPIHLineType lineType = SZPIHLineTypeOther;
                    if (areAllImport) {
                        contentLines = [self processLines:contentLines selections:nil commandIdentifier:nil];
                        lineType = [self lineTypeOfText:contentLines.firstObject];
                        NSMutableArray *tempArray = [subLines mutableCopy];
                        [tempArray replaceObjectsInRange:contentLineRange withObjectsFromArray:contentLines];
                        subLines = [tempArray copy];
                    }
                    [macroArray addObjectsFromArray:subLines];
                    SZPlaceImportChunk *chunk = [[SZPlaceImportChunk alloc] initWithChunkType:SZPIHChunkTypeMacro
                                                                                     lineType:lineType
                                                                                        lines:[macroArray copy]
                                                                                         text:contentLines.firstObject];
                    [result addObject:chunk];
                    macroArray = [NSMutableArray array];
                    macroStart = NSNotFound;
                }
            }
            continue;
        }
        if ([text hasPrefix:@"#if"]) {
            if (macroDepth == 0) {
                macroStart = idx;
            }
            macroDepth++;
            continue;
        }
        
        NSInteger existIndex = [result indexOfObjectPassingTest:^BOOL(SZPlaceImportChunk * _Nonnull obj,
                                                                      NSUInteger idx,
                                                                      BOOL * _Nonnull stop) {
            if (obj.chunkType != SZPIHChunkTypeNormal) {
                return NO;
            }
            return [obj.text isEqualToString:text];
        }];
        if (existIndex < result.count) {
            continue;
        }
        
        SZPIHLineType lineType = [self lineTypeOfText:text];
        SZPlaceImportChunk *chunk = [[SZPlaceImportChunk alloc] initWithChunkType:SZPIHChunkTypeNormal
                                                                         lineType:lineType
                                                                            lines:@[line]
                                                                             text:text];
        [result addObject:chunk];
    }
    return result;
}

+ (SZPIHLineType)lineTypeOfText:(NSString *)obj {
    if ([obj hasPrefix:@"#import <"]) {
        return SZPIHLineTypeImportAngle;
    } else if ([obj hasPrefix:@"#include <"]) {
        return SZPIHLineTypeIncludeAngle;
    } else if ([obj hasPrefix:@"#import \""]) {
        return SZPIHLineTypeImportQuotation;
    } else if ([obj hasPrefix:@"include \""]) {
        return SZPIHLineTypeIncludeQuotation;
    } else if ([obj hasPrefix:@"@import "]) {
        return SZPIHLineTypeAtImport;
    } else {
        return SZPIHLineTypeOther;
    }
}

@end
