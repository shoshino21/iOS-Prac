//
//  SHOFruit.h
//  151201_Snake
//
//  Created by shoshino21 on 12/5/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHOSnakePoint.h"

typedef enum {
  SHOFruitLevel1,
  SHOFruitLevel2,
  SHOFruitLevel3
} SHOFruitLevel;

@interface SHOFruit : NSObject

@property (strong, readonly, nonatomic) SHOSnakePoint *point;
@property (assign, readonly, nonatomic) NSUInteger score;
@property (assign, readonly, nonatomic) NSUInteger lengthToGrow;
@property (strong, readonly, nonatomic) UIColor *color;

- (instancetype)initWithPoint:(SHOSnakePoint *)inPoint level:(SHOFruitLevel)inLevel;

@end
