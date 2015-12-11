//
//  DataModel.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/10/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (instancetype)initWithData:(NSDictionary *)data {
  self = [super init];
  if (self) {
    self.NUMBER = [data[@"NUMBER"] integerValue] ?: 0;
    self.NAME = data[@"NAME"] ?: @"";

    if ([data[@"GENDER"] isEqualToString:@"M"]) {
      self.GENDER = DataModelGenderMale;
    } else if ([data[@"GENDER"] isEqualToString:@"F"]) {
      self.GENDER = DataModelGenderFemale;
    } else {
      self.GENDER = DataModelGenderUnknown;
    }

    self.BIRTH = [data[@"BIRTH"] integerValue] ?: 0;
    self.PHOTO_URL = data[@"PHOTO_URL"] ?: @"";
    self.PHONE = data[@"PHONE"] ?: @"";
    self.EMAIL = data[@"EMAIL"] ?: @"";
  }
  return self;
}

@end
