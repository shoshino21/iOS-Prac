//
//  SHOSnakeView.h
//  151201_Snake
//
//  Created by shoshino21 on 12/1/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHOSnake.h"

@class SHOSnakeView;

@protocol SHOSnakeViewDelegate <NSObject>

- (SHOSnake *)snakeForView:(SHOSnakeView *)inView;
- (SHOSnakePoint *)fruitPointForView:(SHOSnakeView *)inView;

@end

@interface SHOSnakeView : UIView

@property(weak, nonatomic) id<SHOSnakeViewDelegate> delegate;

@end
