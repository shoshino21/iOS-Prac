//
//  ViewController.m
//  151206_WebServiceSDK
//
//  Created by shoshino21 on 12/6/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ViewController.h"
#import "SHOWebService.h"
#import "SHOWebService2.h"

@interface ViewController () <SHOWebService2Delegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)get:(UIButton *)sender {
  SHOWebService *ws = [SHOWebService sharedWebService];
  [ws fetchGetResponseWithCallback:^(NSDictionary *dict, NSError *error) {
    NSLog(@"dict: %@", dict);
  }];
}

- (IBAction)post:(UIButton *)sender {
  SHOWebService *ws = [SHOWebService sharedWebService];
  [ws postCustomerName:@"shoshino21" callback:^(NSDictionary *dict, NSError *error) {
    NSLog(@"dict: %@", dict);
  }];
}

- (IBAction)fetchImage:(UIButton *)sender {
  SHOWebService *ws = [SHOWebService sharedWebService];
  [ws fetchImageWithCallback:^(UIImage *image, NSError *error) {
    self.imageView.image = image;
  }];
}

- (IBAction)get2:(UIButton *)sender {
  SHOWebService2 *ws2 = [SHOWebService2 sharedWebService];
  ws2.delegate = self;
  [ws2 fetchGetResponse];
}

- (IBAction)post2:(UIButton *)sender {
  SHOWebService2 *ws2 = [SHOWebService2 sharedWebService];
  ws2.delegate = self;
  [ws2 postCustomerName:@"shoshino21"];
}

- (IBAction)fetchImage2:(UIButton *)sender {
  SHOWebService2 *ws2 = [SHOWebService2 sharedWebService];
  ws2.delegate = self;
  [ws2 fetchImage];
}

#pragma mark - SHOWebService2Delegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveDictionary:(NSDictionary *)dictionary {
  NSLog(@"dict: %@", dictionary);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveImage:(UIImage *)image {
  self.imageView2.image = image;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
}

@end
