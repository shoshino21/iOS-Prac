//
//  SHOSnakeBoardSize.m
//  151201_Snake
//
//  Created by shoshino21 on 12/3/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SHOSnakeBoardSize.h"

@implementation SHOSnakeBoardSize

- (instancetype)initWithWidth:(NSUInteger)inWidth height:(NSUInteger)inHeight {
  self = [super init];
  if (self) {
    _width = inWidth;
    _height = inHeight;
  }
  return self;
}

- (instancetype)init {
  return [self initWithWidth:9 height:9];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"W:%lu H:%lu", (unsigned long)_width, (unsigned long)_height];
}

@end
