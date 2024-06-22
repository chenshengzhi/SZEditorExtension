//
//  SZPlaceImportHelper.h
//  SZXcodeEditorExtension
//
//  Created by csz on 2024.06.22.
//

#import <Foundation/Foundation.h>
@class SZSourceTextRange;

NS_ASSUME_NONNULL_BEGIN

@interface SZPlaceImportHelper : NSObject

+ (NSArray<NSString *> *)processLines:(NSArray<NSString *> *)lines
                           selections:(nullable NSArray<SZSourceTextRange *> *)selections
                    commandIdentifier:(nullable NSString *)commandIdentifier;

@end

NS_ASSUME_NONNULL_END
