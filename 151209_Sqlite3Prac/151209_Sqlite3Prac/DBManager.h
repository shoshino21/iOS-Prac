//
//  DBManager.h
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/9/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (strong, nonatomic) NSString *dbPath;

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
- (NSArray *)loadDataFromDB:(NSString *)query params:(NSArray *)params;
- (void)executeQuery:(NSString *)query params:(NSArray *)params;
//- (BOOL)saveDataToDB:(NSArray *)dataRows;;

// -1 : insert failed
- (NSInteger)lastInsertID;

@end
