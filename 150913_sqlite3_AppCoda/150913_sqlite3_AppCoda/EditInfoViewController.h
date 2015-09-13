//
//  EditInfoViewController.h
//  150913_sqlite3_AppCoda
//
//  Created by shoshino21 on 9/13/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInfoViewControllerDelegate

- (void)editingInfoWasFinished;

@end

@interface EditInfoViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic, strong) id<EditInfoViewControllerDelegate> delegate;
//
//@property(weak, nonatomic) IBOutlet UITextField *txtFirstname;
//
//@property(weak, nonatomic) IBOutlet UITextField *txtLastname;
//
//@property(weak, nonatomic) IBOutlet UITextField *txtAge;

@property(weak, nonatomic) IBOutlet UITextField *nameTextField;
@property(weak, nonatomic) IBOutlet UITextField *gradeTextField;

@property(nonatomic) int recordIDToEdit;

- (IBAction)saveInfo:(id)sender;

@end
