//
//  ReadingViewController.m
//  150721_DispBBS_Prac
//
//  Created by shoshino21 on 7/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "ReadingViewController.h"
#import "UIWebView+AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface ReadingViewController ()

@end

@implementation ReadingViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.webView.delegate = self;

  NSURL *url = [NSURL URLWithString:self.urlString];
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

  [self.webView loadRequest:urlRequest
      progress:nil
      success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        return HTML;
      }
      failure:^(NSError *error) {
        NSLog(@"error: %@", [error localizedDescription]);
      }];
}

- (void)viewWillAppear:(BOOL)animated {
  // 避免尚未讀取完成就跳出文章時進度顯示器關不掉的問題
  while ([AFNetworkActivityIndicatorManager
              .sharedManager isNetworkActivityIndicatorVisible]) {
    [AFNetworkActivityIndicatorManager.sharedManager decrementActivityCount];
  }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
  [AFNetworkActivityIndicatorManager.sharedManager incrementActivityCount];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [AFNetworkActivityIndicatorManager.sharedManager decrementActivityCount];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [AFNetworkActivityIndicatorManager.sharedManager decrementActivityCount];
}

@end
