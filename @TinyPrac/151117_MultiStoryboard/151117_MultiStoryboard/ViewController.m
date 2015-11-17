//
//  ViewController.m
//  151117_MultiStoryboard
//
//  Created by shoshino21 on 11/17/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)goSubStoryboard:(UIButton *)sender {
  UIStoryboard *subSB = [UIStoryboard storyboardWithName:@"Sub" bundle:nil];
  UIViewController *subVC =
      (UIViewController *)[subSB instantiateInitialViewController];

//  [self presentViewController:subVC animated:YES completion:nil];
  [self.navigationController pushViewController:subVC animated:YES];
}

@end
