//
//  DataModel.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/10/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "DataModel.h"
#import "pinyin.h"

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

- (void)sortWithKey:(NSString *)key isAscending:(BOOL)ascending {
  if (self.items.count <= 1) {
    return;
  }
  if (![self.items[0] objectForKey:key]) {
    return;
  }

  if ([key isEqualToString:@"NAME"]) {
    // 漢字排序
    unichar aChar;
    unichar pinyinChar;
    NSMutableArray *newDataArr = [NSMutableArray array];

    for (NSUInteger i = 0; i < [self.items count]; i++) {
      NSString *chineseString = [[NSString alloc] init];
      NSMutableDictionary *item = [[self.items objectAtIndex:i] mutableCopy];

      if ([item objectForKey:key]) {
        chineseString = item[key];
        aChar = [chineseString characterAtIndex:0];

        // 判斷首字母是否為英文
        if ((aChar >= 'A' && aChar <= 'Z') || (aChar >= 'a' && aChar <= 'z')) {
          NSString *englishResult = @"";

          char *chars = malloc(chineseString.length * sizeof(char));
          if (![chineseString isEqualToString:@""]) {
            for (NSUInteger j = 0; j < chineseString.length; j++) {
              aChar = [chineseString characterAtIndex:j];

              // 將英文大小寫視為同等，同時避免大寫英文和數字順序混亂
              if (aChar >= 'A' && aChar <= 'Z') {
                aChar += 32;
              }
              // 將英文字元向前位移，使排序時英文排在中文的前面
              chars[j] = aChar - 26;
            }
            englishResult = [[NSString alloc] initWithBytes:chars length:chineseString.length encoding:NSUTF8StringEncoding];
            NSLog(@"aChar:%c, englishResult:%@", aChar, englishResult);
          } else {
            NSLog(@"it's null");
          }
          NSLog(@"englishString:%@, englishResult:%@", chineseString, englishResult);
          [item setObject:englishResult forKey:@"sortcolumn"];
        }
        // 判斷首字母是否為漢字
        else if (isFirstLetterHANZI(aChar)) {
          NSString *pinYinResult = @"";

          char *chars = malloc(chineseString.length * sizeof(char));
          if (![chineseString isEqualToString:@""]) {
            for (NSUInteger j = 0; j < chineseString.length; j++) {
              aChar = [chineseString characterAtIndex:j];
              pinyinChar = pinyinFirstLetter(aChar);
              chars[j] = pinyinChar;
            }
            pinYinResult = [[NSString alloc] initWithBytes:chars length:chineseString.length encoding:NSUTF8StringEncoding];
            NSLog(@"aChar:%c, pinYinResult:%@", aChar, pinYinResult);
          } else {
            NSLog(@"it's null");
          }
          NSLog(@"chineseString:%@, pinYinResult:%@", chineseString, pinYinResult);
          [item setObject:pinYinResult forKey:@"sortcolumn"];
        }
        // 非字母或漢字
        else {
          [item setObject:chineseString forKey:@"sortcolumn"];
        }

        [newDataArr addObject:item];
      }
    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sortcolumn" ascending:ascending];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [newDataArr sortedArrayUsingDescriptors:sortDescriptors];

    self.items = [sortedArray mutableCopy];
  }

  else if ([key isEqualToString:@"BIRTH"]) {
    NSMutableArray *arrayForSort = [[NSMutableArray alloc] init];

    // Transfer to integer for sorting
    for (NSDictionary *item in self.items) {
      NSMutableDictionary *itemForSort = [item mutableCopy];
      itemForSort[@"BIRTH"] = [NSNumber numberWithInteger:[itemForSort[@"BIRTH"] integerValue]];
      [arrayForSort addObject:itemForSort];
    }

    NSSortDescriptor *sortDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"BIRTH" ascending:ascending selector:@selector(compare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSMutableArray *sortedArray = [[arrayForSort sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];

    for (NSMutableDictionary *item in sortedArray) {
      item[@"BIRTH"] = [NSString stringWithFormat:@"%@", item[@"BIRTH"]];
    }

    self.items = [sortedArray mutableCopy];
  }
}

@end
