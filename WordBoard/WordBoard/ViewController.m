//
//  ViewController.m
//  WordBoard
//
//  Created by shoshino21 on 12/30/15.
//  Copyright © 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(strong, nonatomic) NSMutableArray *table2D;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  NSArray *row = @[ @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h" ];
  self.table2D = [[NSMutableArray alloc] initWithArray:@[ row, row, row, row, row, row, row, row ]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
  return NO;
}

@end
