//
//  BoardView.m
//  WordBoard
//
//  Created by shoshino21 on 12/30/15.
//  Copyright © 2015 shoshino21. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView

- (void)drawRect:(CGRect)rect {
  // Draw line
  CGContextRef c = UIGraphicsGetCurrentContext();
  CGFloat cellW = self.bounds.size.width / kLengthByCell;
  CGFloat cellH = self.bounds.size.height / kLengthByCell;

  for (int i = 1; i < kLengthByCell; i++) {
    CGContextMoveToPoint(c, i * cellW, 0);
    CGContextAddLineToPoint(c, i * cellW, self.bounds.size.height);
    CGContextMoveToPoint(c, 0, i * cellH);
    CGContextAddLineToPoint(c, self.bounds.size.width, i * cellH);
  }

  CGContextStrokePath(c);

  // Draw text
  NSArray *stringArray = [self.delegate stringArrayForView:self];

  UIFont *font = [UIFont boldSystemFontOfSize:24.f];
  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  UIColor *fontColor = [UIColor grayColor];

  NSMutableString *currStr = [[NSMutableString alloc] init];
  NSMutableString *currChar = [[NSMutableString alloc] init];

  for (int i = 0; i < kLengthByCell; i++) {
    [currStr setString:stringArray[i]];

    for (int j = 0; j < kLengthByCell; j++) {
      [currChar setString:[currStr substringWithRange:NSMakeRange(j, 1)]];
      [currChar drawInRect:CGRectMake(cellW * j, cellH * (i + 0.3), cellW, cellH)
            withAttributes:@{
              NSFontAttributeName : font,
              NSParagraphStyleAttributeName : paragraphStyle,
              NSForegroundColorAttributeName : fontColor
            }];
    }
  }
}

@end
