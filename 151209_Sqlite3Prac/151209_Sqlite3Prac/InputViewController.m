//
//  InputViewController.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/11/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()

@property (strong, nonatomic) NSArray *genderTitles;
@property (strong, nonatomic) NSMutableArray *genderInputs;

@end

@implementation InputViewController

#pragma mark - View

- (void)viewDidLoad {
  [super viewDidLoad];

  self.genderTableView.dataSource = self;
  self.genderTableView.delegate = self;
  self.genderTableView.hidden = YES;
  self.addressTextView.hidden = YES;
  self.submitButton.layer.cornerRadius = 8.f;

  switch (self.cellType) {
    case SubViewCellTypePhoto:
      break;

    case SubViewCellTypeNumber:
      self.textField.keyboardType = UIKeyboardTypeNamePhonePad;
      self.textField.placeholder = @"請輸入編號";
      break;

    case SubViewCellTypeName:
      self.textField.placeholder = @"請輸入名字";
      break;

    case SubViewCellTypeGender:
      [self p_initializeForGender];
      self.genderTableView.hidden = NO;
      self.textField.hidden = YES;
      [self p_updateSubmitButtonFrameWithTargetFrame:self.genderTableView.frame];
      break;

    case SubViewCellTypeBirth: {
      UIDatePicker *dp = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 80, 320, 164)];
      dp.datePickerMode = UIDatePickerModeDate;
      dp.date = [NSDate date];
      dp.maximumDate = [NSDate date];
      [self.view addSubview:dp];

      self.textField.hidden = YES;
      [self p_updateSubmitButtonFrameWithTargetFrame:dp.frame];
      break;
    }

    case SubViewCellTypePhone:
      self.textField.keyboardType = UIKeyboardTypePhonePad;
      self.textField.placeholder = @"請輸入電話或手機號碼 (例：0912345678)";
      break;

    case SubViewCellTypeEmail:
      self.textField.keyboardType = UIKeyboardTypeEmailAddress;
      self.textField.placeholder = @"請輸入 E-mail (例：abc@def.com)";
      break;

    case SubViewCellTypeAddress:
      self.addressTextView.hidden = NO;
      self.addressTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
      self.addressTextView.layer.borderWidth = 1.f;
      self.addressTextView.layer.cornerRadius = 8.f;

      self.textField.hidden = YES;
      [self p_updateSubmitButtonFrameWithTargetFrame:self.addressTextView.frame];
      break;

    default:
      break;
  }

  if (self.textField.hidden == NO) {
    self.textField.text = self.value;
    [self.textField becomeFirstResponder];  // Show keyboard immediately
  } else if (self.addressTextView.hidden == NO) {
    self.addressTextView.text = self.value;
    [self.addressTextView becomeFirstResponder];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)submit:(UIButton *)sender {
//  switch (self.cellType) {
//    case SubViewCellTypePhoto:
//      break;
//
//    case SubViewCellTypeNumber:
//    case SubViewCellTypeName:
//    case SubViewCellTypePhone:
//    case SubViewCellTypeEmail:
////      self.cellInputItems[self.cellType] = self.textField.text;
//      self.value = self.textField.text;
//      break;
//
//    case SubViewCellTypeGender:
//    case SubViewCellTypeBirth:
//    case SubViewCellTypeAddress:
//      break;
//
//    default:
//      break;
//  }

}

#pragma mark - UITableViewDataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.genderTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"cell";
  UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (!cellView) {
    cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }

  cellView.textLabel.text = self.genderTitles[indexPath.row];

  if ([self.genderInputs[indexPath.row] isEqual:@YES]) {
    cellView.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cellView.accessoryType = UITableViewCellAccessoryNone;
  }

  return cellView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  for (NSInteger i = 0; i < self.genderTitles.count; i++) {
    self.genderInputs[i] = (i == indexPath.row) ? @YES : @NO;
  }
  [self.genderTableView reloadData];
}

#pragma mark - Private

- (void)p_initializeForGender {
  self.genderTitles = @[@"男", @"女", @"不透露"];

  NSArray *tmpArr;
  if ([self.value isEqualToString:@"M"]) {
    tmpArr = @[@YES, @NO, @NO];
  } else if ([self.value isEqualToString:@"F"]) {
    tmpArr = @[@NO, @YES, @NO];
  } else {
    tmpArr = @[@NO, @NO, @YES];
  }
  self.genderInputs = [[NSMutableArray alloc] initWithArray:tmpArr];
}

- (void)p_updateSubmitButtonFrameWithTargetFrame:(CGRect)tf {
  CGRect bf = self.submitButton.frame;
  self.submitButton.frame = (CGRect){ bf.origin.x, (tf.origin.y + tf.size.height + 20), bf.size };
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  switch (self.cellType) {
    case SubViewCellTypePhoto:
      break;

    case SubViewCellTypeNumber:
    case SubViewCellTypeName:
    case SubViewCellTypePhone:
    case SubViewCellTypeEmail:
      self.value = self.textField.text;
      break;

    case SubViewCellTypeGender:
    case SubViewCellTypeBirth:
    case SubViewCellTypeAddress:
      break;

    default:
      break;
  }
}

@end
