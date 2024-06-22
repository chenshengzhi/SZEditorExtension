//
//  SZPropertyGetterViewController.m
//  SZEditorExtension
//
//  Created by csz on 2018/6/9.
//

#import "SZPropertyGetterViewController.h"
#import "SZPropertyGetterModel.h"
#import "SZEditorExtensionHeader.h"

@interface SZPropertyGetterViewController () <NSTableViewDataSource, NSTableViewDelegate, NSTextViewDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet NSTableView *tableView;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSPopUpButton *popUpButton;

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic) SZEEPropertyGetterPosition position;
@property (nonatomic, strong) NSMutableArray<SZPropertyGetterModel *> *dataSource;

@end

@implementation SZPropertyGetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaults = [[NSUserDefaults alloc] initWithSuiteName:SZEEUserdefaultSuiteName];
    
    self.position = [self.defaults integerForKey:SZEEPropertyGetterPositionKey];
    [self.popUpButton selectItemAtIndex:self.position];
    
    NSDictionary *dict = [self.defaults objectForKey:SZEEPropertyGetterDictKey];
    self.dataSource = [NSMutableArray array];
    if (dict.count) {
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            SZPropertyGetterModel *model = [[SZPropertyGetterModel alloc] init];
            model.typeName = key;
            model.templateText = obj;
            [self.dataSource addObject:model];
        }];
    } else  {
        /// todo load default getter template
    }
}

- (IBAction)addActionHandler:(id)sender {
    SZPropertyGetterModel *model = [[SZPropertyGetterModel alloc] init];
    model.templateText = SZEEPropertyGetterDictUndefinedValue;
    [self.dataSource addObject:model];
    [self.tableView reloadData];
    
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:self.dataSource.count-1] byExtendingSelection:NO];
}

- (IBAction)deleteActionHandler:(id)sender {
    if (self.tableView.selectedRow < self.dataSource.count) {
        [self.dataSource removeObjectAtIndex:self.tableView.selectedRow];
        [self.tableView reloadData];
    }
}

- (IBAction)saveAcionHandler:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self.dataSource enumerateObjectsUsingBlock:^(SZPropertyGetterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.typeName.length) {
            dict[obj.typeName] = obj.templateText;
        }
    }];
    [self.defaults setObject:dict forKey:SZEEPropertyGetterDictKey];
    [self.defaults synchronize];
}

- (IBAction)popUpActionHandler:(id)sender {
    self.position = [self.popUpButton indexOfSelectedItem];
    [self.defaults setInteger:self.position forKey:SZEEPropertyGetterPositionKey];
    [self.defaults synchronize];
}

#pragma mark - NSTableViewDataSource -
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.dataSource.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTextField *cell = [tableView makeViewWithIdentifier:@"cell" owner:self];
    if (!cell) {
        cell = [[NSTextField alloc] initWithFrame:CGRectZero];
        cell.alignment = NSTextAlignmentLeft;
        cell.bordered = NO;
        cell.identifier = @"cell";
        cell.delegate = self;
        cell.tag = row;
        cell.backgroundColor = [NSColor clearColor];
    }
    if (row < self.dataSource.count) {
        cell.stringValue = self.dataSource[row].typeName;
    }
    return cell;
}

#pragma mark - <NSTableViewDelegate> -
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = self.tableView.selectedRow;
    if (row < self.dataSource.count) {
        self.textView.string = self.dataSource[row].templateText;
    }
}

- (void)textDidChange:(NSNotification *)notification {
    if (notification.object == self.textView) {
        NSUInteger row = self.tableView.selectedRow;
        if (row < self.dataSource.count) {
            self.dataSource[row].templateText = [self.textView.string copy];
        }
    }
}

#pragma mark - <NSTextFieldDelegate> -
- (void)controlTextDidChange:(NSNotification *)obj {
    NSTextField *field = obj.object;
    if (field.tag < self.dataSource.count) {
        self.dataSource[field.tag].typeName = field.stringValue;
    }
}

@end
