//
//  DataModel.h
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/10/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

typedef enum {
  DataModelGenderMale,
  DataModelGenderFemale,
  DataModelGenderUnknown
} DataModelGender;

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (assign, nonatomic) NSUInteger NUMBER;
@property (strong, nonatomic) NSString *NAME;
@property (assign, nonatomic) DataModelGender GENDER;
@property (assign, nonatomic) NSUInteger BIRTH;
@property (strong, nonatomic) NSString *PHOTO_URL;
@property (strong, nonatomic) NSString *PHONE;
@property (strong, nonatomic) NSString *EMAIL;

- (instancetype)initWithData:(NSDictionary *)data;

@end
