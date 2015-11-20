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

- (void)performOperation:(SCButton)operation {

}

- (NSMutableString *)readableNumberFromString:(NSString *)aString {
  // given 12.30000 we remove the trailing zeros
  NSMutableString *result = [NSMutableString stringWithString:aString];

  // check if it contains a . character.
  if ([result rangeOfString:@"."].location != NSNotFound) {

    // start from the end, and remove any 0 or . you find until you find a number greater than 0
    for (int i = (int)[result length] - 1; i >= 0; i--) {
      // get the char
      unichar currentChar = [result characterAtIndex:i];

      if (currentChar == '0') {
        // remove it from the string
        [result replaceCharactersInRange:NSMakeRange(i, 1) withString:@""];
      } else if (currentChar == '.') {
        // remove it from the string
        [result replaceCharactersInRange:NSMakeRange(i, 1) withString:@""];
        break;
      }
      else {
        break;
      }
    }
  }

  // assign default value if needed
  if ([result isEqualToString:@""]) {
    [result appendString:@"0"];
  }

  // remove the initial 0 if present
  if ([result length] > 1 && [result characterAtIndex:0] == '0') {
    [result replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
  }

  return result;
}

#pragma mark - Actions

- (IBAction)numberButtonPressed:(UIButton *)sender {
  if (_shouldClearInput) {
    self.resultLabel.text = @"";
    [self.resultText setString:@""];
    _shouldClearInput = NO;
  }

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
}

- (IBAction)operateButtonPressed:(UIButton *)sender {
  switch ([sender tag]) {
    case SCButtonClear:
      [self p_reset];
      break;

    default:
      break;
  }
}

#pragma mark - Private

- (void)p_reset {
  [self.resultText setString:@"0"];
  self.resultLabel.text = self.resultText;
  _hasDot = NO;
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

@end
