//
//  SHOSnake.m
//  151201_Snake
//
//  Created by shoshino21 on 12/1/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SHOSnake.h"

@interface SHOSnake () {
  NSMutableArray *_points;
  SHOSnakeBoardSize *_boardSize;
  SHOSnakeDirection _currDirection;
}

@end

@implementation SHOSnake

- (instancetype)initWithLength:(NSUInteger)inLength boardSize:(SHOSnakeBoardSize *)inBoardSize {
  self = [super init];
  if (self) {
    _points = [[NSMutableArray alloc] init];
    _boardSize = inBoardSize;
    _currDirection = SHOSnakeDirectionLeft;

    NSUInteger centerX = (NSUInteger)inBoardSize.width / 2;
    NSUInteger centerY = (NSUInteger)inBoardSize.height / 2;

    for (int i = 0; i < inLength; i++) {
      [_points[i] addObject:[SHOSnakePoint snakePointWithX:centerX + i Y:centerY]];
    }
  }
  return self;
}

- (void)move {
  [_points removeLastObject];

  SHOSnakePoint *headPoint = [_points firstObject];
  NSUInteger x = headPoint.x;
  NSUInteger y = headPoint.y;

  switch (_currDirection) {
    case SHOSnakeDirectionUp:
      if (--y == 0) y = _boardSize.height;
      break;

    case SHOSnakeDirectionDown:
      if (++y > _boardSize.height) y = 1;
      break;

    case SHOSnakeDirectionLeft:
      if (--x == 0) x = _boardSize.width;
      break;

    case SHOSnakeDirectionRight:
      if (++x > _boardSize.width) x = 1;
      break;

    default:
      break;
  }

  [_points insertObject:[SHOSnakePoint snakePointWithX:x Y:y] atIndex:0];
}

- (void)increaseLength:(NSUInteger)inLength {

}

- (void)toDirection:(SHOSnakeDirection)theDirection {

}

- (BOOL)isHeadHitBody {
  return NO;
}

@end
