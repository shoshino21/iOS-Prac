//
//  ViewController.m
//  151117_KKBOX_Prac1_SimpleCalculator
//
//  Created by shoshino21 on 11/17/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableString *resultText;
@property (strong, nonatomic) NSDecimalNumber *leftDecNumber;
@property (strong, nonatomic) NSDecimalNumber *rightDecNumber;

@end

@implementation ViewController {
  SEL _savedSelector;
  BOOL _hasDot;
  BOOL _shouldClearInput;
  BOOL _isJustInputOperator;
  BOOL _isLastOperatorEql;
}

#pragma mark - View

- (void)viewDidLoad {
  [super viewDidLoad];

  self.resultText = [NSMutableString stringWithString:@"0"];
  self.resultLabel.text = self.resultText;
  self.leftDecNumber = nil;
  self.rightDecNumber = nil;

  _savedSelector = nil;
  _hasDot = NO;
  _shouldClearInput = NO;
  _isJustInputOperator = NO;
  _isLastOperatorEql = NO;

  self.clearButton.tag = SCButtonClear;
  self.num0Button.tag = SCButton0;
  self.num1Button.tag = SCButton1;
  self.num2Button.tag = SCButton2;
  self.num3Button.tag = SCButton3;
  self.num4Button.tag = SCButton4;
  self.num5Button.tag = SCButton5;
  self.num6Button.tag = SCButton6;
  self.num7Button.tag = SCButton7;
  self.num8Button.tag = SCButton8;
  self.num9Button.tag = SCButton9;
  self.addButton.tag = SCButtonAdd;
  self.subButton.tag = SCButtonSub;
  self.mulButton.tag = SCButtonMul;
  self.divButton.tag = SCButtonDiv;
  self.eqlButton.tag = SCButtonEql;
  self.dotButton.tag = SCButtonDot;
  self.changeSignButton.tag = SCButtonChangeSign;
}

#pragma mark - Methods

- (void)performOperation:(NSInteger)theOperation {
  // 若連續輸入兩次運算子
  if (_isJustInputOperator) {
    _savedSelector = [self p_selectorWithOperation:theOperation];
    return;
  }

  _isJustInputOperator = YES;

  if (!self.leftDecNumber) {
    self.leftDecNumber = [NSDecimalNumber decimalNumberWithString:self.resultText];
    _savedSelector = [self p_selectorWithOperation:theOperation];
    return;
  }

  self.rightDecNumber = [NSDecimalNumber decimalNumberWithString:self.resultText];
  [self.resultText setString:@"0"];

  if (_savedSelector) {
    if (_savedSelector == @selector(decimalNumberByDividingBy:) && [self.rightDecNumber isEqualToNumber:[NSDecimalNumber zero]]) {
      [self p_showDivideByZeroAlert];
      [self p_reset];
      return;
    }

    self.leftDecNumber = [self.leftDecNumber performSelector:_savedSelector withObject:self.rightDecNumber];
    [self.resultText setString:[NSString stringWithFormat:@"%@", self.leftDecNumber]];
    self.resultLabel.text = self.resultText;
  }
  
  _savedSelector = [self p_selectorWithOperation:theOperation];
}

#pragma mark - Actions

- (IBAction)numberButtonPressed:(UIButton *)sender {
  if (_shouldClearInput) {
    [self.resultText setString:@"0"];
    self.resultLabel.text = self.resultText;
    _hasDot = NO;
    _shouldClearInput = NO;
  }

  // 輸入等號後再直接輸入數字，表示開始新一輪計算
  if (_isLastOperatorEql) {
    [self p_reset];
  }

  switch ([sender tag]) {
    case SCButton0: [self p_appendNumber:0]; break;
    case SCButton1: [self p_appendNumber:1]; break;
    case SCButton2: [self p_appendNumber:2]; break;
    case SCButton3: [self p_appendNumber:3]; break;
    case SCButton4: [self p_appendNumber:4]; break;
    case SCButton5: [self p_appendNumber:5]; break;
    case SCButton6: [self p_appendNumber:6]; break;
    case SCButton7: [self p_appendNumber:7]; break;
    case SCButton8: [self p_appendNumber:8]; break;
    case SCButton9: [self p_appendNumber:9]; break;

    case SCButtonDot:
      if (!_hasDot) {
        [self.resultText appendString:@"."];
        _hasDot = YES;
      }
      break;

    default:
      break;
  }

  self.resultLabel.text = self.resultText;
  _isJustInputOperator = NO;
}

- (IBAction)operateButtonPressed:(UIButton *)sender {
  switch ([sender tag]) {
    case SCButtonClear:
      [self p_reset];
      break;

    case SCButtonChangeSign:
      [self p_changeSign];
      break;

    case SCButtonAdd:
    case SCButtonSub:
    case SCButtonMul:
    case SCButtonDiv:
      _shouldClearInput = YES;
      _isLastOperatorEql = NO;
      [self performOperation:[sender tag]];
      break;

    case SCButtonEql:
      _shouldClearInput = YES;
      _isLastOperatorEql = YES;
      [self performOperation:[sender tag]];
      break;

    default:
      break;
  }
}

#pragma mark - Private

- (void)p_reset {
  [self.resultText setString:@"0"];
  self.resultLabel.text = self.resultText;
  self.leftDecNumber = nil;
  self.rightDecNumber = nil;

  _savedSelector = nil;
  _hasDot = NO;
  _shouldClearInput = NO;
  _isJustInputOperator = NO;
  _isLastOperatorEql = NO;
}

- (void)p_appendNumber:(int)aNumber {
  // 目前為0且沒小數點 -> 0:不變，其他:取代0
  if ([self.resultText isEqualToString:@"0"] && !_hasDot) {
    if (aNumber != 0) {
      [self.resultText setString:[NSString stringWithFormat:@"%d", aNumber]];
    }
    return;
  }

  [self.resultText appendFormat:@"%d", aNumber];
}

- (SEL)p_selectorWithOperation:(NSInteger)theOperation {
  SEL selector = nil;
  switch (theOperation) {
    case SCButtonAdd:
      selector = @selector(decimalNumberByAdding:);
      break;
    case SCButtonSub:
      selector = @selector(decimalNumberBySubtracting:);
      break;
    case SCButtonMul:
      selector = @selector(decimalNumberByMultiplyingBy:);
      break;
    case SCButtonDiv:
      selector = @selector(decimalNumberByDividingBy:);
      break;
    default:
      selector = _savedSelector;
      break;
  }
  return selector;
}

- (void)p_changeSign {
  if ([[NSDecimalNumber decimalNumberWithString:self.resultText] isEqualToNumber:[NSDecimalNumber zero]]) {
    return;
  }

  if ([self.resultText characterAtIndex:0] == '-') {
    [self.resultText setString:[self.resultText substringFromIndex:1]];
  } else {
    [self.resultText setString:[NSString stringWithFormat:@"-%@", self.resultText]];
  }

  self.resultLabel.text = self.resultText;
}

- (void)p_showDivideByZeroAlert {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"計算錯誤" message:@"無法除以0！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

@end
