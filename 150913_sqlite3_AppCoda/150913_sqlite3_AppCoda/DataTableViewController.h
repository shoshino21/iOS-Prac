//
//  DataTableViewController.h
//  150913_sqlite3_AppCoda
//
//  Created by shoshino21 on 9/13/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInfoViewController.h"

@interface DataTableViewController
    : UITableViewController<EditInfoViewControllerDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *tblPeople;

- (IBAction)addNewRecord:(id)sender;

@end
