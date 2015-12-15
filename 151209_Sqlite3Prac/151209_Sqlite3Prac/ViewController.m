//
//  ViewController.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/9/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"

#import "DBManager.h"
#import "DataModel.h"
#import "SubViewController.h"
#import "CustomTableViewCell.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *tableItems;
@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) DataModel *dataModel;

@end

@implementation ViewController

#pragma mark - View

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.dataSource = self;
  self.tableView.delegate = self;

  self.tableItems = [[NSMutableArray alloc] init];
  for (int i=0; i<30; i++) {
    [self.tableItems addObject:[NSString stringWithFormat:@"%d", i]];
  }

  self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"userdb.sql"];
  self.dataModel = [DataModel sharedDataModel];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)backToMainWithUnwindSegue:(UIStoryboardSegue *)segue {
  SubViewController *svc = segue.sourceViewController;

  if ([segue.identifier isEqualToString:@"fromAddDataSave"]) {
    [self p_insertIntoDatabaseAndModel:svc.cellInputItems];
  }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"addData"]) {
#warning be careful with topViewController
    SubViewController *svc = segue.destinationViewController;
    svc.navigationItem.title = @"新增資料";
  }
}

#pragma mark - UITableViewDataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tableItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"customCell";
  CustomTableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (!cellView) {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:nil options:nil];
    for (UIView *view in views) {
      if ([view isKindOfClass:[CustomTableViewCell class]]) {
        cellView = (CustomTableViewCell *)view;
      }
    }
  }

  cellView.photoImageView.image = [UIImage imageNamed:@"f"];
  cellView.nameLabel.text = self.tableItems[indexPath.row];
  cellView.birthLabel.text = @"2015/02/02";
  
  return cellView;
}

#pragma mark - Private

- (void)p_insertIntoDatabaseAndModel:(NSArray *)inArray {
  NSMutableArray *params = [[NSMutableArray alloc] init];
  [params addObject:inArray[SubViewCellTypeNumber]];
  [params addObject:inArray[SubViewCellTypeName]];
  [params addObject:inArray[SubViewCellTypeGender]];
  [params addObject:inArray[SubViewCellTypeBirth]];
  [params addObject:inArray[SubViewCellTypePhoto]];
  [params addObject:inArray[SubViewCellTypePhone]];
  [params addObject:inArray[SubViewCellTypeEmail]];
  [params addObject:inArray[SubViewCellTypeAddress]];

  [self.dbManager executeQuery:@"INSERT INTO USER (NUMBER, NAME, GENDER, BIRTH, PHOTO_URL, PHONE, EMAIL, ADDRESS) VALUES (?,?,?,?,?,?,?,?)" params:params];

  if (self.dbManager.lastInsertID == -1) {
    NSLog(@"Insert data failed");
    return;
  }

  NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
  paramDict[@"ID"] = [NSString stringWithFormat:@"%ld", (long)self.dbManager.lastInsertID];
  paramDict[@"NUMBER"] = inArray[SubViewCellTypeNumber];
  paramDict[@"NAME"] = inArray[SubViewCellTypeName];
  paramDict[@"GENDER"] = inArray[SubViewCellTypeGender];
  paramDict[@"BIRTH"] = inArray[SubViewCellTypeBirth];
  paramDict[@"PHOTO_URL"] = inArray[SubViewCellTypePhoto];
  paramDict[@"PHONE"] = inArray[SubViewCellTypePhone];
  paramDict[@"EMAIL"] = inArray[SubViewCellTypeEmail];
  paramDict[@"ADDRESS"] = inArray[SubViewCellTypeAddress];

  [self.dataModel addDataWithDictionary:paramDict];
}

@end
