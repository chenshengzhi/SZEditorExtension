//
//  SZPropertyGetterModel.m
//  SZEditorExtension
//
//  Created by csz on 2018/6/9.
//  Copyright © 2018 陈圣治. All rights reserved.
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
