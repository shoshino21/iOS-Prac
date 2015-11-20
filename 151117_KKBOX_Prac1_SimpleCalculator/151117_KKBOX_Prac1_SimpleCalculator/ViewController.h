//
//  ViewController.h
//  151117_KKBOX_Prac1_SimpleCalculator
//
//  Created by shoshino21 on 11/17/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  SCButtonClear,
  SCButton0, SCButton1, SCButton2, SCButton3, SCButton4,
  SCButton5, SCButton6, SCButton7, SCButton8, SCButton9,
  SCButtonAdd, SCButtonSub, SCButtonMul, SCButtonDiv, SCButtonEql,
  SCButtonDot, SCButtonChangeSign
} SCButton ;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *num0Button;
@property (weak, nonatomic) IBOutlet UIButton *num1Button;
@property (weak, nonatomic) IBOutlet UIButton *num2Button;
@property (weak, nonatomic) IBOutlet UIButton *num3Button;
@property (weak, nonatomic) IBOutlet UIButton *num4Button;
@property (weak, nonatomic) IBOutlet UIButton *num5Button;
@property (weak, nonatomic) IBOutlet UIButton *num6Button;
@property (weak, nonatomic) IBOutlet UIButton *num7Button;
@property (weak, nonatomic) IBOutlet UIButton *num8Button;
@property (weak, nonatomic) IBOutlet UIButton *num9Button;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *subButton;
@property (weak, nonatomic) IBOutlet UIButton *mulButton;
@property (weak, nonatomic) IBOutlet UIButton *divButton;
@property (weak, nonatomic) IBOutlet UIButton *eqlButton;
@property (weak, nonatomic) IBOutlet UIButton *dotButton;
@property (weak, nonatomic) IBOutlet UIButton *changeSignButton;

@end
