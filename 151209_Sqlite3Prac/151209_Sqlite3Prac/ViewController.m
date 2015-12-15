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

//@property (strong, nonatomic) NSMutableArray *tableItems;
@property (strong, nonatomic) DBManager *dbManager;

@end

@implementation ViewController

#pragma mark - View

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView.dataSource = self;
  self.tableView.delegate = self;

  self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"userdb.sql"];
  NSArray *dataFromDB = [self.dbManager loadDataFromDB:@"SELECT * FROM USER" params:nil];
  [[DataModel sharedDataModel] copyDataFromArray:dataFromDB];
}

//- (void)viewWillAppear:(BOOL)animated {
//  [super viewWillAppear:animated];
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [self.tableView reloadData];
//  });
//}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
#warning be careful with topViewController
  SubViewController *svc = segue.destinationViewController;
  svc.currSegueIdentifier = segue.identifier;

  if ([segue.identifier isEqualToString:@"addData"]) {
    svc.navigationItem.title = @"新增資料";
  } else if ([segue.identifier isEqualToString:@"editData"]) {
    svc.navigationItem.title = @"編輯資料";

    NSInteger indexPathRow = [self.tableView indexPathForSelectedRow].row;
    svc.currDataID = [DataModel sharedDataModel].items[indexPathRow][@"ID"];
    svc.currIndexPathRow = indexPathRow;
  }
}

- (IBAction)backToMainWithUnwindSegue:(UIStoryboardSegue *)segue {
  SubViewController *svc = segue.sourceViewController;

  if ([svc.currSegueIdentifier isEqualToString:@"addData"]) {
    [self p_insertIntoDatabaseAndModel:svc.cellInputItems];
  } else if ([svc.currSegueIdentifier isEqualToString:@"editData"]) {
    [self p_updateDatabaseAndModel:svc.cellInputItems whereID:svc.currDataID];
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}

#pragma mark - UITableViewDataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [DataModel sharedDataModel].count;
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
  cellView.nameLabel.text = [DataModel sharedDataModel].items[indexPath.row][@"NAME"];
  cellView.birthLabel.text = [self p_prettifyDate:[DataModel sharedDataModel].items[indexPath.row][@"BIRTH"]];

  return cellView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"editData" sender:self];
}

#pragma mark - Private

- (NSString *)p_prettifyDate:(NSString *)anUnixTimeStampString {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"YYYY/MM/dd"];

  NSTimeInterval unixTimeStamp = [anUnixTimeStampString doubleValue];
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimeStamp];
  NSString *dateString = [dateFormatter stringFromDate:date];

  return dateString;
}

- (BOOL)p_insertIntoDatabaseAndModel:(NSArray *)inArray {
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

  NSUInteger lastInsertID = self.dbManager.lastInsertID;
  if (lastInsertID == -1) {
    NSLog(@"Insert data failed");
    return NO;
  }

  NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
  paramDict[@"ID"] = [NSString stringWithFormat:@"%ld", (long)lastInsertID];
  paramDict[@"NUMBER"] = inArray[SubViewCellTypeNumber];
  paramDict[@"NAME"] = inArray[SubViewCellTypeName];
  paramDict[@"GENDER"] = inArray[SubViewCellTypeGender];
  paramDict[@"BIRTH"] = inArray[SubViewCellTypeBirth];
  paramDict[@"PHOTO_URL"] = inArray[SubViewCellTypePhoto];
  paramDict[@"PHONE"] = inArray[SubViewCellTypePhone];
  paramDict[@"EMAIL"] = inArray[SubViewCellTypeEmail];
  paramDict[@"ADDRESS"] = inArray[SubViewCellTypeAddress];

  BOOL success = [[DataModel sharedDataModel] addDataWithDictionary:paramDict];
  return success;
}

- (BOOL)p_updateDatabaseAndModel:(NSArray *)inArray whereID:(NSString *)anID {
  NSMutableArray *params = [[NSMutableArray alloc] init];
  [params addObject:inArray[SubViewCellTypeNumber]];
  [params addObject:inArray[SubViewCellTypeName]];
  [params addObject:inArray[SubViewCellTypeGender]];
  [params addObject:inArray[SubViewCellTypeBirth]];
  [params addObject:inArray[SubViewCellTypePhoto]];
  [params addObject:inArray[SubViewCellTypePhone]];
  [params addObject:inArray[SubViewCellTypeEmail]];
  [params addObject:inArray[SubViewCellTypeAddress]];
  [params addObject:anID];

  [self.dbManager executeQuery:@"UPDATE USER SET NUMBER=?, NAME=?, GENDER=?, BIRTH=?, PHOTO_URL=?, PHONE=?, EMAIL=?, ADDRESS=? WHERE ID=?" params:params];

  NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
  paramDict[@"ID"] = anID;
  paramDict[@"NUMBER"] = inArray[SubViewCellTypeNumber];
  paramDict[@"NAME"] = inArray[SubViewCellTypeName];
  paramDict[@"GENDER"] = inArray[SubViewCellTypeGender];
  paramDict[@"BIRTH"] = inArray[SubViewCellTypeBirth];
  paramDict[@"PHOTO_URL"] = inArray[SubViewCellTypePhoto];
  paramDict[@"PHONE"] = inArray[SubViewCellTypePhone];
  paramDict[@"EMAIL"] = inArray[SubViewCellTypeEmail];
  paramDict[@"ADDRESS"] = inArray[SubViewCellTypeAddress];

  BOOL success = [[DataModel sharedDataModel] updateDataWithDictionary:paramDict];
  return success;
}

@end
