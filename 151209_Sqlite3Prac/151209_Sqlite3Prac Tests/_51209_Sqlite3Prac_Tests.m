//
//  _51209_Sqlite3Prac_Tests.m
//  151209_Sqlite3Prac Tests
//
//  Created by shoshino21 on 12/15/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "DBManager.h"
#import "DataModel.h"
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface _51209_Sqlite3Prac_Tests : XCTestCase {
  DBManager *dbm;
  DataModel *dm;
}

@end

@implementation _51209_Sqlite3Prac_Tests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each
  // test method in the class.
  dbm = [[DBManager alloc] initWithDatabaseFilename:@"unittest.sql"];
  dm = [DataModel sharedDataModel];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each
  // test method in the class.
  [super tearDown];
}

- (void)testInsert {
  NSArray *params = @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8" ];
  [dbm
      executeQuery:@"INSERT INTO USER (NUMBER, NAME, GENDER, BIRTH, PHOTO_URL, "
                   @"PHONE, EMAIL, ADDRESS) VALUES (?,?,?,?,?,?,?,?)"
            params:params];

  NSInteger lastInsertID = dbm.lastInsertID;
  NSLog(@"lastInsertID: %lu", (long)lastInsertID);

  NSString *lID = [NSString stringWithFormat:@"%lu", (long)lastInsertID];
  NSArray *resultArr =
      [dbm loadDataFromDB:@"SELECT * FROM USER WHERE ID=?" params:@[ lID ]];

  XCTAssertEqualObjects(resultArr[0][@"NUMBER"], @"1");
  XCTAssertEqualObjects(resultArr[0][@"NAME"], @"2");
  XCTAssertEqualObjects(resultArr[0][@"GENDER"], @"3");
  XCTAssertEqualObjects(resultArr[0][@"BIRTH"], @"4");
  XCTAssertEqualObjects(resultArr[0][@"PHOTO_URL"], @"5");
  XCTAssertEqualObjects(resultArr[0][@"PHONE"], @"6");
  XCTAssertEqualObjects(resultArr[0][@"EMAIL"], @"7");
  XCTAssertEqualObjects(resultArr[0][@"ADDRESS"], @"8");
}

- (void)testUpdate {
  NSArray *params = @[ @"999", @"3" ];
  [dbm executeQuery:@"UPDATE USER SET NUMBER = ? WHERE ID = ?" params:params];

  NSArray *resultArr = [dbm loadDataFromDB:@"SELECT * FROM USER WHERE ID=?"
                                    params:@[ params[1] ]];
  XCTAssertEqualObjects(resultArr[0][@"NUMBER"], @"999");
  XCTAssertEqualObjects(resultArr[0][@"NAME"], @"2");
  XCTAssertEqualObjects(resultArr[0][@"GENDER"], @"3");
  XCTAssertEqualObjects(resultArr[0][@"BIRTH"], @"4");
  XCTAssertEqualObjects(resultArr[0][@"PHOTO_URL"], @"5");
  XCTAssertEqualObjects(resultArr[0][@"PHONE"], @"6");
  XCTAssertEqualObjects(resultArr[0][@"EMAIL"], @"7");
  XCTAssertEqualObjects(resultArr[0][@"ADDRESS"], @"8");
}

//- (void)testSaveToDB {
//  NSDictionary *param = @{
//    @"ID" : @"5",
//    @"NUMBER" : @"123",
//    @"NAME" : @"123",
//    @"GENDER" : @"123",
//    @"BIRTH" : @"123",
//    @"PHOTO_URL" : @"123",
//    @"PHONE" : @"123",
//    @"EMAIL" : @"123",
//    @"ADDRESS" : @"123"
//  };
//
//  NSArray *params = [NSArray arrayWithObject:param];
////  [dbm :params];
//
//  NSArray *resultArr = [dbm loadDataFromDB:@"SELECT * FROM USER WHERE ID=?"
//  params:@[@"5"]];
//  XCTAssertEqualObjects(resultArr[0][@"NUMBER"], @"123");
//  XCTAssertEqualObjects(resultArr[0][@"NAME"], @"123");
//  XCTAssertEqualObjects(resultArr[0][@"GENDER"], @"123");
//  XCTAssertEqualObjects(resultArr[0][@"BIRTH"], @"123");
//  XCTAssertEqualObjects(resultArr[0][@"PHOTO_URL"], @"123");
//  XCTAssertEqualObjects(resultArr[0][@"PHONE"], @"123");
//  XCTAssertEqualObjects(resultArr[0][@"EMAIL"], @"123");
//  XCTAssertEqualObjects(resultArr[0][@"ADDRESS"], @"123");
//}

