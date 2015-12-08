//
//  SHOWebService.m
//  151206_WebServiceSDK
//
//  Created by shoshino21 on 12/6/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#define URL_GET @"http://httpbin.org/get"
#define URL_POST @"http://httpbin.org/post"
#define URL_IMAGE @"http://httpbin.org/image/png"

#import "SHOWebService.h"

@implementation SHOWebService

+ (instancetype)sharedWebService {
  static SHOWebService *webService = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    webService = [[SHOWebService alloc] init];
  });
  return webService;
}

- (void)fetchGetResponseWithCallback:(void (^)(NSDictionary *, NSError *))callback {
  NSURL *url = [NSURL URLWithString:URL_GET];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
  request.HTTPMethod = @"GET";

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
  {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
      NSLog(@"Error: %@", error.localizedDescription);
    }
    callback(dict, error);
  }];

  [task resume];
}

- (void)postCustomerName:(NSString *)name callback:(void (^)(NSDictionary *, NSError *))callback {
  NSURL *url = [NSURL URLWithString:URL_POST];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
  NSString *paramString = [NSString stringWithFormat:@"custname=%@", name];

  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [paramString length]] forHTTPHeaderField:@"Content-length"];

  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
  {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
      NSLog(@"Error: %@", error.localizedDescription);
    }
    callback(dict, error);
  }];
  
  [task resume];
}

- (void)fetchImageWithCallback:(void (^)(UIImage *, NSError *))callback {
  NSURL *url = [NSURL URLWithString:URL_IMAGE];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    UIImage *image = [UIImage imageWithData:data];
    if (error) {
      NSLog(@"Error: %@", error.localizedDescription);
    }
    callback(image, error);
  }];

  [task resume];
}

@end
