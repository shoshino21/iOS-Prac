//
//  NSString+ReversedString.m
//  151127_KKBOX_Prac2_CategoryPrac
//
//  Created by shoshino21 on 11/26/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "NSString+ReversedString.h"

@implementation NSString (ReversedString)

- (NSString *)reversedString {
  int len = (int)[self length];
  NSMutableString *resultStr = [[NSMutableString alloc] init];
  [resultStr setString:@""];
  NSMutableString *subStr = [[NSMutableString alloc] init];

  while (len > 0) {
    [subStr setString:[self substringWithRange:NSMakeRange(len - 1, 1)]];
    [resultStr appendString:subStr];
    len--;
  }

  return resultStr;
}

@end
