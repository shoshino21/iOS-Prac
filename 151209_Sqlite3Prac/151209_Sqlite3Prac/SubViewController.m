//
//  SubViewController.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/10/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SubViewController.h"

#import "InputViewController.h"
#import "PhotoTableViewCell.h"

@interface SubViewController ()

@property (strong, nonatomic) NSMutableArray *cellInputItems;
@property (strong, nonatomic) NSArray *cellTitles;
//@property (assign, nonatomic) SubViewCellType cellStyle;

@end

@implementation SubViewController

#pragma mark - View

- (void)viewDidLoad {
  [super viewDidLoad];

  self.subTableView.dataSource = self;
  self.subTableView.delegate = self;

  self.cellTitles = @[@"照片", @"編號 *", @"名字 *", @"性別 *", @"生日 *", @"電話", @"E-mail", @"住址"];
  self.cellInputItems = [[NSMutableArray alloc] initWithCapacity:self.cellTitles.count];
  [self.cellInputItems addObjectsFromArray:@[@"", @"", @"", @"", @"", @"", @"", @""]];

#warning test
  self.cellInputItems[SubViewCellTypeEmail] = @"E-mail";

  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)save:(UIBarButtonItem *)sender {
#warning check for non-null fields here
}

- (IBAction)backToSubWithUnwindSegue:(UIStoryboardSegue *)segue {

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"toInputView"]) {
#warning be careful with topViewController issue
    InputViewController *ivc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.subTableView indexPathForSelectedRow];

    ivc.cellInputItems = self.cellInputItems;
    ivc.cellType = (SubViewCellType)indexPath.row;
    ivc.navigationItem.title = self.cellTitles[indexPath.row];
  }
}

#pragma mark - UITableViewDataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.cellTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return (indexPath.row == SubViewCellTypePhoto) ? 100.f : 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier;
  cellIdentifier = (indexPath.row == SubViewCellTypePhoto) ? @"photoCell" : @"dataCell";
  UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (!cellView) {
    if (indexPath.row == SubViewCellTypePhoto) {
      cellView = [[PhotoTableViewCell alloc] init];
    } else {
      cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
  }

  if (indexPath.row == SubViewCellTypePhoto) {
    PhotoTableViewCell *photoCellView = (PhotoTableViewCell *)cellView;
    photoCellView.photoImageView.image = [UIImage imageNamed:@"f"];
  } else {
    cellView.textLabel.text = self.cellTitles[indexPath.row];
    cellView.detailTextLabel.text = self.cellInputItems[indexPath.row];
  }

  return cellView;
}

@end
