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
  NSArray *allDataFromDB = [self.dbManager loadDataFromDB:@"SELECT * FROM USER" params:nil];
  [[DataModel sharedDataModel] copyDataFromArray:allDataFromDB];
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
    svc.currIndexPathRow = indexPathRow;
    NSString *currRowID = [DataModel sharedDataModel].items[indexPathRow][@"ID"];
    svc.currRowID = currRowID;

    BOOL isCustomPhotoPicked = [[DataModel sharedDataModel].items[indexPathRow][@"PHOTO_URL"] isEqualToString:@"Y"];
    svc.resizedPhotoImage = (isCustomPhotoPicked) ? [self p_imageFromSandboxWithFileName:currRowID] : nil;
  }
}

- (IBAction)backToMainWithUnwindSegue:(UIStoryboardSegue *)segue {
  SubViewController *svc = segue.sourceViewController;
  BOOL isCustomPhotoPicked = [svc.cellInputItems[SubViewCellTypePhoto] isEqualToString:@"Y"];

  if ([svc.lastSegueIdentifier isEqualToString:@"addData"]) {
    BOOL success = [self p_insertIntoDatabaseAndModel:svc.cellInputItems];
    if (success && isCustomPhotoPicked) {
      [self p_savePhotoImage:svc.resizedPhotoImage
                withFileName:[NSString stringWithFormat:@"%ld", (long)self.dbManager.lastInsertID]];
    }
  }
  else if ([svc.lastSegueIdentifier isEqualToString:@"editData"]) {
    BOOL success = [self p_updateDatabaseAndModel:svc.cellInputItems withID:svc.currRowID];
    if (success && isCustomPhotoPicked) {
      [self p_savePhotoImage:svc.resizedPhotoImage withFileName:svc.currRowID];
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

  if ([currRow[@"PHOTO_URL"] isEqualToString:@"Y"]) {
    cellView.photoImageView.image = [self p_imageFromSandboxWithFileName:currRow[@"ID"]];
  } else {
    NSString *imageName = currRow[@"GENDER"] ?: @"U";
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
    BOOL isCustomPhotoPicked = [[DataModel sharedDataModel].items[indexPath.row][@"PHOTO_URL"] isEqualToString:@"Y"];

    BOOL success = [self p_deleteDatabaseAndModelWithID:idToDelete];
    if (success && isCustomPhotoPicked) {
      [self p_deletePhotoImageWithFileName:idToDelete];
    }

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
  paramDict[@"ID"] = [NSString stringWithFormat:@"%ld", lastInsertID];
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

- (BOOL)p_updateDatabaseAndModel:(NSArray *)inArray withID:(NSString *)anID {
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

- (BOOL)p_deleteDatabaseAndModelWithID:(NSString *)anID {
  [self.dbManager executeQuery:@"DELETE FROM USER WHERE ID=?" params:@[anID]];
  BOOL success = [[DataModel sharedDataModel] removeDataWithID:[anID integerValue]];
  return success;
}

- (UIImage *)p_imageFromSandboxWithFileName:(NSString *)theFileName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths[0];
  NSString *fileNameWithPaths = [NSString stringWithFormat:@"%@/%@", documentsDirectory, theFileName];
  return [UIImage imageWithContentsOfFile:fileNameWithPaths];
}

- (BOOL)p_savePhotoImage:(UIImage *)anImage withFileName:(NSString *)theFileName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths[0];
  NSString *fileNameWithPaths = [NSString stringWithFormat:@"%@/%@", documentsDirectory, theFileName];

  BOOL success = [UIImageJPEGRepresentation(anImage, 0.8) writeToFile:fileNameWithPaths atomically:YES];
  return success;
}

- (BOOL)p_deletePhotoImageWithFileName:(NSString *)theFileName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths[0];
  NSString *fileNameWithPaths = [NSString stringWithFormat:@"%@/%@", documentsDirectory, theFileName];

  NSError *error;
  BOOL success = [[NSFileManager defaultManager] removeItemAtPath:fileNameWithPaths error:&error];
  if (success) {
    return YES;
  } else {
    NSLog(@"Deleting error: %@", error.localizedDescription);
    return NO;
  }
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
