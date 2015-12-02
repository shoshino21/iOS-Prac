//
//  SHOSnakePoint.h
//  151201_Snake
//
//  Created by shoshino21 on 12/3/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHOSnakePoint : NSObject

@property (assign, nonatomic) NSUInteger x;
@property (assign, nonatomic) NSUInteger y;

- (instancetype)initWithX:(NSUInteger)x Y:(NSUInteger)y;
- (instancetype)init;
+ (SHOSnakePoint *)snakePointWithX:(NSUInteger)x Y:(NSUInteger)y;

@end
