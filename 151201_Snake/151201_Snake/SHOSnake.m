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

    NSUInteger centerX = (NSUInteger)inBoardSize.width / 2 + 1;
    NSUInteger centerY = (NSUInteger)inBoardSize.height / 2 + 1;

    for (int i = 0; i < inLength; i++) {
      [_points addObject:[SHOSnakePoint snakePointWithX:centerX + i Y:centerY]];
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
  NSUInteger l1x = last1Point.x;
  NSUInteger l1y = last1Point.y;
  SHOSnakePoint *last2Point = [_points objectAtIndex:self.length - 2];
  NSUInteger l2x = last2Point.x;
  NSUInteger l2y = last2Point.y;

  NSUInteger newX, newY;
  NSUInteger throughBoundCount = 0;

  if (l1x == l2x && l1y < l2y) {
    // append to up
    for (int i = 1; i <= inLength; i++) {
      if (l1y - i > 0) {
        newY = l1y - i;
      } else {
        ++throughBoundCount;
        newY = _boardSize.height - throughBoundCount + 1;
      }
      [_points addObject:[SHOSnakePoint snakePointWithX:l1x Y:newY]];
    }
    return;
  }

  if (l1x == l2x && l1y > l2y) {
    // append to down
    for (int i = 1; i <= inLength; i++) {
      if (l1y + i <= _boardSize.height) {
        newY = l1y + i;
      } else {
        newY = ++throughBoundCount;
      }
      [_points addObject:[SHOSnakePoint snakePointWithX:l1x Y:newY]];
    }
    return;
  }

  if (l1x < l2x && l1y == l2y) {
    // append to left
    for (int i = 1; i <= inLength; i++) {
      if (l1x - i > 0) {
        newX = l1x - i;
      } else {
        ++throughBoundCount;
        newX = _boardSize.width - throughBoundCount + 1;
      }
      [_points addObject:[SHOSnakePoint snakePointWithX:newX Y:l1y]];
    }
    return;
  }

  if (l1x > l2x && l1y == l2y) {
    // append to right
    for (int i = 1; i <= inLength; i++) {
      if (l1x + i <= _boardSize.width) {
        newX = l1x + i;
      } else {
        newX = ++throughBoundCount;
      }
      [_points addObject:[SHOSnakePoint snakePointWithX:newX Y:l1y]];
    }
    return;
  }
}

- (BOOL)toDirection:(SHOSnakeDirection)theDirection {
  if (_currDirection == SHOSnakeDirectionUp || _currDirection == SHOSnakeDirectionDown) {
    if (theDirection == SHOSnakeDirectionLeft || theDirection == SHOSnakeDirectionRight) {
      _currDirection = theDirection;
      return YES;
    }
  }
  if (_currDirection == SHOSnakeDirectionLeft || _currDirection == SHOSnakeDirectionRight) {
    if (theDirection == SHOSnakeDirectionUp || theDirection == SHOSnakeDirectionDown) {
      _currDirection = theDirection;
      return YES;
    }
  }
  return NO;
}

- (BOOL)isHeadHitBody {
  SHOSnakePoint *headPoint = [_points firstObject];
  SHOSnakePoint *bodyPoint;

  // The first four blocks never be hit by head.
  for (int i = 4; i < self.length; i++) {
    bodyPoint = _points[i];
    if (bodyPoint.x == headPoint.x && bodyPoint.y == headPoint.y) {
      return YES;
    }
  }
  return NO;
}

- (BOOL)isHeadHitPoint:(SHOSnakePoint *)aPoint {
  SHOSnakePoint *headPoint = [_points firstObject];
  return (headPoint.x == aPoint.x && headPoint.y == aPoint.y);
}

@end
