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

@property (strong, nonatomic) SHOSnake *snake;
@property (strong, nonatomic) SHOSnakePoint *fruitPoint;
@property (strong, nonatomic) SHOSnakeView *snakeView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIButton *startButton;

@end

@implementation SHOViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.snakeView = [[SHOSnakeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.snakeView.delegate = self;
  self.snakeView.backgroundColor = [UIColor whiteColor];
  self.view = self.snakeView;

  CGSize screenSize = [UIScreen mainScreen].bounds.size;
  self.startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.startButton.frame = CGRectMake( (screenSize.width - 150) / 2, (screenSize.height - 50) / 2, 150, 50 );
  self.startButton.backgroundColor = [UIColor greenColor];
  self.startButton.tintColor = [UIColor blackColor];
  self.startButton.layer.cornerRadius = 8.f;

  [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
  [self.startButton addTarget:self action:@selector(gameStart) forControlEvents:UIControlEventTouchUpInside];
  [self.snakeView addSubview:self.startButton];

  [self addGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionUp];
  [self addGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionDown];
  [self addGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionLeft];
  [self addGestureRecognizerWithDirection:UISwipeGestureRecognizerDirectionRight];
}

- (void)gameStart {
  if (self.timer) return;

  self.startButton.hidden = YES;
  SHOSnakeBoardSize *boardSize = [[SHOSnakeBoardSize alloc] initWithWidth:24 height:16];
  self.snake = [[SHOSnake alloc] initWithLength:2 boardSize:boardSize];
  [self addNewFruit];
  self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
}

- (void)gameOver {
}

- (void)addNewFruit {
  NSUInteger newFruitX;
  NSUInteger newFruitY;
  BOOL isConflict = NO;

  while (1) {
    newFruitX = (arc4random() % self.snake.boardSize.width) + 1;
    newFruitY = (arc4random() % self.snake.boardSize.height) + 1;
    isConflict = NO;

    for (SHOSnakePoint *point in self.snake.points) {
      if (point.x == newFruitX && point.y == newFruitY) {
        isConflict = YES;
        break;
      }
    }

    if (!isConflict) {
      self.fruitPoint = [SHOSnakePoint snakePointWithX:newFruitX Y:newFruitY];
      break;
    }
  }
}

- (void)timerMethod:(NSTimer *)inTimer {
  [self.snake move];
  if (self.snake.isHeadHitBody) {
#warning temp
    NSLog(@"gameOver");
    [self gameOver];
  }

  SHOSnakePoint *headPoint = [self.snake.points firstObject];
  if (headPoint.x == self.fruitPoint.x && headPoint.y == self.fruitPoint.y) {
#warning temp
    NSLog(@"getFruit");
    [self.snake increaseLength:2];
    [self addNewFruit];
  }

  [self.snakeView setNeedsDisplay];
}

#pragma mark - Swipe

- (void)addGestureRecognizerWithDirection:(UISwipeGestureRecognizerDirection)direction {
  UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
  sgr.direction = direction;
  [self.snakeView addGestureRecognizer:sgr];
}

- (void)swipe:(UISwipeGestureRecognizer *)sgr {
  SHOSnakeDirection toDirection;
  switch (sgr.direction) {
    case UISwipeGestureRecognizerDirectionUp:
      toDirection = SHOSnakeDirectionUp;
      break;
    case UISwipeGestureRecognizerDirectionDown:
      toDirection = SHOSnakeDirectionDown;
      break;
    case UISwipeGestureRecognizerDirectionLeft:
      toDirection = SHOSnakeDirectionLeft;
      break;
    case UISwipeGestureRecognizerDirectionRight:
      toDirection = SHOSnakeDirectionRight;
      break;
    default:
      return;
  }
  [self.snake toDirection:toDirection];
}

#pragma mark - SHOSnakeViewDelegate

- (SHOSnake *)snakeForView:(SHOSnakeView *)inView {
  return self.snake;
}

- (SHOSnakePoint *)fruitPointForView:(SHOSnakeView *)inView {
  return self.fruitPoint;
}

@end
