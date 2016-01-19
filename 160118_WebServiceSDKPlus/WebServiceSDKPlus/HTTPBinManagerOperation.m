//
//  HTTPBinManagerOperation.m
//  WebServiceSDKPlus
//
//  Created by shoshino21 on 1/2/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#import "HTTPBinManagerOperation.h"

#import "SHOWebService.h"

@implementation HTTPBinManagerOperation {
  SHOWebService *_ws;
  NSPort *_port;
  BOOL _isRunloopRunning;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _ws = [SHOWebService sharedWebService];
    _port = [NSPort new];
    _isRunloopRunning = NO;
  }
  return self;
}

- (void)main {
  @autoreleasepool {
    __block NSDictionary *getData, *postData;

    [_ws fetchGetResponseWithCallback:^(NSDictionary *dict, NSError *error) {
      [self p_quitRunLoop];

      if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.delegate HTTPBinManagerOperationDidFail:self];
        });
        return;

      } else {
        getData = dict;
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.delegate HTTPBinManagerOperation:self updateProgress:.33f];
        });
      }
    }];

    if (self.isCancelled) {
      return;
    }
    [self p_doRunLoop];

    [_ws postCustomerName:@"test"
                 callback:^(NSDictionary *dict, NSError *error) {
                   [self p_quitRunLoop];

                   if (error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                       [self.delegate HTTPBinManagerOperationDidFail:self];
                     });
                     return;

                   } else {
                     postData = dict;
                     dispatch_async(dispatch_get_main_queue(), ^{
                       [self.delegate HTTPBinManagerOperation:self updateProgress:.66f];
                     });
                   }
                 }];

    if (self.isCancelled) {
      return;
    }
    [self p_doRunLoop];

    [_ws fetchImageWithCallback:^(UIImage *img, NSError *error) {
      [self p_quitRunLoop];

      if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.delegate HTTPBinManagerOperationDidFail:self];
        });
        return;

      } else {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.delegate HTTPBinManagerOperation:self updateProgress:1.f];
          [self.delegate HTTPBinManagerOperationDidSuccess:self fetchGetData:getData postData:postData image:img];
        });
      }
    }];

    if (self.isCancelled) {
      return;
    }
    [self p_doRunLoop];
  }
}

- (void)cancel {
  [super cancel];
  [self p_quitRunLoop];
  [_ws cancelAllTaskInSession:[NSURLSession sharedSession]];
  [self.delegate HTTPBinManagerOperationDidCancel:self];
}

#pragma mark - RunLoop

- (void)p_doRunLoop {
  _isRunloopRunning = YES;
  _port = [NSPort new];
  [[NSRunLoop currentRunLoop] addPort:_port forMode:NSRunLoopCommonModes];

  while (_isRunloopRunning && !self.isCancelled) {
    @autoreleasepool {
      [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
  }

  _port = nil;
}

- (void)p_quitRunLoop {
  [_port invalidate];
  _isRunloopRunning = NO;
}

@end
