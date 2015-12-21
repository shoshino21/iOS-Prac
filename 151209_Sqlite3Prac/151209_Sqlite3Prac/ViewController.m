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

@interface ViewController () {
  NSInteger _sortFieldIndex;
  NSInteger _sortOrderIndex;
}

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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)sortFieldChanged:(UISegmentedControl *)sender {
  _sortFieldIndex = sender.selectedSegmentIndex;
  [self p_sortAndReload];
}

- (IBAction)sortOrderChanged:(UISegmentedControl *)sender {
  _sortOrderIndex = sender.selectedSegmentIndex;
  [self p_sortAndReload];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  SubViewController *svc = segue.destinationViewController;
  svc.lastSegueIdentifier = segue.identifier;

  if ([segue.identifier isEqualToString:@"addData"]) {
    svc.navigationItem.title = @"新增資料";
  } else if ([segue.identifier isEqualToString:@"editData"]) {
    svc.navigationItem.title = @"編輯資料";

    NSInteger indexPathRow = [self.tableView indexPathForSelectedRow].row;
    svc.currDataID = [DataModel sharedDataModel].items[indexPathRow][@"ID"];
    svc.currIndexPathRow = indexPathRow;

    NSString *thePhotoUrl = [DataModel sharedDataModel].items[indexPathRow][@"PHOTO_URL"];
    svc.isCustomPhotoPicked = (thePhotoUrl.length != 0);
  }
}

- (IBAction)backToMainWithUnwindSegue:(UIStoryboardSegue *)segue {
  SubViewController *svc = segue.sourceViewController;

  if ([svc.lastSegueIdentifier isEqualToString:@"addData"]) {
    BOOL success = [self p_insertIntoDatabaseAndModel:svc.cellInputItems
                                  isCustomPhotoPicked:svc.isCustomPhotoPicked];

    if (success && svc.isCustomPhotoPicked) {
      [self p_saveResizedPhotoImage:svc.resizedPhotoImage
                       withFileName:[NSString stringWithFormat:@"%ld", (long)self.dbManager.lastInsertID]];
    }
  }

  else if ([svc.lastSegueIdentifier isEqualToString:@"editData"]) {
    BOOL success = [self p_updateDatabaseAndModel:svc.cellInputItems withID:svc.currDataID
                              isCustomPhotoPicked:svc.isCustomPhotoPicked];

    if (success && svc.isCustomPhotoPicked) {
      [self p_saveResizedPhotoImage:svc.resizedPhotoImage
                       withFileName:svc.currDataID];
    }
  }

  [self p_sortAndReload];
}

#pragma mark - Delegate (UITableViewDataSource / Delegate)

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

  NSDictionary *currRow = [DataModel sharedDataModel].items[indexPath.row];

  NSString *imageName;
  if ([currRow[@"PHOTO_URL"] length] != 0) {
    cellView.photoImageView.image = [self p_imageFromSandboxWithFileName:currRow[@"PHOTO_URL"]];
  } else {
    imageName = currRow[@"GENDER"] ?: @"U";
    cellView.photoImageView.image = [UIImage imageNamed:imageName];
  }

  cellView.nameLabel.text = currRow[@"NAME"];
  cellView.birthLabel.text = [self p_prettifyDate:currRow[@"BIRTH"]];

  return cellView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"editData" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSString *idToDelete = [DataModel sharedDataModel].items[indexPath.row][@"ID"];
    [self p_deleteDatabaseAndModelWithID:idToDelete];
    [self p_sortAndReload];
  }
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

- (BOOL)p_insertIntoDatabaseAndModel:(NSArray *)inArray isCustomPhotoPicked:(BOOL)isCustomPhotoPicked {
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

  NSString *lastInsertIDString = [NSString stringWithFormat:@"%ld", (long)lastInsertID];
  if (isCustomPhotoPicked) {
    [self.dbManager executeQuery:@"UPDATE USER SET PHOTO_URL=? WHERE ID=?" params:@[lastInsertIDString, lastInsertIDString]];
  }

  NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
  paramDict[@"ID"] = lastInsertIDString;
  paramDict[@"NUMBER"] = inArray[SubViewCellTypeNumber];
  paramDict[@"NAME"] = inArray[SubViewCellTypeName];
  paramDict[@"GENDER"] = inArray[SubViewCellTypeGender];
  paramDict[@"BIRTH"] = inArray[SubViewCellTypeBirth];
  paramDict[@"PHOTO_URL"] = (isCustomPhotoPicked) ? lastInsertIDString : @"";
  paramDict[@"PHONE"] = inArray[SubViewCellTypePhone];
  paramDict[@"EMAIL"] = inArray[SubViewCellTypeEmail];
  paramDict[@"ADDRESS"] = inArray[SubViewCellTypeAddress];

  BOOL success = [[DataModel sharedDataModel] addDataWithDictionary:paramDict];
  return success;
}

- (BOOL)p_updateDatabaseAndModel:(NSArray *)inArray withID:(NSString *)anID isCustomPhotoPicked:(BOOL)isCustomPhotoPicked {
  NSMutableArray *params = [[NSMutableArray alloc] init];
  [params addObject:inArray[SubViewCellTypeNumber]];
  [params addObject:inArray[SubViewCellTypeName]];
  [params addObject:inArray[SubViewCellTypeGender]];
  [params addObject:inArray[SubViewCellTypeBirth]];
  [params addObject:(isCustomPhotoPicked) ? anID : @""];
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
  paramDict[@"PHOTO_URL"] = (isCustomPhotoPicked) ? anID : @"";
  paramDict[@"PHONE"] = inArray[SubViewCellTypePhone];
  paramDict[@"EMAIL"] = inArray[SubViewCellTypeEmail];
  paramDict[@"ADDRESS"] = inArray[SubViewCellTypeAddress];

  BOOL success = [[DataModel sharedDataModel] updateDataWithDictionary:paramDict];
  return success;
}

- (BOOL)p_deleteDatabaseAndModelWithID:(NSString *)anID {
  [self.dbManager executeQuery:@"DELETE FROM USER WHERE ID=?" params:@[anID]];
  BOOL success = [[DataModel sharedDataModel] removeDataWithID:[anID integerValue]];
  return success;

#warning delete image method
}

- (BOOL)p_saveResizedPhotoImage:(UIImage *)anImage withFileName:(NSString *)theFileName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths[0];
  NSString *fileNameWithPaths = [NSString stringWithFormat:@"%@/%@", documentsDirectory, theFileName];

  BOOL success = [UIImageJPEGRepresentation(anImage, 0.8) writeToFile:fileNameWithPaths atomically:YES];
  return success;
}

- (UIImage *)p_imageFromSandboxWithFileName:(NSString *)theFileName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths[0];
  NSString *fileNameWithPaths = [NSString stringWithFormat:@"%@/%@", documentsDirectory, theFileName];
  return [UIImage imageWithContentsOfFile:fileNameWithPaths];
}

- (void)p_sortAndReload {
  NSString *key = (_sortFieldIndex == 0) ? @"NAME" : @"BIRTH";
  BOOL ascending = (_sortOrderIndex == 0);

  NSLog(@"Sort with field:%@ ascending:%d", key, ascending);
  [[DataModel sharedDataModel] sortWithKey:key isAscending:ascending];
  [self p_reloadTableViewInMainThread];
}

- (void)p_reloadTableViewInMainThread {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}

@end
