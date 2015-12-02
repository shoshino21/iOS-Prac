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

#pragma mark - Initialize

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

#pragma mark - Properties

- (NSUInteger)length {
  return [_points count];
}

#pragma mark - Methods

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
  SHOSnakePoint *last1Point = [_points objectAtIndex:self.length - 1];
  NSUInteger x1 = last1Point.x;
  NSUInteger y1 = last1Point.y;
  SHOSnakePoint *last2Point = [_points objectAtIndex:self.length - 2];
  NSUInteger x2 = last2Point.x;
  NSUInteger y2 = last2Point.y;

  if (x1 == x2 && y1 < y2) {
    // append to up
    for (int i = 1; i <= inLength; i++) {
      [_points addObject:[SHOSnakePoint snakePointWithX:x1 Y:y1 - i]];
    }
    return;
  }
  if (x1 == x2 && y1 > y2) {
    // append to down
    for (int i = 1; i <= inLength; i++) {
      [_points addObject:[SHOSnakePoint snakePointWithX:x1 Y:y1 + i]];
    }
    return;
  }
  if (x1 < x2 && y1 == y2) {
    // append to left
    for (int i = 1; i <= inLength; i++) {
      [_points addObject:[SHOSnakePoint snakePointWithX:x1 - i Y:y1]];
    }
    return;
  }
  if (x1 > x2 && y1 == y2) {
    // append to right
    for (int i = 1; i <= inLength; i++) {
      [_points addObject:[SHOSnakePoint snakePointWithX:x1 + i Y:y1]];
    }
    return;
  }
}

- (void)toDirection:(SHOSnakeDirection)theDirection {
  if (_currDirection == SHOSnakeDirectionUp || _currDirection == SHOSnakeDirectionDown) {
    
  }
}

- (BOOL)isHeadHitBody {
  return NO;
}

@end
