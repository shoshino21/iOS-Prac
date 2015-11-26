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
  NSMutableString *resultStr = [NSMutableString stringWithCapacity:len];

  while (len > 0) {
    [resultStr appendFormat:@"%c", [self characterAtIndex:len - 1]];
    len--;
  }

  return resultStr;
}

@end
