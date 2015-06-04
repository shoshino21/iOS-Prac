//
//  ToDoListTableViewController.m
//  150508_ToDoList
//
//  Created by shoshino21 on 5/8/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "CustomTableViewCell.h"
#import "AddToDoItemViewController.h"

@interface ToDoListTableViewController ()

@property(strong, nonatomic) NSString *plistPath;
@property(strong, nonatomic) NSMutableArray *toDoListSource;
@property(strong, nonatomic) IBOutlet UITableView *toDoTableView;

@end

@implementation ToDoListTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Get .plist file path
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  self.plistPath = [[paths objectAtIndex:0]
      stringByAppendingPathComponent:@"ToDoList.plist"];

  // Check if file exists at path
  if ([[NSFileManager defaultManager] fileExistsAtPath:self.plistPath]) {
    self.toDoListSource =
        [[NSMutableArray alloc] initWithContentsOfFile:self.plistPath];
  } else {
    self.toDoListSource = [[NSMutableArray alloc] init];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.1
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.toDoListSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CustomTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"ToDoCustomCell"
                                      forIndexPath:indexPath];

  // Show data on cell from .plist
  NSDictionary *currentDictionary =
      [self.toDoListSource objectAtIndex:indexPath.row];

  cell.contentLabel.text = [currentDictionary objectForKey:@"content"];

  if ([[currentDictionary objectForKey:@"isFinished"] isEqual:@YES]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }

  NSDate *modifyDateTime = [currentDictionary objectForKey:@"modifyDateTime"];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss ccc"];
  cell.modifyDateTimeLabel.text = [formatter stringFromDate:modifyDateTime];

  return cell;
}

#pragma mark - Delete item

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete data from array and save into plist
    [self.toDoListSource removeObjectAtIndex:indexPath.row];
    if ([self.toDoListSource writeToFile:self.plistPath atomically:YES] == NO) {
      NSLog(@"\nSave to file failed!");
    }

    // Delete the row from the data source
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
  }
  //		else if (editingStyle == UITableViewCellEditingStyleInsert) {}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Tap to switch isFinished flag

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Cancel selected row
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  NSMutableDictionary *tappedDictionary = [[NSMutableDictionary alloc]
      initWithDictionary:[self.toDoListSource objectAtIndex:indexPath.row]];

  // Switch flag
  if ([[tappedDictionary objectForKey:@"isFinished"] boolValue] == YES) {
    [tappedDictionary setObject:@NO forKey:@"isFinished"];
  } else {
    [tappedDictionary setObject:@YES forKey:@"isFinished"];
  }

  // Save into array & plist
  [self.toDoListSource setObject:tappedDictionary
              atIndexedSubscript:indexPath.row];
  if ([self.toDoListSource writeToFile:self.plistPath atomically:YES] == NO) {
    NSLog(@"\nSave to file failed!");
  }

  // Update selected row
  [tableView reloadRowsAtIndexPaths:@[ indexPath ]
                   withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Add item to plist

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
  // Add a To-Do Item to plist
  AddToDoItemViewController *source = [segue sourceViewController];

  // Check if save button is pressed (equal to dictionaryToAdd isn't nil)
  if (source.dictionaryToAdd) {
    [self.toDoListSource addObject:source.dictionaryToAdd];

    if ([self.toDoListSource writeToFile:self.plistPath atomically:YES] == NO) {
      NSLog(@"\nSave to file failed!");
    }
  }

  // Update TableView
  [self.tableView reloadData];
}

#pragma mark - Move item

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
  // Switch status of edit button
  if (self.toDoTableView.isEditing) {
    sender.title = @"Edit";
    self.toDoTableView.editing = NO;
  } else {
    sender.title = @"Done";
    self.toDoTableView.editing = YES;
  }
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView
    canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the item to be re-orderable.
  return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
           toIndexPath:(NSIndexPath *)toIndexPath {
  // Exchange items in array & save into plist
  [self.toDoListSource exchangeObjectAtIndex:fromIndexPath.row
                           withObjectAtIndex:toIndexPath.row];
  if ([self.toDoListSource writeToFile:self.plistPath atomically:YES] == NO) {
    NSLog(@"\nSave to file failed!");
  }

  // Update TableView
  [self.tableView reloadData];
}
@end
