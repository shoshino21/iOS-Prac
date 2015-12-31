//
//  BoardView.h
//  WordBoard
//
//  Created by shoshino21 on 12/30/15.
//  Copyright © 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSInteger kLengthByCell = 8;

@class BoardView;

@protocol BoardViewDelegate <NSObject>

- (NSArray *)stringArrayForView:(BoardView *)inView;

@end

@interface BoardView : UIView

@property(weak, nonatomic) id<BoardViewDelegate> delegate;

@end
