//
//  SHOFruit.m
//  151201_Snake
//
//  Created by shoshino21 on 12/5/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SHOFruit.h"

@interface SHOFruit ()

@property (strong, readwrite, nonatomic) SHOSnakePoint *point;
@property (assign, nonatomic) SHOFruitLevel level;

@end

@implementation SHOFruit

- (instancetype)initWithPoint:(SHOSnakePoint *)inPoint level:(SHOFruitLevel)inLevel {
  self = [super init];
  if (self) {
    _point = inPoint;
    _level = inLevel;
  }
  return self;
}

- (NSUInteger)score {
  NSArray *scores = @[ @100, @200, @500 ];
  return [scores[_level] integerValue];
}

- (NSUInteger)lengthToGrow {
  NSArray *lengths = @[ @2, @2, @5 ];
  return [lengths[_level] integerValue];
}

- (UIColor *)color {
  NSArray *colors = @[ [UIColor redColor], [UIColor yellowColor], [UIColor greenColor] ];
  return colors[_level];
}

@end
