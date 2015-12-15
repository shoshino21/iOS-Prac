//
//  SubViewController.h
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/10/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

typedef enum {
  SubViewCellTypePhoto = 0,
  SubViewCellTypeNumber,
  SubViewCellTypeName,
  SubViewCellTypeGender,
  SubViewCellTypeBirth,
  SubViewCellTypePhone,
  SubViewCellTypeEmail,
  SubViewCellTypeAddress
} SubViewCellType;

#import <UIKit/UIKit.h>

@interface SubViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (strong, nonatomic) NSMutableArray *cellInputItems;

@end
