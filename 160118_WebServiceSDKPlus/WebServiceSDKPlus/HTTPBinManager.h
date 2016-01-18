//
//  HTTPBinManager.h
//  WebServiceSDKPlus
//
//  Created by shoshino21 on 1/2/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTPBinManager;

@protocol HTTPBinManagerDelegate <NSObject>

- (void)HTTPBinManagerDidSuccess:(HTTPBinManager *)manager
                    fetchGetData:(NSDictionary *)getData
                        postData:(NSDictionary *)postData
                           image:(UIImage *)image;
- (void)HTTPBinManagerDidFail:(HTTPBinManager *)manager;
- (void)HTTPBinManagerDidCancel:(HTTPBinManager *)manager;
- (void)HTTPBinManager:(HTTPBinManager *)manager updateProgress:(CGFloat)progress;

@end

@interface HTTPBinManager : NSObject

@property(weak, nonatomic) id<HTTPBinManagerDelegate> delegate;
@property(strong, nonatomic) NSOperationQueue *operationQueue;

+ (instancetype)sharedManager;
- (void)executeOperation;

@end
