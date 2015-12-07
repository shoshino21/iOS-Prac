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

@property (strong, nonatomic) SHOWebService *ws;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.ws = [SHOWebService new];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)get:(UIButton *)sender {
  [self.ws fetchGetResponseWithCallback:^(NSDictionary *dict, NSError *error) {
    NSLog(@"dict: %@", dict);
  }];
}

- (IBAction)post:(UIButton *)sender {
  [self.ws postCustomerName:@"shoshino21" callback:^(NSDictionary *dict, NSError *error) {
    NSLog(@"dict: %@", dict);
  }];
}

- (IBAction)fetchImage:(UIButton *)sender {
  [self.ws fetchImageWithCallback:^(UIImage *image, NSError *error) {
    self.imageView.image = image;
  }];
}

@end
