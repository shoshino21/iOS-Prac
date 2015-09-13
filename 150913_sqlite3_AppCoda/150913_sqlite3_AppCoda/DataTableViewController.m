//
//  DataTableViewController.m
//  150913_sqlite3_AppCoda
//
//  Created by shoshino21 on 9/13/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "DataTableViewController.h"
#import "DBManager.h"

@interface DataTableViewController ()

@property(nonatomic, strong) DBManager *dbManager;

@property(nonatomic, strong) NSArray *arrPeopleInfo;

@property(nonatomic) int recordIDToEdit;

- (void)loadData;

@end

@implementation DataTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Initialize the dbManager property.
  self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.sql"];

  // Load the data.
  [self loadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  EditInfoViewController *editInfoViewController =
      [segue destinationViewController];
  editInfoViewController.delegate = self;
  editInfoViewController.recordIDToEdit = self.recordIDToEdit;
}

- (IBAction)addNewRecord:(id)sender {
  // Before performing the segue, set the -1 value to the recordIDToEdit. That
  // way we'll indicate that we want to add a new record and not to edit an
  // existing one.

  // NOTE: -1表示指定要新增而非編輯項目
  self.recordIDToEdit = -1;

  // Perform the segue.
  [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}

#pragma mark - Private method implementation

- (void)loadData {
  // Form the query.
  NSString *query = @"select * from peopleInfo";

  // Get the results.
  if (self.arrPeopleInfo != nil) {
    self.arrPeopleInfo = nil;
  }
  self.arrPeopleInfo =
      [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

  // Reload the table view.
  [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return self.arrPeopleInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Dequeue the cell.
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"idCellRecord"
                                      forIndexPath:indexPath];

  //  NSInteger indexOfFirstname =
  //      [self.dbManager.arrColumnNames indexOfObject:@"firstname"];
  //  NSInteger indexOfLastname =
  //      [self.dbManager.arrColumnNames indexOfObject:@"lastname"];
  //  NSInteger indexOfAge = [self.dbManager.arrColumnNames
  //  indexOfObject:@"age"];

  NSInteger indexOfName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
  NSInteger indexOfGrade =
      [self.dbManager.arrColumnNames indexOfObject:@"grade"];

  // Set the loaded data to the appropriate cell labels.
  cell.textLabel.text = [[self.arrPeopleInfo objectAtIndex:indexPath.row]
      objectAtIndex:indexOfName];
  //  cell.textLabel.text = [NSString
  //                         stringWithFormat:@"%@ %@",
  //                         [[self.arrPeopleInfo objectAtIndex:indexPath.row]
  //                          objectAtIndex:indexOfFirstname],
  //                         [[self.arrPeopleInfo objectAtIndex:indexPath.row]
  //                          objectAtIndex:indexOfLastname]];

  cell.detailTextLabel.text = [NSString
      stringWithFormat:@"成績: %@",
                       [[self.arrPeopleInfo objectAtIndex:indexPath.row]
                           objectAtIndex:indexOfGrade]];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60.0;
}

- (void)tableView:(UITableView *)tableView
    accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  // Get the record ID of the selected name and set it to the recordIDToEdit
  // property.
  self.recordIDToEdit = [[[self.arrPeopleInfo objectAtIndex:indexPath.row]
      objectAtIndex:0] intValue];

  // Perform the segue.
  [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the selected record.
    // Find the record ID.
    int recordIDToDelete = [[[self.arrPeopleInfo objectAtIndex:indexPath.row]
        objectAtIndex:0] intValue];

    // Prepare the query.
    NSString *query = [NSString
        stringWithFormat:@"delete from peopleInfo where peopleInfoID=%d",
                         recordIDToDelete];

    // Execute the query.
    [self.dbManager executeQuery:query];

    // Reload the table view.
    [self loadData];
  }
}

- (void)editingInfoWasFinished {
  // Reload the data.
  [self loadData];
}

@end
