//
//  DBManager.m
//  150913_sqlite3_AppCoda
//
//  Created by shoshino21 on 9/13/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager ()

@property(nonatomic, strong) NSString *documentsDirectory;
@property(nonatomic, strong) NSString *databaseFilename;
@property(nonatomic, strong) NSMutableArray *arrResults;

- (void)copyDatabaseIntoDocumentsDirectory;

// NOTE: 之後會建兩個public method來呼叫這個private
// method，一個用來取資料，一個用來執行查詢指令
- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end

@implementation DBManager

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename {
  self = [super init];
  if (self) {
    // Set the documents directory path to the documentsDirectory property.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    self.documentsDirectory = [paths objectAtIndex:0];

    // Keep the database filename.
    self.databaseFilename = dbFilename;

    // Copy the database file into the documents directory if necessary.
    [self copyDatabaseIntoDocumentsDirectory];
  }
  return self;
}

#pragma mark - Private method implementation

- (void)copyDatabaseIntoDocumentsDirectory {
  // Check if the database file exists in the documents directory.
  NSString *destinationPath = [self.documentsDirectory
      stringByAppendingPathComponent:self.databaseFilename];
  if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
    // The database file does not exist in the documents directory, so copy it
    // from the main bundle now.
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath]
        stringByAppendingPathComponent:self.databaseFilename];
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                            toPath:destinationPath
                                             error:&error];

    // Check if any error occurred during copying and display it.
    if (error != nil) {
      NSLog(@"%@", [error localizedDescription]);
    }
  }
}

- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable {
  // Create a sqlite object.
  sqlite3 *sqlite3Database;

  // Set the database file path.
  NSString *databasePath = [self.documentsDirectory
      stringByAppendingPathComponent:self.databaseFilename];

  // NOTE: 每次呼叫都把這兩個array先清空
  // (才不會有殘骸留在記憶體裏)，再把reference設為nil

  // Initialize the results array.
  if (self.arrResults != nil) {
    [self.arrResults removeAllObjects];
    self.arrResults = nil;
  }
  self.arrResults = [[NSMutableArray alloc] init];

  // Initialize the column names array.
  if (self.arrColumnNames != nil) {
    [self.arrColumnNames removeAllObjects];
    self.arrColumnNames = nil;
  }
  self.arrColumnNames = [[NSMutableArray alloc] init];

  // Open the database.
  // NOTE: 使用sqlite3_open，如果還沒建立資料庫會Create，已經建立則會Open，
  //       所以不需要特地去判斷
  BOOL openDatabaseResult =
      sqlite3_open([databasePath UTF8String], &sqlite3Database);
  if (openDatabaseResult == SQLITE_OK) {
    // Declare a sqlite3_stmt object in which will be stored the query after
    // having been compiled into a SQLite statement.

    ////
    // 暫時把建table寫在這裏
    char *errMsg;
    const char *sql_stmt =
        "CREATE TABLE peopleInfo(peopleInfoID integer primary key, name text, "
        "grade integer)";

    if (sqlite3_exec(sqlite3Database, sql_stmt, NULL, NULL, &errMsg) !=
        SQLITE_OK) {
//      NSLog(@"Failed to create table");
    }
    ////

    // NOTE: 用來存放已經用sqlite3_prepare_v2編譯出來的SQLite指令
    //       (sqlite3_prepare_v2的功用就是把字串變成可執行的SQLite指令)
    sqlite3_stmt *compiledStatement;

    // Load all data from database to memory.
    // NOTE: 把query指令轉換成SQLite指令，放到compiledStatement裡面
    BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1,
                                                     &compiledStatement, NULL);
    if (prepareStatementResult == SQLITE_OK) {
      // Check if the query is non-executable.

      // NOTE: (重要)
      // queryExecutable參數(我們自己設的)如果為NO，表示要執行的是SELECT指令
      //       如果為YES，表示是INSERT, UPDATE, DELETE其中之一
      //

      if (!queryExecutable) {
        // NOTE: 要執行的指令是SELECT

        // In this case data must be loaded from the database.

        // Declare an array to keep the data for each fetched row.
        // NOTE: 用來放每一列的查詢結果用
        NSMutableArray *arrDataRow;

        // Loop through the results and add them to the results array row by
        // row.
        // NOTE: sqlite3_step就是真正執行SQLite指令的敘述式
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
          // Initialize the mutable array that will contain the data of a
          // fetched row.
          arrDataRow = [[NSMutableArray alloc] init];

          // Get the total number of columns.
          int totalColumns = sqlite3_column_count(compiledStatement);

          // Go through all columns and fetch each column data.
          for (int i = 0; i < totalColumns; i++) {
            // Convert the column data to text (characters).
            // NOTE: 把此列每一欄的資料抓出來，放進字串，
            //       然後再用UTF8轉成NSString寫到array裡面
            char *dbDataAsChars =
                (char *)sqlite3_column_text(compiledStatement, i);

            // If there are contents in the currenct column (field) then add
            // them to the current row array.
            if (dbDataAsChars != NULL) {
              // Convert the characters to string.
              [arrDataRow
                  addObject:[NSString stringWithUTF8String:dbDataAsChars]];
            }

            // Keep the current column name.
            if (self.arrColumnNames.count != totalColumns) {
              dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
              [self.arrColumnNames
                  addObject:[NSString stringWithUTF8String:dbDataAsChars]];
            }
          }

          // Store each fetched data row in the results array, but first check
          // if there is actually data.
          // NOTE: 取得列的查詢結果以後，寫入我們最後的查詢結果裡面
          if (arrDataRow.count > 0) {
            [self.arrResults addObject:arrDataRow];
          }
        }
      } else {
        // This is the case of an executable query (insert, update, ...).

        // NOTE: queryExecutable為YES，
        //       表示要執行的是INSERT, UPDATE, DELETE等指令

        // Execute the query.
        BOOL executeQueryResults = sqlite3_step(compiledStatement);
        if (executeQueryResults == SQLITE_DONE) {
          // Keep the affected rows.
          // NOTE: 直接用sqlite3_changes抓出有哪些列被改變了
          self.affectedRows = sqlite3_changes(sqlite3Database);

          // Keep the last inserted row ID.
          self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
        } else {
          // If could not execute the query show the error message on the
          // debugger.
          NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
        }
      }
    } else {
      // In the database cannot be opened then show the error message on the
      // debugger.
      NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
    }

    // Release the compiled statement from memory.
    sqlite3_finalize(compiledStatement);
  }

  // Close the database.
  sqlite3_close(sqlite3Database);
}

#pragma mark - Public method implementation

// NOTE: 吃NSString形式的SELECT指令，回傳查詢結果的NSArray
- (NSArray *)loadDataFromDB:(NSString *)query {
  // Run the query and indicate that is not executable.
  // The query string is converted to a char* object.
  [self runQuery:[query UTF8String] isQueryExecutable:NO];

  // Returned the loaded results.
  return (NSArray *)self.arrResults;
}

// NOTE: 吃NSString形式的INSERT, UPDATE, DELETE指令
- (void)executeQuery:(NSString *)query {
  // Run the query and indicate that is executable.
  [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
