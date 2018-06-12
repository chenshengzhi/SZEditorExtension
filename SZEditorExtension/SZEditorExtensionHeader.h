//
//  SZEditorExtensionHeader.h
//  SZEditorExtension
//
//  Created by csz on 2018/6/10.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#ifndef SZEditorExtensionHeader_h
#define SZEditorExtensionHeader_h

typedef NS_ENUM(NSInteger, SZEEPropertyGetterPosition) {
    SZEEPropertyGetterPositionImplementationStart,
    SZEEPropertyGetterPositionImplementationEnd,
};

#define SZEEUserdefaultSuiteName @"SZEditorExtension"
#define SZEEPropertyGetterDictKey @"com.csz.SZEditorExtension.propertyGetter.dict"

#define SZEEPropertyGetterPositionKey @"com.csz.SZEditorExtension.propertyGetter.position"

#define SZEEPropertyGetterDictUndefinedValue @""\
"- (###type### *)###name### {\n"\
"    if (!_###name###) {\n"\
"        _###name### = [[###type### alloc] init];\n"\
"    }\n"\
"    return _###name###;\n"\
"}"\

#endif /* SZEditorExtensionHeader_h */
