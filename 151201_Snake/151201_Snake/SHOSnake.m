//
//  SHOSnake.m
//  151201_Snake
//
//  Created by shoshino21 on 12/1/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SHOSnake.h"

@implementation SHOSnake
//
//SHOSnakePoint SHOSnakePointMake(NSUInteger x, NSUInteger y) {
//  SHOSnakePoint sp;
//  sp.x = x;
//  sp.y = y;
//  return sp;
//}
//

SHOSnakeBoardSize SHOSnakeBoardSizeMake(NSUInteger width, NSUInteger height) {
  SHOSnakePoint *sp = [SHOSnakePoint snakePointWithX:2 Y:3];

  SHOSnakeBoardSize sbs;
  sbs.width = width;
  sbs.height = height;
  return sbs;
}



@end
