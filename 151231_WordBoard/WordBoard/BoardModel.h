//
//  BoardModel.h
//  WordBoard
//
//  Created by shoshino21 on 12/31/15.
//  Copyright © 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardModel : NSObject

- (instancetype)initWithArray:(NSArray *)inArray;

- (NSArray *)stringArray;
- (NSString *)stringFromIndexX:(NSInteger)x indexY:(NSInteger)y;
- (void)setString:(NSString *)aString ToIndexX:(NSInteger)x indexY:(NSInteger)y;

@end
