//
//  SHOSnakeView.m
//  151201_Snake
//
//  Created by shoshino21 on 12/1/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SHOSnakeView.h"

@implementation SHOSnakeView

- (void)drawRect:(CGRect)rect {
  SHOSnake *snake = [self.delegate snakeForView:self];
  SHOSnakeBoardSize *boardSize = snake.boardSize;

  CGFloat cellW = self.bounds.size.width / boardSize.width;
  CGFloat cellH = self.bounds.size.height / boardSize.height;
	CGContextRef currContext = UIGraphicsGetCurrentContext();

  if (snake) {
    [[UIColor blackColor] set];

    for (SHOSnakePoint *point in snake.points) {
      CGRect rect = CGRectMake((point.x - 1) * cellW, (point.y - 1) * cellH, cellW, cellH);
      CGContextFillRect(currContext, rect);
    }
  }

  SHOSnakePoint *fruitPoint = [self.delegate fruitPointForView:self];

  if (fruitPoint) {
    [[UIColor redColor] set];
    CGRect rect = CGRectMake((fruitPoint.x - 1) * cellW, (fruitPoint.y - 1) * cellH, cellW, cellH);
    CGContextFillEllipseInRect(currContext, rect);
  }
}

@end
