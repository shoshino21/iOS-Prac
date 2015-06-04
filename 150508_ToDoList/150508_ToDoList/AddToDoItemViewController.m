//
//  AddToDoItemViewController.m
//  150508_ToDoList
//
//  Created by shoshino21 on 5/8/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "AddToDoItemViewController.h"

@interface AddToDoItemViewController ()

@property(weak, nonatomic) IBOutlet UITextField *addToDoItemTextField;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddToDoItemViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
// preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  if (sender != self.saveButton) return;

  if (self.addToDoItemTextField.text.length > 0) {
    // Add a To-Do Item to plist
    self.dictionaryToAdd = @{
      @"content" : self.addToDoItemTextField.text,
      @"isFinished" : @NO,
      @"modifyDateTime" : [NSDate date]
    };
  }
}

@end
