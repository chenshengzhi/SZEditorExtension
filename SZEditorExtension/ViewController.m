//
//  ViewController.m
//  SZEditorExtension
//
//  Created by csz on 2016/9/24.
//  Copyright © 2016年 陈圣治. All rights reserved.
//

#import "ViewController.h"
#import "SZEditorExtensionHeader.h"

@interface ViewController ()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaults = [[NSUserDefaults alloc] initWithSuiteName:SZEEUserdefaultSuiteName];
}

- (IBAction)copyToPastBoard:(NSButton *)sender {
    BOOL doCopy = sender.doubleValue;
    BOOL withoutCopy = !doCopy;
    [self.defaults setBool:withoutCopy forKey:SZEESelectMethodWithoutCopyToPastBoardKey];
    [self.defaults synchronize];
}

@end
