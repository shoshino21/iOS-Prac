//
//  SubViewController.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/10/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SubViewController.h"
#import "PhotoTableViewCell.h"

@interface SubViewController ()

@property (strong, nonatomic) NSMutableArray *subTableItems;

@end

@implementation SubViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.subTableView.dataSource = self;
  self.subTableView.delegate = self;
  self.subTableItems = [[NSMutableArray alloc] init];

#warning test
  [self.subTableItems addObject:@"a"];
  [self.subTableItems addObject:@"b"];
  [self.subTableItems addObject:@"c"];
  [self.subTableItems addObject:@"d"];
  [self.subTableItems addObject:@"a"];
  [self.subTableItems addObject:@"a"];
  [self.subTableItems addObject:@"a"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)save:(UIBarButtonItem *)sender {

}

#pragma mark - UITableViewDataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return (indexPath.row == 0) ? 100.f : 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier;
  cellIdentifier = (indexPath.row == 0) ? @"photoCell" : @"dataCell";
  UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (!cellView) {
    if (indexPath.row == 0) {
      cellView = [[PhotoTableViewCell alloc] init];
    } else {
      cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"dataCell"];
    }
  }

  if (indexPath.row == 0) {
    PhotoTableViewCell *photoCellView = (PhotoTableViewCell *)cellView;
    photoCellView.photoImageView.image = [UIImage imageNamed:@"f"];
  } else {
    cellView.textLabel.text = self.subTableItems[indexPath.row];
    cellView.detailTextLabel.text = self.subTableItems[indexPath.row];
  }

  return cellView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
