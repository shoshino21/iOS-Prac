//
//  SHOWebService2.h
//  151206_WebServiceSDK
//
//  Created by shoshino21 on 12/8/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHOWebService2;

@protocol SHOWebService2Delegate <NSObject>

@optional
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveDictionary:(NSDictionary *)dictionary;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveImage:(UIImage *)image;
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;

@end

@interface SHOWebService2 : NSObject

@property (weak, nonatomic) id<SHOWebService2Delegate> delegate;

+ (instancetype)sharedWebService;

- (void)fetchGetResponse;
- (void)postCustomerName:(NSString *)name;
- (void)fetchImage;

@end
