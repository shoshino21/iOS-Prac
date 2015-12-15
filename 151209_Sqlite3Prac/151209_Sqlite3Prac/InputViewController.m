//
//  InputViewController.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/11/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController () {
  UIDatePicker *_datePicker;
}

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
      _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 80, 320, 164)];
      _datePicker.datePickerMode = UIDatePickerModeDate;
      _datePicker.maximumDate = [NSDate date];

      if (self.value.length == 0) {
        _datePicker.date = [NSDate date];
      } else {
        _datePicker.date = [NSDate dateWithTimeIntervalSince1970:[self.value doubleValue]];
      }

      [self.view addSubview:_datePicker];

      self.textField.hidden = YES;
      [self p_updateSubmitButtonFrameWithTargetFrame:_datePicker.frame];
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

#warning clean it if not needed
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSTimeInterval unixTimeStamp;

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
      if ([self.genderInputs[0] isEqual:@YES]) {
        self.value = @"M";
      } else if ([self.genderInputs[1] isEqual:@YES]) {
        self.value = @"F";
      } else {
        self.value = @"U";
      }
      break;

    case SubViewCellTypeBirth:
      unixTimeStamp = [[_datePicker date] timeIntervalSince1970];
      self.value = [NSString stringWithFormat:@"%f", unixTimeStamp];
      break;

    case SubViewCellTypeAddress:
      self.value = self.addressTextView.text;
      break;

    default:
      break;
  }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
  if ([identifier isEqualToString:@"fromInputViewSubmit"]) {
    NSString *alertMessage;
    if (self.cellType == SubViewCellTypePhone) {
      alertMessage = @"電話號碼格式錯誤";
    } else if (self.cellType == SubViewCellTypeEmail) {
      alertMessage = @"E-mail格式錯誤";
    } else {
      return YES;
    }

    BOOL isValid = [self p_checkWithRegexForType:self.cellType string:self.textField.text];
    if (isValid) {
      return YES;
    } else {
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:alertMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [av show];
      return NO;
    }
  }

  return YES;
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

- (BOOL)p_checkWithRegexForType:(SubViewCellType)inType string:(NSString *)aString {
  NSString *regexPattern;
  if (inType == SubViewCellTypePhone) {
    regexPattern = @"^[0-9]*$";
  } else if (inType == SubViewCellTypeEmail) {
    regexPattern = @"[A-Z0-9a-z]+([._%+-]{1}[A-Z0-9a-z]+)*@[A-Z0-9a-z]+([.-]{1}[A-Z0-9a-z]+)*(\\.[A-Za-z]{2," @"4}){0,1}";
  }

  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPattern];
  BOOL isValid = [predicate evaluateWithObject:aString];
  return isValid;
}

@end
