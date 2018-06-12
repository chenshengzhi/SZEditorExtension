//
//  SZEditorExtensionTests.m
//  SZEditorExtensionTests
//
//  Created by csz on 2016/9/24.
//  Copyright © 2016年 陈圣治. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SZRange.h"
#import "NSString+SZAddition.h"
#import "NSArray+SZAlignByEqualSign.h"

@interface SZEditorExtensionTests : XCTestCase

@end

@implementation SZEditorExtensionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testSZRangeMinus {
    SZRange *big = [SZRange rangeWithStart:20 end:100];
    SZRange *moreBig = [SZRange rangeWithStart:0 end:200];
    SZRange *small = [SZRange rangeWithStart:50 end:80];
    SZRange *front = [SZRange rangeWithStart:0 end:5];
    SZRange *front1 = [SZRange rangeWithStart:0 end:50];
    SZRange *rear = [SZRange rangeWithStart:150 end:200];
    SZRange *rear1 = [SZRange rangeWithStart:50 end:200];

    NSArray *minusResult = [big minusRange:moreBig];
    XCTAssert(minusResult.count == 0);

    NSArray *staticResult = @[[SZRange rangeWithStart:20 end:49], [SZRange rangeWithStart:81 end:100]];
    minusResult = [big minusRange:small];
    XCTAssert([minusResult isEqual:staticResult]);

    staticResult = @[big];
    minusResult = [big minusRange:front];
    XCTAssert([minusResult isEqual:staticResult]);

    minusResult = [big minusRange:rear];
    XCTAssert([minusResult isEqual:staticResult]);

    staticResult = @[[SZRange rangeWithStart:51 end:100]];
    minusResult = [big minusRange:front1];
    XCTAssert([minusResult isEqual:staticResult]);

    staticResult = @[[SZRange rangeWithStart:20 end:49]];
    minusResult = [big minusRange:rear1];
    XCTAssert([minusResult isEqual:staticResult]);
}

- (void)testSZRangeArrayMinus {
    NSMutableArray *sourceArray = [@[
                                     [SZRange rangeWithStart:0 end:100],
                                     ] mutableCopy];
    NSArray *minusArray = @[
                            [SZRange rangeWithStart:7 end:10],
                            [SZRange rangeWithStart:51 end:60],
                            [SZRange rangeWithStart:2 end:4],
                            [SZRange rangeWithStart:85 end:88],
                            ];
    [sourceArray minusArray:minusArray];
    NSLog(@"%@", sourceArray);
}

- (void)testPredicate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[#|@]?import"];
    NSString *text = @"import";
    XCTAssert([predicate evaluateWithObject:text]);
}

- (void)testAsignmentStatement {
    NSArray *array = @[
                       @"for (NSInteger idx = 0; idx < lines.count; idx++) {",
                       @"    NSString *lineText = lines[idx];",
                       @"    NSString *trimedLineText = [lineText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];",
                       @"    if (trimedLineText.length > 0) {",
                       @"        if ([trimedLineText isImportLine]) {",
                       @"            otherImportIndex = idx;",
                       @"        } else if (![trimedLineText hasPrefix:@\"//\"]) {",
                       @"            otherDefineIndex = idx;",
                       @"            break;",
                       @"        }",
                       @"    }",
                       @"}",
                       @"",
                       @"if (otherImportIndex >= 0) {",
                       @"    return otherImportIndex + 1;",
                       @"} else if (otherDefineIndex >= 0) {",
                       @"    return MAX(0, otherDefineIndex - 1);",
                       @"} else {",
                       @"    return 0;",
                       @"}",
                       ];
    for (NSString *text in array) {
        NSLog(@"%d  %@", [text isAsignmentStatement], text);
    }
}

- (void)testAlign {
    NSArray *array = @[
                       @"for (NSInteger idx = 0; idx < lines.count; idx++) {",
                       @"    NSString *lineText = lines[idx];",
                       @"    NSString *trimedLineText = [lineText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];",
                       @"    if (trimedLineText.length > 0) {",
                       @"        if ([trimedLineText isImportLine]) {",
                       @"            otherImportIndex = idx;",
                       @"        } else if (![trimedLineText hasPrefix:@\"//\"]) {",
                       @"            otherDefineIndex = idx;",
                       @"            break;",
                       @"        }",
                       @"    }",
                       @"}",
                       @"",
                       @"if (otherImportIndex >= 0) {",
                       @"    return otherImportIndex + 1;",
                       @"} else if (otherDefineIndex >= 0) {",
                       @"    return MAX(0, otherDefineIndex - 1);",
                       @"} else {",
                       @"    return 0;",
                       @"}",
                       ];
    NSLog(@"%@", [array alignedArrayByEqualSign]);
}

- (void)testNSStringAddition {
    NSString *string = [[NSString alloc] initWithContentsOfFile:@"/Users/csz/Documents/ubnt/frontrow-ios-editor/Classes/Main/View/FRVE2NavigationBar.m" usedEncoding:NULL error:nil];
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    NSInteger index = [array insertIdexForInterface:@"FRVE2NavigationBar" position:0];
    NSLog(@"%ld", index);
    index = [array insertIdexForInterface:@"FRVE2NavigationBar" position:1];
    NSLog(@"%ld", index);
}

@end
