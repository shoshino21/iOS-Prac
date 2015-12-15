//
//  DataModel.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/10/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

#pragma mark - Initialize (Singleton)

+ (instancetype)sharedDataModel {
  static DataModel *sharedDataModel = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedDataModel = [[self alloc] init];
  });
  return sharedDataModel;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.items = [[NSMutableArray alloc] init];
  }
  return self;
}

#pragma mark - Properties

- (NSUInteger)count {
  return self.items.count;
}

#pragma mark - Methods

- (NSDictionary *)fetchDataWithID:(NSUInteger)anID {
  for (NSUInteger i = 0; i < self.items.count; i++) {
    if ([self.items[i][@"ID"] integerValue] == anID) {
      return self.items[i];
    }
  }
  return nil;
}

- (BOOL)copyDataFromArray:(NSArray *)anArray {
  if ([self.items isEqualToArray:anArray]) {
    return NO;
  }
  self.items = [anArray mutableCopy];
  return YES;
}

- (BOOL)addDataWithDictionary:(NSDictionary *)aDictionary {
  NSUInteger aDictionaryID = [aDictionary[@"ID"] integerValue];

  for (NSDictionary *item in self.items) {
    if ([item[@"ID"] integerValue] == aDictionaryID) {
      NSLog(@"addDataWithDictionary error: duplicate ID.");
      return NO;
    }
  }

  [self.items addObject:aDictionary];
  return YES;
}

- (BOOL)removeDataWithID:(NSUInteger)anID {
  NSInteger indexToRemove = -1;

  for (NSUInteger i = 0; i < self.items.count; i++) {
    if ([self.items[i][@"ID"] integerValue] == anID) {
      indexToRemove = i;
      break;
    }
  }

  if (indexToRemove == -1) {
    NSLog(@"removeDataWithID error: couldn't find ID %lu.", (unsigned long)anID);
    return NO;
  } else {
    [self.items removeObjectAtIndex:indexToRemove];
    return YES;
  }
}

- (BOOL)updateDataWithDictionary:(NSDictionary *)aDictionary {
  NSUInteger aDictionaryID = [aDictionary[@"ID"] integerValue];

  for (NSDictionary *item in self.items) {
    if ([item[@"ID"] integerValue] == aDictionaryID) {
      BOOL removeSuccess = [self removeDataWithID:aDictionaryID];
      BOOL addSuccess = [self addDataWithDictionary:aDictionary];
      return (removeSuccess && addSuccess);
    }
  }

  NSLog(@"updateDataWithDictionary error: couldn't find ID %lu", (unsigned long)aDictionaryID);
  return NO;
}

#warning TODO: sort method

@end
