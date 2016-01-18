//
//  SHOWebService.h
//  151206_WebServiceSDK
//
//  Created by shoshino21 on 12/6/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHOWebService : NSObject

+ (instancetype)sharedWebService;

- (void)fetchGetResponseWithCallback:(void (^)(NSDictionary *, NSError *))callback;
- (void)postCustomerName:(NSString *)name callback:(void (^)(NSDictionary *, NSError *))callback;
- (void)fetchImageWithCallback:(void (^)(UIImage *, NSError *))callback;
- (void)cancelAllTaskInSession:(NSURLSession *)session;

@end
