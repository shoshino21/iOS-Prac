//
//  ViewController.m
//  WordBoard
//
//  Created by shoshino21 on 12/30/15.
//  Copyright © 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"

#import "BoardModel.h"
#import "BoardView.h"

@interface ViewController () <BoardViewDelegate, UITextFieldDelegate> {
  NSInteger _currCellIndexX;
  NSInteger _currCellIndexY;
}

@property(strong, nonatomic) BoardView *boardView;
@property(strong, nonatomic) BoardModel *boardModel;
@property(strong, nonatomic) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  NSString *rowString = @"一二三四五六七八";
  NSMutableArray *stringArray = [[NSMutableArray alloc] init];
  for (int i = 0; i < kLengthByCell; i++) {
    [stringArray addObject:rowString];
  }
  self.boardModel = [[BoardModel alloc] initWithArray:stringArray];

  CGRect screenRect = [UIScreen mainScreen].bounds;
  self.boardView = [[BoardView alloc] initWithFrame:screenRect];
  self.boardView.delegate = self;
  self.boardView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.boardView];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
  [self.view addGestureRecognizer:tap];

  [self addKeyboardNotification];

  self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
  self.textField.delegate = self;
  self.textField.hidden = YES;
  self.textField.backgroundColor = [UIColor blackColor];
  self.textField.textColor = [UIColor whiteColor];
  self.textField.textAlignment = NSTextAlignmentCenter;
  self.textField.font = [UIFont boldSystemFontOfSize:24.f];
  [self.view addSubview:self.textField];
}

- (void)dealloc {
  [self removeKeyboardNotification];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

#pragma mark - Gesture

- (void)singleTap:(UITapGestureRecognizer *)tapRecognizer {
  CGPoint touchPoint = [tapRecognizer locationInView:self.view];
  CGFloat cellW = [UIScreen mainScreen].bounds.size.width / kLengthByCell;
  CGFloat cellH = [UIScreen mainScreen].bounds.size.height / kLengthByCell;
  _currCellIndexX = touchPoint.x / cellW;
  _currCellIndexY = touchPoint.y / cellH;

  self.textField.frame = CGRectMake(_currCellIndexX * cellW, _currCellIndexY * cellH, cellW, cellH);
  self.textField.hidden = NO;
  self.textField.text = [self.boardModel stringFromIndexX:_currCellIndexX indexY:_currCellIndexY];
  [self.textField becomeFirstResponder]; // Show the keyboard immediately
}

#pragma mark - Keyboard

- (void)addKeyboardNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillChangeFrameNotification
                                             object:nil];
}

- (void)removeKeyboardNotification {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
  if (_currCellIndexY <= 3) return;

  NSDictionary *userInfo = [notification userInfo];
  NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
  CGRect keyboardRect = [aValue CGRectValue];
  NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSTimeInterval animationDuration;
  [animationDurationValue getValue:&animationDuration];

  [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  if (_currCellIndexY <= 3) return;

  NSDictionary *userInfo = [notification userInfo];
  NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSTimeInterval animationDuration;
  [animationDurationValue getValue:&animationDuration];

  [self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
}

- (void)moveInputBarWithKeyboardHeight:(float)_CGRectHeight withDuration:(NSTimeInterval)_NSTimeInterval {
  CGRect rect = self.view.frame;
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:_NSTimeInterval];
  rect.origin.y = -_CGRectHeight;
  self.view.frame = rect;

  [UIView commitAnimations];
}

#pragma mark - Delegate (BoardViewDelegate)

- (NSArray *)stringArrayForView:(BoardView *)inView {
  return [self.boardModel stringArray];
}

#pragma mark - Delegate (UITextFieldDelegate)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  // Hide the keyboard when return key is pressed
  [textField resignFirstResponder];

  if (textField.text.length == 1) {
    [self.boardModel setString:textField.text ToIndexX:_currCellIndexX indexY:_currCellIndexY];
    [self.boardView setNeedsDisplay];
  } else {
    textField.text = [self.boardModel stringFromIndexX:_currCellIndexX indexY:_currCellIndexY];
  }

  return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  // Limit maximum input length to 1
  return (range.location < 1);
}

@end
