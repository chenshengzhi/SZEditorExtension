//
//  SZEditorExtensionHeader.h
//  SZEditorExtension
//
//  Created by csz on 2018/6/10.
//  Copyright © 2018 陈圣治. All rights reserved.
//

#ifndef SZEditorExtensionHeader_h
#define SZEditorExtensionHeader_h

typedef NS_ENUM(NSUInteger, SZEEPropertyGetterPosition) {
    SZEEPropertyGetterPositionImplementationStart,
    SZEEPropertyGetterPositionBeforeImplementationEnd,
};

#define SZEEUserdefaultSuiteName @"SZEditorExtension"
#define SZEEPropertyGetterDictKey @"com.csz.SZEditorExtension.propertyGetter"
#define SZEEPropertyGetterDictTemplateTextKey @"com.csz.SZEditorExtension.propertyGetter.templateText"
#define SZEEPropertyGetterDictPositionKey @"com.csz.SZEditorExtension.propertyGetter.position"

#define SZEEPropertyGetterDictUndefinedValue @""\
"- (###type### *)###name### {\n"\
"    if (!_###name###) {\n"\
"        _###name### = [[###type### alloc] init];\n"\
"    }\n"\
"    return _###name###;\n"\
"}"\

#endif /* SZEditorExtensionHeader_h */
