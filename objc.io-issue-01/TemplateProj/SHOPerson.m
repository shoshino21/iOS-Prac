//
//  Person.m
//  TemplateProj
//
//  Created by shoshino21 on 12/26/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#import "SHOPerson.h"

@implementation SHOPerson

- (instancetype)initWithName:(NSString *)nameStr
                   avatarURL:(NSURL *)avatarURL
                      gender:(SHOPersonGender)gender
                   birthDate:(NSDate *)birthDate {
  self = [super init];
  if (self) {
    _nameStr = nameStr;
    _avatarURL = avatarURL;
    _gender = gender;
    _birthDate = birthDate;
  }
  return self;
}

- (instancetype)initWithName:(NSString *)nameStr {
  return [self initWithName:nameStr
                  avatarURL:nil
                     gender:SHOPersonGenderUnknown
                  birthDate:nil];
}

@end
