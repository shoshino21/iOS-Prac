//
//  ViewController.m
//  WordBoard
//
//  Created by shoshino21 on 12/30/15.
//  Copyright © 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"

#import "BoardView.h"

@interface ViewController () <BoardViewDelegate>

@property(strong, nonatomic) BoardView *boardView;
@property(strong, nonatomic) NSMutableArray *boardChars;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.boardChars = [[NSMutableArray alloc] init];
  NSString *rowString = @"一二三四五六七八";
  for (int i = 0; i < kLengthByCell; i++) {
    [self.boardChars addObject:rowString];
  }

  CGRect screenRect = [UIScreen mainScreen].bounds;
  self.boardView = [[BoardView alloc] initWithFrame:screenRect];
  self.boardView.delegate = self;
  self.boardView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.boardView];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
  [self.view addGestureRecognizer:tap];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

#pragma mark - Gesture

- (void)singleTap:(UITapGestureRecognizer *)tapRecognizer {
  CGPoint touchPoint = [tapRecognizer locationInView:self.view];
//  NSLog(@"%f,%f", touchPoint.x, touchPoint.y);
  CGFloat cellW = [UIScreen mainScreen].bounds.size.width / kLengthByCell;
  CGFloat cellH = [UIScreen mainScreen].bounds.size.height / kLengthByCell;
  NSInteger cellIndexX = touchPoint.x / cellW;
  NSInteger cellIndexY = touchPoint.y / cellH;
//    NSLog(@"%d,%d", cellIndexX, cellIndexY);
}

#pragma mark - Delegate (BoardViewDelegate)

- (NSArray *)stringArrayForView:(BoardView *)inView {
  return self.boardChars;
}

@end
