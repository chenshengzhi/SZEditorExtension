//
//  SZPropertyGetterModel.m
//  SZEditorExtension
//
//  Created by csz on 2018/6/9.
//

#import "SZPropertyGetterModel.h"

@implementation SZPropertyGetterModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.typeName = @"(no name)";
        self.templateText = @"(no text)";
    }
    return self;
}

@end
