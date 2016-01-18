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
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _ws = [SHOWebService sharedWebService];
  }
  return self;
}

- (void)main {
#warning it's legal to return directly in another thread?

  __block NSDictionary *getData, *postData;

  [_ws fetchGetResponseWithCallback:^(NSDictionary *dict, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        [self.delegate HTTPBinManagerOperationDidFail:self];
        return;
      } else {
        getData = dict;
        [self.delegate HTTPBinManagerOperation:self updateProgress:.33f];
      }
    });
  }];

  [_ws postCustomerName:@"test"
               callback:^(NSDictionary *dict, NSError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                   if (error) {
                     [self.delegate HTTPBinManagerOperationDidFail:self];
                     return;
                   } else {
                     postData = dict;
                     [self.delegate HTTPBinManagerOperation:self updateProgress:.66f];
                   }
                 });
               }];

  [_ws fetchImageWithCallback:^(UIImage *img, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        [self.delegate HTTPBinManagerOperationDidFail:self];
        return;
      } else {
        [self.delegate HTTPBinManagerOperation:self updateProgress:1.f];
        [self.delegate HTTPBinManagerOperationDidSuccess:self fetchGetData:getData postData:postData image:img];
      }
    });
  }];
}

- (void)cancel {
#warning is it useful?
  [_ws cancelAllTaskInSession:[NSURLSession sharedSession]];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.delegate HTTPBinManagerOperationDidCancel:self];
  });
}

@end
