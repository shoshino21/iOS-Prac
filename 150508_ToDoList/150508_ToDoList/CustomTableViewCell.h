//
//  CustomTableViewCell.h
//  150508_ToDoList
//
//  Created by shoshino21 on 5/9/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *modifyDateTimeLabel;

@end
