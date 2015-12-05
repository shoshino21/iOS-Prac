//
//  SHOSnakeBoardSize.h
//  151201_Snake
//
//  Created by shoshino21 on 12/3/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHOSnakeBoardSize : NSObject

@property (assign, nonatomic) NSUInteger width;
@property (assign, nonatomic) NSUInteger height;

- (instancetype)initWithWidth:(NSUInteger)inWidth height:(NSUInteger)inHeight;

@end
