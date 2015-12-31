//
//  ViewController.m
//  WordBoard
//
//  Created by shoshino21 on 12/30/15.
//  Copyright © 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"

#import "BoardView.h"

@interface ViewController () <BoardViewDelegate, UITextFieldDelegate>

@property(strong, nonatomic) BoardView *boardView;
@property(strong, nonatomic) NSMutableArray *boardChars;
@property(strong, nonatomic) UITextField *textField;

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

  self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
  self.textField.delegate = self;
  self.textField.hidden = YES;
  self.textField.backgroundColor = [UIColor blackColor];
  self.textField.textColor = [UIColor whiteColor];
  self.textField.textAlignment = NSTextAlignmentCenter;
  self.textField.font = [UIFont boldSystemFontOfSize:24.f];
  [self.view addSubview:self.textField];
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

  self.textField.frame = CGRectMake(cellIndexX * cellW, cellIndexY * cellH, cellW, cellH);
  self.textField.hidden = NO;
  self.textField.text = [self.boardChars[cellIndexY] substringWithRange:NSMakeRange(cellIndexX, 1)];
  [self.textField becomeFirstResponder];  // Show the keyboard immediately
}

#pragma mark - Delegate (BoardViewDelegate)

- (NSArray *)stringArrayForView:(BoardView *)inView {
  return self.boardChars;
}

#pragma mark - Delegate (UITextFieldDelegate)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  // Hide the keyboard when return key is pressed
  [textField resignFirstResponder];
  return YES;
}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//  // Limit minimum input length
//  return (self.textField.text.length > 0);
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  // Limit maximum input length
  if (range.location >= 1) {
    return NO;
  }
  return YES;
}

#pragma mark - Private

- (void)p_

@end
