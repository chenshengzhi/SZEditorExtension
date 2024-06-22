//
//  main.m
//  SZPlaceImports
//
//  Created by csz on 2024.06.22.
//

#import <Foundation/Foundation.h>
#import "NSArray+SZAddition.h"
#import "NSString+SZAddition.h"
#import "SZPlaceImportHelper.h"

NSArray<NSString *> *splitedLines(NSString *contents) {
    NSUInteger start = 0;
    NSUInteger count = contents.length;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSUInteger idx = 0; idx < count; idx++) {
        unichar c = [contents characterAtIndex:idx];
        if (c == '\n') {
            NSRange range = NSMakeRange(start, idx + 1 - start);
            NSString *line = [contents substringWithRange:range];
            [tempArray addObject:line];
            start = idx + 1;
        }
    }
    if (start < count) {
        NSRange range = NSMakeRange(start, count - start);
        NSString *line = [contents substringWithRange:range];
        [tempArray addObject:line];
    }
    return [tempArray copy];
}

BOOL isSupportedFile(NSString *filePath) {
    if (![filePath sz_isFileExist]) {
        return NO;
    }
    NSString *extension = filePath.pathExtension.lowercaseString;
    if (![extension isEqualToString:@"h"] && ![extension isEqualToString:@"m"]) {
        return NO;
    }
    return YES;
}

void processFile(NSString *filePath) {
    @autoreleasepool {
        if (!isSupportedFile(filePath)) {
            return;
        }
        NSStringEncoding encoding = NSUTF8StringEncoding;
        NSString *contents = [NSString stringWithContentsOfFile:filePath usedEncoding:&encoding error:nil];
        if (!contents.length) {
            return;
        }
        NSArray<NSString *> *lines = splitedLines(contents);
        lines = [SZPlaceImportHelper processLines:lines
                                       selections:@[]
                                commandIdentifier:nil];
        contents = [lines componentsJoinedByString:@""];
        [contents writeToFile:filePath atomically:YES encoding:encoding error:nil];
    }
}

NSArray<NSString *> *findSupportedFiles(NSString *directory) {
    NSURL *directoryURL = [NSURL fileURLWithPath:directory];
    NSDirectoryEnumerator *enumerator = [NSFileManager.defaultManager enumeratorAtURL:directoryURL
                                                           includingPropertiesForKeys:nil
                                                                              options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                         errorHandler:nil];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSURL *url in enumerator) {
        if (!isSupportedFile(url.path)) {
            continue;
        }
        [tempArray addObject:url.path];
    }
    return [tempArray copy];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        for (int i = 1; i < argc; i++) {
            NSString *path = [[NSString alloc] initWithCString:argv[i] encoding:NSUTF8StringEncoding];
            path = [path stringByResolvingSymlinksInPath];
            if ([path sz_isDirectory]) {
                NSArray *files = findSupportedFiles(path);
                for (NSString *file in files) {
                    processFile(file);
                }
            } else {
                processFile(path);
            }
        }
    }
    return 0;
}
