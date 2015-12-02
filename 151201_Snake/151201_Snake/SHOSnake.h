//
//  SHOSnake.h
//  151201_Snake
//
//  Created by shoshino21 on 12/1/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHOSnakePoint.h"
#import "SHOSnakeBoardSize.h"

//
//typedef struct {
//  NSUInteger x;
//  NSUInteger y;
//} SHOSnakePoint;
//
//SHOSnakePoint SHOSnakePointMake(NSUInteger x, NSUInteger y);
//
//typedef struct {
//  NSUInteger width;
//  NSUInteger height;
//} SHOSnakeBoardSize;
//
//SHOSnakeBoardSize SHOSnakeBoardSizeMake(NSUInteger width, NSUInteger height);

typedef enum {
  SHOSnakeDirectionUp,
  SHOSnakeDirectionDown,
  SHOSnakeDirectionLeft,
  SHOSnakeDirectionRight,
} SHOSnakeDirection;

@interface SHOSnake : NSObject

@end
