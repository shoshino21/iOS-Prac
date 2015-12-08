//
//  SHOWebService2.m
//  151206_WebServiceSDK
//
//  Created by shoshino21 on 12/8/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#define URL_GET @"http://httpbin.org/get"
#define URL_POST @"http://httpbin.org/post"
#define URL_IMAGE @"http://httpbin.org/image/png"

#import "SHOWebService2.h"

@implementation SHOWebService2

+ (instancetype)sharedWebService {
  static SHOWebService2 *webService = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    webService = [[SHOWebService2 alloc] init];
  });
  return webService;
}

- (void)fetchGetResponse {
  NSURL *url = [NSURL URLWithString:URL_GET];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
  request.HTTPMethod = @"GET";

  NSURLSession *session = [NSURLSession sharedSession];
  [self p_cancelAllTaskInSession:session];

  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    if (!error) {
      [self.delegate SHOWebService2:self didReceiveDictionary:dict];
    } else {
      [self.delegate SHOWebService2:self didCompleteWithError:error];
    }
  }];

  [task resume];
}

- (void)postCustomerName:(NSString *)name {
  NSURL *url = [NSURL URLWithString:URL_POST];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
  NSString *paramString = [NSString stringWithFormat:@"custname=%@", name];

  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [paramString length]] forHTTPHeaderField:@"Content-length"];

  NSURLSession *session = [NSURLSession sharedSession];
  [self p_cancelAllTaskInSession:session];

  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    if (!error) {
      [self.delegate SHOWebService2:self didReceiveDictionary:dict];
    } else {
      [self.delegate SHOWebService2:self didCompleteWithError:error];
    }
  }];

  [task resume];
}

- (void)fetchImage {
  NSURL *url = [NSURL URLWithString:URL_IMAGE];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

  NSURLSession *session = [NSURLSession sharedSession];
  [self p_cancelAllTaskInSession:session];

  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (!error) {
      UIImage *image = [UIImage imageWithData:data];
      [self.delegate SHOWebService2:self didReceiveImage:image];
    } else {
      [self.delegate SHOWebService2:self didCompleteWithError:error];
    }
  }];

  [task resume];
}

- (void)p_cancelAllTaskInSession:(NSURLSession *)session {
  [session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
    if (dataTasks.count != 0) {
      for (NSURLSessionTask *task in dataTasks) {
        [task cancel];
      }
    }
  }];
}

@end
