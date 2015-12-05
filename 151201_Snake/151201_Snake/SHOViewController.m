//
//  SHOViewController.m
//  151201_Snake
//
//  Created by shoshino21 on 12/1/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SHOViewController.h"
#import "SHOSnakeView.h"

@interface SHOViewController () <SHOSnakeViewDelegate>

@property(strong, nonatomic) SHOSnake *snake;
@property(strong, nonatomic) SHOSnakePoint *fruitPoint;
@property(strong, nonatomic) SHOSnakeView *snakeView;
@property(strong, nonatomic) NSTimer *timer;

@end

@implementation SHOViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

#pragma mark - SHOSnakeViewDelegate

- (SHOSnake *)snakeForView:(SHOSnakeView *)inView {
  return self.snake;
}

- (SHOSnakePoint *)fruitPointForView:(SHOSnakeView *)inView {
  return self.fruitPoint;
}

@end
