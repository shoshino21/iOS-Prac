//
//  DataModel.h
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/10/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (strong, nonatomic) NSMutableArray *items;

+ (instancetype)sharedDataModel;

- (BOOL)getDataFromArray:(NSArray *)anArray;
- (BOOL)addDataWithDictionary:(NSDictionary *)aDictionary;
- (BOOL)removeDataWithID:(NSUInteger)anID;

@end