- (void)testModelAdd {
  NSArray *params = @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8" ];

  [dbm
      executeQuery:@"INSERT INTO USER (NUMBER, NAME, GENDER, BIRTH, PHOTO_URL, "
                   @"PHONE, EMAIL, ADDRESS) VALUES (?,?,?,?,?,?,?,?)"
            params:params];

  if (dbm.lastInsertID == -1) {
    NSLog(@"Insert data failed");
    return;
  }

  NSLog(@"lastInsertID = %ld", (long)dbm.lastInsertID);

  NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
  paramDict[@"ID"] = [NSString stringWithFormat:@"%ld", (long)dbm.lastInsertID];
  paramDict[@"NUMBER"] = params[0];
  paramDict[@"NAME"] = params[1];
  paramDict[@"GENDER"] = params[2];
  paramDict[@"BIRTH"] = params[3];
  paramDict[@"PHOTO_URL"] = params[4];
  paramDict[@"PHONE"] = params[5];
  paramDict[@"EMAIL"] = params[6];
  paramDict[@"ADDRESS"] = params[7];

  NSLog(@"\nparamDict: %@\n", paramDict);

  [dm addDataWithDictionary:paramDict];

  NSDictionary *resultDict = [dm fetchDataWithID:dbm.lastInsertID];

  XCTAssertEqualObjects(resultDict[@"NUMBER"], params[0]);
  XCTAssertEqualObjects(resultDict[@"NAME"], params[1]);
  XCTAssertEqualObjects(resultDict[@"GENDER"], params[2]);
  XCTAssertEqualObjects(resultDict[@"BIRTH"], params[3]);
  XCTAssertEqualObjects(resultDict[@"PHOTO_URL"], params[4]);
  XCTAssertEqualObjects(resultDict[@"PHONE"], params[5]);
  XCTAssertEqualObjects(resultDict[@"EMAIL"], params[6]);
  XCTAssertEqualObjects(resultDict[@"ADDRESS"], params[7]);
}

- (void)testModelUpdate {
  [self testModelAdd];

  NSUInteger idToUpdate = dbm.lastInsertID;
  NSArray *params = @[
    @"999",
    [NSString stringWithFormat:@"%lu", (unsigned long)idToUpdate]
  ];
  [dbm executeQuery:@"UPDATE USER SET NUMBER = ? WHERE ID = ?" params:params];

  NSDictionary *sourceDict = [dm fetchDataWithID:idToUpdate];

  NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
  paramDict[@"ID"] = [NSString stringWithFormat:@"%ld", (long)idToUpdate];
  paramDict[@"NUMBER"] = @"999";
  paramDict[@"NAME"] = sourceDict[@"NAME"];
  paramDict[@"GENDER"] = sourceDict[@"GENDER"];
  paramDict[@"BIRTH"] = sourceDict[@"BIRTH"];
  paramDict[@"PHOTO_URL"] = sourceDict[@"PHOTO_URL"];
  paramDict[@"PHONE"] = sourceDict[@"PHONE"];
  paramDict[@"EMAIL"] = sourceDict[@"EMAIL"];
  paramDict[@"ADDRESS"] = sourceDict[@"ADDRESS"];

  [dm updateDataWithDictionary:paramDict];

  NSDictionary *resultDict = [dm fetchDataWithID:idToUpdate];
  XCTAssertEqualObjects(resultDict[@"NUMBER"], @"999");
}

@end
