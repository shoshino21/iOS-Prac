//
//  EditInfoViewController.m
//  150913_sqlite3_AppCoda
//
//  Created by shoshino21 on 9/13/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "EditInfoViewController.h"
#import "DBManager.h"

@interface EditInfoViewController ()

@property(nonatomic, strong) DBManager *dbManager;

- (void)loadInfoToEdit;

@end

@implementation EditInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  // Make self the delegate of the textfields.
  //  self.txtFirstname.delegate = self;
  //  self.txtLastname.delegate = self;
  //  self.txtAge.delegate = self;
  self.nameTextField.delegate = self;
  self.gradeTextField.delegate = self;

  // Set the navigation bar tint color.
  //  self.navigationController.navigationBar.tintColor =
  //      self.navigationItem.rightBarButtonItem.tintColor;

  // Initialize the dbManager object.
  self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.sql"];

  // Check if should load specific record for editing.

  // NOTE: 不為-1，表示是編輯資料而非新增
  if (self.recordIDToEdit != -1) {
    // Load the record with the specific ID from the database.
    [self loadInfoToEdit];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITextFieldDelegate method implementation

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - IBAction method implementation

- (IBAction)saveInfo:(id)sender {
  // Prepare the query string.
  // If the recordIDToEdit property has value other than -1, then create an
  // update query. Otherwise create an insert query.
  NSString *query;
  if (self.recordIDToEdit == -1) {
    query = [NSString
        stringWithFormat:@"insert into peopleInfo values(null, '%@', %d)",
                         self.nameTextField.text,
                         [self.gradeTextField.text intValue]];

    //    query = [NSString
    //             stringWithFormat:@"insert into peopleInfo values(null, '%@',
    //             %d)",
    //             self.txtFirstname.text, self.txtLastname.text,
    //             [self.txtAge.text intValue]];
  } else {
    query = [NSString
        stringWithFormat:
            @"update peopleInfo set name='%@', grade=%d where peopleInfoID=%d",
            self.nameTextField.text, [self.gradeTextField.text intValue],
            self.recordIDToEdit];
    //    query = [NSString
    //             stringWithFormat:@"update peopleInfo set firstname='%@', "
    //             @"lastname='%@', age=%d where peopleInfoID=%d",
    //             self.txtFirstname.text, self.txtLastname.text,
    //             self.txtAge.text.intValue, self.recordIDToEdit];
  }

  // Execute the query.
  [self.dbManager executeQuery:query];

  // If the query was successfully executed then pop the view controller.
  if (self.dbManager.affectedRows != 0) {
    NSLog(@"指令執行成功，共影響 %d 列", self.dbManager.affectedRows);

    // Inform the delegate that the editing was finished.
    [self.delegate editingInfoWasFinished];

    // Pop the view controller.
    [self.navigationController popViewControllerAnimated:YES];
  } else {
    NSLog(@"指令執行失敗");
  }
}

#pragma mark - Private method implementation

- (void)loadInfoToEdit {
  // Create the query.
  NSString *query = [NSString
      stringWithFormat:@"select * from peopleInfo where peopleInfoID=%d",
                       self.recordIDToEdit];

  // Load the relevant data.
  NSArray *results =
      [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

  // Set the loaded data to the textfields.
  //  self.txtFirstname.text = [[results objectAtIndex:0]
  //      objectAtIndex:[self.dbManager.arrColumnNames
  //      indexOfObject:@"firstname"]];
  //  self.txtLastname.text = [[results objectAtIndex:0]
  //      objectAtIndex:[self.dbManager.arrColumnNames
  //      indexOfObject:@"lastname"]];
  //  self.txtAge.text = [[results objectAtIndex:0]
  //      objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"age"]];
  self.nameTextField.text = [[results objectAtIndex:0]
      objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]];
  self.gradeTextField.text = [[results objectAtIndex:0]
      objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"grade"]];
}

@end
