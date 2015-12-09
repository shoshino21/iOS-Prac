//
//  DBManager.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/9/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager () {
  sqlite3 *_sqlite3db;
}

@property (strong, nonatomic) NSMutableArray *arrResults;
@property (strong, nonatomic) NSMutableArray *arrColumnNames;

@end

@implementation DBManager

#pragma mark - Init

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename {
  self = [super init];
  if (self) {
    [self p_initializeProperties];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    _dbPath = [documentsDirectory stringByAppendingPathComponent:dbFilename];

    if (![[NSFileManager defaultManager] fileExistsAtPath:_dbPath]) {
      // The database file does not exist in the documents directory, so copy it from the main bundle now.
      NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFilename];
      NSError *error;
      [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:_dbPath error:&error];

      if (error) {
        NSLog(@"DB copy failed: %@", error.localizedDescription);
      }
    }

    // Open or Create DB
    BOOL isOpenDbOK = sqlite3_open([_dbPath UTF8String], &_sqlite3db);
    if (isOpenDbOK != SQLITE_OK) {
      NSLog(@"Open DB Error: %@", [NSString stringWithUTF8String:sqlite3_errmsg(_sqlite3db)]);
      sqlite3_close(_sqlite3db);
    }
    else {
      // Create tables if not exists
      char *errMsg;
      const char *sql_stmt;
      sql_stmt = "CREATE TABLE IF NOT EXISTS USER (ID integer PRIMARY KEY AUTOINCREMENT, NO integer, NAME text, GENDER text, BIRTH integer, PHOTO_URL text, PHONE text)";

      if (sqlite3_exec(_sqlite3db, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
        NSLog(@"Create Table USER failed.");
        if (errMsg) {
          NSLog(@"Error: %@", [NSString stringWithUTF8String:errMsg]);
        }
      }
    }

    sqlite3_close(_sqlite3db);
  }
  return self;
}

#pragma mark - Methods

- (NSArray *)loadDataFromDB:(NSString *)query params:(NSArray *)params {
  [self p_runQuery:[query UTF8String] params:params isSelectQuery:YES];
  return (NSArray *)self.arrResults;
}

- (void)executeQuery:(NSString *)query params:(NSArray *)params {
  [self p_runQuery:[query UTF8String] params:params isSelectQuery:NO];
}

#pragma mark - Private

- (void)p_initializeProperties {
  if (_arrResults) {
    [_arrResults removeAllObjects];
  }
  _arrResults = [[NSMutableArray alloc] init];

  if (_arrColumnNames) {
    [_arrColumnNames removeAllObjects];
  }
  _arrColumnNames = [[NSMutableArray alloc] init];
}

- (void)p_runQuery:(const char *)query params:(NSArray *)params isSelectQuery:(BOOL)isSelectQuery {
  [self p_initializeProperties];

  // Open DB
  BOOL isOpenDbOK = sqlite3_open([self.dbPath UTF8String], &_sqlite3db);
  if (isOpenDbOK != SQLITE_OK) {
    NSLog(@"Error: %@", [NSString stringWithUTF8String:sqlite3_errmsg(_sqlite3db)]);
    sqlite3_close(_sqlite3db);
  }

  // Prepare statement
  sqlite3_stmt *compiledStatement;
  BOOL isPrepareStatementOK = sqlite3_prepare_v2(_sqlite3db, query, -1, &compiledStatement, NULL);
  if (isPrepareStatementOK != SQLITE_OK) {
    NSLog(@"Error: %@", [NSString stringWithUTF8String:sqlite3_errmsg(_sqlite3db)]);
    sqlite3_finalize(compiledStatement);
    sqlite3_close(_sqlite3db);
    return;
  }

  // Bind parameters to prepared statement
  for (int i = 0; i < params.count; i++) {
    BOOL isBindingOK = sqlite3_bind_text(compiledStatement, i + 1, [params[i] UTF8String], -1, SQLITE_TRANSIENT);
    if (isBindingOK != SQLITE_OK) {
      NSLog(@"Error: %@", [NSString stringWithUTF8String:sqlite3_errmsg(_sqlite3db)]);
      sqlite3_finalize(compiledStatement);
      sqlite3_close(_sqlite3db);
      return;
    }
  }

  // Execute query
  if (isSelectQuery) {
    NSMutableArray *arrDataRow;

    while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
      // 一次取一列資料
      arrDataRow = [[NSMutableArray alloc] init];
      int totalColumns = sqlite3_column_count(compiledStatement);

      for (int i = 0; i < totalColumns; i++) {
        // 取得各欄位資料
        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
        if (dbDataAsChars) {
          [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
        }
        // 取得各欄位名稱
        if (self.arrColumnNames.count != totalColumns) {
          dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
          [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
        }
      }
      // 將取得列寫入最後查詢結果
      if (arrDataRow.count > 0) {
        [self.arrResults addObject:arrDataRow];
      }
    }

  } else {
    // 非Select查詢
    if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
      NSLog(@"Error: %@", [NSString stringWithUTF8String:sqlite3_errmsg(_sqlite3db)]);
    }
  }
  sqlite3_finalize(compiledStatement);
  sqlite3_close(_sqlite3db);
}

@end
