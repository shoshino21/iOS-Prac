//
//  ViewController.m
//  151206_WebServiceSDK
//
//  Created by shoshino21 on 12/6/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"
#import "SHOWebService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
//  SHOWebService *ws = [[SHOWebService alloc] init];
//  [ws fetchGetResponseWithCallback:^(NSDictionary *dict, NSError *error) {
//    NSLog(@"dict: %@", dict);
//  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)get:(UIButton *)sender {
  SHOWebService *ws = [[SHOWebService alloc] init];
  [ws fetchGetResponseWithCallback:^(NSDictionary *dict, NSError *error) {
    NSLog(@"dict: %@", dict);
  }];

}

@end
