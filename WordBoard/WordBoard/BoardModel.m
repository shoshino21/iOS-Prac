//
//  BoardModel.m
//  WordBoard
//
//  Created by shoshino21 on 12/31/15.
//  Copyright © 2015 shoshino21. All rights reserved.
//

#import "BoardModel.h"

@interface BoardModel ()

@property(strong, nonatomic) NSMutableArray *stringArray;

@end

@implementation BoardModel

#pragma mark - Initialize

- (instancetype)initWithArray:(NSArray *)inArray {
  self = [super init];
  if (self) {
    _stringArray = [[NSMutableArray alloc] initWithArray:inArray];

    NSInteger count = inArray.count;
    for (NSInteger i = 0; i < count; i++) {
      _stringArray[i] = [NSMutableString stringWithString:inArray[i]];
    }
  }
  return self;
}

- (instancetype)init {
  return [self initWithArray:@[]];
}

#pragma mark - Properties

- (NSArray *)stringArray {
  return _stringArray;
}

- (NSString *)stringFromIndexX:(NSInteger)x indexY:(NSInteger)y {
  NSString *rowString = self.stringArray[y];
  return [rowString substringWithRange:NSMakeRange(x, 1)];
}

- (void)setString:(NSString *)aString ToIndexX:(NSInteger)x indexY:(NSInteger)y {
  NSMutableString *rowString = self.stringArray[y];
  NSRange rangeToReplace = NSMakeRange(x, 1);
  [self.stringArray[y] setString:[rowString stringByReplacingCharactersInRange:rangeToReplace withString:aString]];
}

@end
