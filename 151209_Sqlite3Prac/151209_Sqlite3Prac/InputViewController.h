//
//  InputViewController.h
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/11/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SubViewController.h"
#import <UIKit/UIKit.h>

@interface InputViewController
    : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSString *value;
@property(strong, nonatomic) NSMutableArray *cellInputItems;
@property(assign, nonatomic) SubViewCellType cellType;

@property(weak, nonatomic) IBOutlet UITextField *textField;
@property(weak, nonatomic) IBOutlet UIButton *submitButton;
@property(weak, nonatomic) IBOutlet UITableView *genderTableView;
@property(weak, nonatomic) IBOutlet UITextView *addressTextView;

@end
