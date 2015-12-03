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

typedef enum {
  SHOSnakeDirectionUp,
  SHOSnakeDirectionDown,
  SHOSnakeDirectionLeft,
  SHOSnakeDirectionRight,
} SHOSnakeDirection;

@interface SHOSnake : NSObject

@property (strong, readonly, nonatomic) NSArray *points;
@property (assign, readonly, nonatomic) NSUInteger length;

- (instancetype)initWithLength:(NSUInteger)inLength boardSize:(SHOSnakeBoardSize *)inBoardSize;

- (void)move;
- (void)increaseLength:(NSUInteger)inLength;
- (BOOL)toDirection:(SHOSnakeDirection)theDirection;
- (BOOL)isHeadHitBody;
- (BOOL)isHeadHitPoint:(SHOSnakePoint *)aPoint;

@end
