//
//  ViewController.m
//  151127_KKBOX_Prac2_CategoryPrac
//
//  Created by shoshino21 on 11/26/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"
#import "NSString+ReversedString.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  NSString *strA = @"abcde";
  NSLog(@"%@", [strA reversedString]);
  NSString *strB = @"1 2 3 4    5";
  NSLog(@"%@", [strB reversedString]);
  NSString *strC = @"測試！！";
  NSLog(@"%@", [strC reversedString]);
  NSString *strD = @"KKBOX iOS 開發教材";
  NSLog(@"%@", [strD reversedString]);
}

@end
