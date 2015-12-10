//
//  ViewController.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/9/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *tableItems;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.dataSource = self;
  self.tableView.delegate = self;

  self.tableItems = [[NSMutableArray alloc] init];
  [self.tableItems addObject:@"aaa"];
  [self.tableItems addObject:@"bbb"];
  [self.tableItems addObject:@"ccc"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"CustomCell";
  CustomTableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (!cellView) {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:nil options:nil];
    for (UIView *view in views) {
      if ([view isKindOfClass:[CustomTableViewCell class]]) {
        cellView = (CustomTableViewCell *)view;
      }
    }
  }

  cellView.nameLabel.text = @"abc";
  cellView.birthLabel.text = @"2015/02/02";
  return cellView;
}

@end
