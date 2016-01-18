//
//  HTTPBinManagerOperation.h
//  WebServiceSDKPlus
//
//  Created by shoshino21 on 1/2/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTPBinManagerOperation;

@protocol HTTPBinManagerOperationDelegate <NSObject>

- (void)HTTPBinManagerOperationDidSuccess:(HTTPBinManagerOperation *)operation fetchGetData:(NSDictionary *)getData postData:(NSDictionary*)postData image:(UIImage *)image;
- (void)HTTPBinManagerOperationDidFail:(HTTPBinManagerOperation *)operation;
- (void)HTTPBinManagerOperationDidCancel:(HTTPBinManagerOperation *)operation;
- (void)HTTPBinManagerOperation:(HTTPBinManagerOperation *)operation updateProgress:(CGFloat)progress;

@end

@interface HTTPBinManagerOperation : NSOperation

@property(weak, nonatomic) id<HTTPBinManagerOperationDelegate> delegate;

- (instancetype)init;
- (void)main;
- (void)cancel;

@end
