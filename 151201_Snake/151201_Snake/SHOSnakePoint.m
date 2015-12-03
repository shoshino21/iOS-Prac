//
//  SHOSnakePoint.m
//  151201_Snake
//
//  Created by shoshino21 on 12/3/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SHOSnakePoint.h"

@implementation SHOSnakePoint

- (instancetype)initWithX:(NSUInteger)x Y:(NSUInteger)y {
  self = [super init];
  if (self) {
    _x = x;
    _y = y;
  }
  return self;
}

+ (SHOSnakePoint *)snakePointWithX:(NSUInteger)x Y:(NSUInteger)y {
  return [[SHOSnakePoint alloc] initWithX:x Y:y];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"X:%lu Y:%lu", (unsigned long)_x, (unsigned long)_y];
}

@end
