//
//  SHOViewController.m
//  151201_Snake
//
//  Created by shoshino21 on 12/1/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define TOPBAR_H 40
#define BUTTON_W 150
#define BUTTON_H 50

#define BOARD_W 30
#define BOARD_H 15

#define FRUIT_PERCENTAGE_LV1 0.5
#define FRUIT_PERCENTAGE_LV2 0.3
#define FRUIT_PERCENTAGE_LV3 0.2

#import "SHOViewController.h"
#import "SHOSnakeView.h"

@interface SHOViewController () <SHOSnakeViewDelegate> {
  NSUInteger _score;
  float _playedTime;
}

@property (strong, nonatomic) SHOSnake *snake;
@property (strong, nonatomic) SHOFruit *fruit;
@property (strong, nonatomic) NSTimer *snakeTimer;

@property (strong, nonatomic) UIView *topBarView;
@property (strong, nonatomic) SHOSnakeView *snakeView;
@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UILabel *timerLabel;

@end

@implementation SHOViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, TOPBAR_H)];
  self.topBarView.backgroundColor = [UIColor darkGrayColor];
  [self.view addSubview:self.topBarView];

  self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 80, 30)];
  self.scoreLabel.text = @"0";
  self.scoreLabel.textColor = [UIColor whiteColor];
  self.scoreLabel.backgroundColor = [UIColor clearColor];
  self.scoreLabel.font = [UIFont systemFontOfSize:24.f];
  [self.topBarView addSubview:self.scoreLabel];

  self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W - 80, 5, 80, 30)];
  self.timerLabel.text = @"0.0";
  self.timerLabel.textColor = [UIColor whiteColor];
  self.timerLabel.backgroundColor = [UIColor clearColor];
  self.timerLabel.font = [UIFont systemFontOfSize:24.f];
  [self.topBarView addSubview:self.timerLabel];

  self.snakeView = [[SHOSnakeView alloc] initWithFrame:CGRectMake(0, TOPBAR_H, SCREEN_W, SCREEN_H - TOPBAR_H)];
  self.snakeView.backgroundColor = [UIColor whiteColor];
  self.snakeView.delegate = self;
  [self.view addSubview:self.snakeView];

  self.startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  self.startButton.frame = CGRectMake( (SCREEN_W - BUTTON_W) / 2, (SCREEN_H - TOPBAR_H - BUTTON_H) / 2, BUTTON_W, BUTTON_H );
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
  if (self.snakeTimer) { return; }

  _playedTime = 0.f;
  self.timerLabel.text = [NSString stringWithFormat:@"%.1f", _playedTime];
  _score = 0;
  self.scoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_score];

  SHOSnakeBoardSize *boardSize = [[SHOSnakeBoardSize alloc] initWithWidth:BOARD_W height:BOARD_H];
  self.snake = [[SHOSnake alloc] initWithLength:2 boardSize:boardSize];
  [self addNewFruit];
  self.startButton.hidden = YES;

  self.snakeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
}

- (void)gameOver {
  [self.startButton setTitle:@"Play again" forState:UIControlStateNormal];
  self.startButton.hidden = NO;

  [self.snakeTimer invalidate];
  self.snakeTimer = nil;
}

- (void)addNewFruit {
  float ran = arc4random() % 100 / 100.f; // 0.00 ~ 0.99
  SHOFruitLevel newLevel;

  if (ran < FRUIT_PERCENTAGE_LV1) {
    newLevel = SHOFruitLevel1;
  } else if (ran < FRUIT_PERCENTAGE_LV1 + FRUIT_PERCENTAGE_LV2) {
    newLevel = SHOFruitLevel2;
  } else {
    newLevel = SHOFruitLevel3;
  }

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
      SHOSnakePoint *newPoint = [SHOSnakePoint snakePointWithX:newFruitX Y:newFruitY];
      self.fruit = [[SHOFruit alloc] initWithPoint:newPoint level:newLevel];
      break;
    }
  }
}

- (void)timerMethod:(NSTimer *)inTimer {
  _playedTime += 0.1f;
  self.timerLabel.text = [NSString stringWithFormat:@"%.1f", _playedTime];

  [self.snake move];
  if (self.snake.isHeadHitBody) {
    [self gameOver];
  }

  SHOSnakePoint *headPoint = [self.snake.points firstObject];
  if (headPoint.x == self.fruit.point.x && headPoint.y == self.fruit.point.y) {
    [self.snake increaseLength:self.fruit.lengthToGrow];
    _score += self.fruit.score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_score];
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

- (SHOFruit *)fruitforView:(SHOSnakeView *)inView {
  return self.fruit;
}

@end
