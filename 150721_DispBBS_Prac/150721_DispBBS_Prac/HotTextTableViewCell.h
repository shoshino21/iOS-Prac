//
//  HotTextTableViewCell.h
//  150721_DispBBS_Prac
//
//  Created by shoshino21 on 7/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotTextTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *descLabel;

@end
