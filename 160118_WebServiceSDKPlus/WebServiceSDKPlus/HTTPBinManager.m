//
//  HTTPBinManager.m
//  WebServiceSDKPlus
//
//  Created by shoshino21 on 1/2/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#import "HTTPBinManager.h"

#import "HTTPBinManagerOperation.h"

@interface HTTPBinManager () <HTTPBinManagerOperationDelegate>

@end

@implementation HTTPBinManager

+ (instancetype)sharedManager {
  static HTTPBinManager *manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [HTTPBinManager new];
  });
  return manager;
}

- (void)executeOperation {
#warning is it possible to clean queue elegantly?
  self.operationQueue = [NSOperationQueue new];
  HTTPBinManagerOperation *newOperation = [HTTPBinManagerOperation new];
  newOperation.delegate = self;
  [self.operationQueue addOperation:newOperation];
}

#pragma mark - Delegate methods

- (void)HTTPBinManagerOperationDidSuccess:(HTTPBinManagerOperation *)operation
                             fetchGetData:(NSDictionary *)getData
                                 postData:(NSDictionary *)postData
                                    image:(UIImage *)image {
  [self.delegate HTTPBinManagerDidSuccess:self fetchGetData:getData postData:postData image:image];
}

- (void)HTTPBinManagerOperationDidFail:(HTTPBinManagerOperation *)operation {
  [self.delegate HTTPBinManagerDidFail:self];
}

- (void)HTTPBinManagerOperationDidCancel:(HTTPBinManagerOperation *)operation {
  [self.delegate HTTPBinManagerDidCancel:self];
}

- (void)HTTPBinManagerOperation:(HTTPBinManagerOperation *)operation updateProgress:(CGFloat)progress {
  [self.delegate HTTPBinManager:self updateProgress:progress];
}

@end
