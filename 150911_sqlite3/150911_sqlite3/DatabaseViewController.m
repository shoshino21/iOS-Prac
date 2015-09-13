//
//  DatabaseViewController.m
//  150911_sqlite3
//
//  Created by shoshino21 on 9/13/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "DatabaseViewController.h"
#import <sqlite3.h>
#import "TableListTableViewController.h"

@interface DatabaseViewController ()

@property(strong, nonatomic) NSString *databasePath;
@property(nonatomic) sqlite3 *sqlite3Database;

@end

@implementation DatabaseViewController {
  //  sqlite3 *_sqlite3Database;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  //  NSString *docsDir;
  //  NSArray *dirPaths;
}

#pragma mark - Actions

- (IBAction)createDb:(UIButton *)sender {
  if ([self _createDatabase]) {
    // warning : whose view is not in the window hierarchy!
    [self performSegueWithIdentifier:@"showTableList" sender:sender];
  }
}

//// for Unwind Segue
//- (IBAction)backToDatabaseView:(UIStoryboardSegue *)segue {
//}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"showTableList"]) {
    //    TableListTableViewController *vc =
    //        (TableListTableViewController *)[segue destinationViewController];
  }
}

#pragma mark - Helper Methods

// return : DB是否可用
- (BOOL)_createDatabase {
  // 設定DB路徑檔名
  NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docsDir = dirPaths[0];

  self.databasePath = [[NSString alloc]
      initWithString:[docsDir stringByAppendingPathComponent:@"test.db"]];

  NSFileManager *filemgr = [NSFileManager defaultManager];

  if ([filemgr fileExistsAtPath:_databasePath] == NO) {
    // 建立資料庫
    if (sqlite3_open([self.databasePath UTF8String], &_sqlite3Database) ==
        SQLITE_OK) {
      NSLog(@"建立資料庫成功");
      return YES;
      /*/ 這邊是建table用的 /*/
      //      char *errMsg;
      //      const char *sql_stmt =
      //          "CREATE TABLE IF NOT EXISTS TEST (ID INTEGER PRIMARY KEY "
      //          "AUTOINCREMENT, NAME TEXT, GRADE INTEGER";
      //
      //      if (sqlite3_exec(_contactDB, sql_stmt, NULL, NULL, &errMsg) !=
      //          SQLITE_OK) {
      //        _status.text = @"Failed to create table";
      //      }
      //      sqlite3_close(_contactDB);
    } else {
      NSLog(@"資料庫建立失敗");
      return NO;
    }
  } else {
    NSLog(@"資料庫已經建立過了");
    return YES;
  }
}

@end
