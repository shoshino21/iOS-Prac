//
//  Person.h
//  TemplateProj
//
//  Created by shoshino21 on 12/26/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

typedef NS_ENUM(NSUInteger, SHOPersonGender) {
  SHOPersonGenderUnknown,
  SHOPersonGenderMale,
  SHOPersonGenderFemale,
};

@interface SHOPerson : NSObject

@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, assign) SHOPersonGender gender;
@property (nonatomic, strong) NSDate *birthDate;

- (instancetype)initWithName:(NSString *)nameStr
                   avatarURL:(NSURL *)avatarURL
                      gender:(SHOPersonGender)gender
                   birthDate:(NSDate *)birthDate NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithName:(NSString *)nameStr;

- (instancetype)init __attribute__((unavailable("Must use initWithName: instead.")));

@end
