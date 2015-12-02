//
//  SHOViewController.m
//  151201_Snake
//
//  Created by shoshino21 on 12/1/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SHOViewController.h"
#import "SHOSnakePoint.h"

@interface SHOViewController ()

@end

@implementation SHOViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

#warning TEST
//  NSLog(@"TEST");
//  CGFloat sw = [UIScreen mainScreen].bounds.size.width;
//  CGFloat sh = [UIScreen mainScreen].bounds.size.height;
//
//  NSLog(@"%f x %f", sw, sh);
  SHOSnakePoint *sp = [SHOSnakePoint snakePointWithX:20 Y:10];
  NSLog(@"%@", sp);
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
