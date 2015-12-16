//
//  SubViewController.m
//  151209_Sqlite3Prac
//
//  Created by shoshino21 on 12/10/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SubViewController.h"

#import "DataModel.h"
#import "InputViewController.h"
#import "PhotoTableViewCell.h"

@interface SubViewController ()

@property (strong, nonatomic) NSArray *cellTitles;

@end

@implementation SubViewController

#pragma mark - View

- (void)viewDidLoad {
  [super viewDidLoad];

  self.subTableView.dataSource = self;
  self.subTableView.delegate = self;

  self.cellTitles = @[@"照片", @"編號 *", @"名字 *", @"性別 *", @"生日 *", @"電話", @"E-mail", @"住址"];

  if ([self.lastSegueIdentifier isEqualToString:@"addData"]) {
    self.cellInputItems = [[NSMutableArray alloc] initWithArray:@[@"", @"", @"", @"", @"", @"", @"", @""]];
  }
  else if ([self.lastSegueIdentifier isEqualToString:@"editData"]) {
    NSDictionary *dict = [DataModel sharedDataModel].items[self.currIndexPathRow];

    self.cellInputItems = [[NSMutableArray alloc] initWithArray:@[
      dict[@"PHOTO_URL"] ?: @"",
      dict[@"NUMBER"] ?: @"",
      dict[@"NAME"] ?: @"",
      dict[@"GENDER"] ?: @"",
      dict[@"BIRTH"] ?: @"",
      dict[@"PHONE"] ?: @"",
      dict[@"EMAIL"] ?: @"",
      dict[@"ADDRESS"] ?: @""
    ]];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.subTableView reloadData];
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"toInputView"]) {
    InputViewController *ivc = segue.destinationViewController;
    NSInteger indexPathRow = [self.subTableView indexPathForSelectedRow].row;

    ivc.value = self.cellInputItems[indexPathRow];
    ivc.cellType = (SubViewCellType)indexPathRow;
    ivc.navigationItem.title = self.cellTitles[indexPathRow];
  }
}

- (IBAction)backToSubWithUnwindSegue:(UIStoryboardSegue *)segue {
  InputViewController *ivc = segue.sourceViewController;
  self.cellInputItems[ivc.cellType] = ivc.value;

  [self.subTableView reloadData]; // This is required for reload data immediately!
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
  if ([identifier isEqualToString:@"fromSubView"]) {
    BOOL isNull1 = ( [self.cellInputItems[SubViewCellTypeNumber] length] == 0 );
    BOOL isNull2 = ( [self.cellInputItems[SubViewCellTypeName] length] == 0 );
    BOOL isNull3 = ( [self.cellInputItems[SubViewCellTypeGender] length] == 0 );
    BOOL isNull4 = ( [self.cellInputItems[SubViewCellTypeBirth] length] == 0 );

    NSString *alertMessage;
    if (isNull1) {
      alertMessage = @"請輸入編號";
    } else if (isNull2) {
      alertMessage = @"請輸入名字";
    } else if (isNull3) {
      alertMessage = @"請輸入性別";
    } else if (isNull4) {
      alertMessage = @"請輸入生日";
    }

    if (isNull1 || isNull2 || isNull3 || isNull4) {
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:alertMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [av show];
      return NO;
    } else {
      return YES;
    }
  }

  return YES;
}

#pragma mark - UITableViewDataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.cellTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return (indexPath.row == SubViewCellTypePhoto) ? 100.f : 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier;
  cellIdentifier = (indexPath.row == SubViewCellTypePhoto) ? @"photoCell" : @"dataCell";
  UITableViewCell *cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  if (!cellView) {
    if (indexPath.row == SubViewCellTypePhoto) {
      cellView = [[PhotoTableViewCell alloc] init];
    } else {
      cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
  }

  PhotoTableViewCell *photoCellView;

  switch (indexPath.row) {
    case SubViewCellTypePhoto:
      photoCellView = (PhotoTableViewCell *)cellView;
#warning TODO: different default icon for male and female (and unknown)
      photoCellView.photoImageView.image = [UIImage imageNamed:@"f"];
      break;

    case SubViewCellTypeGender: {
      cellView.textLabel.text = self.cellTitles[indexPath.row];
      NSString *genderInput = self.cellInputItems[SubViewCellTypeGender];
      if (genderInput.length == 0) {
        cellView.detailTextLabel.text = @"";
        break;
      }

      NSString *genderDisplay;
      if ([self.cellInputItems[SubViewCellTypeGender] isEqualToString:@"M"]) {
        genderDisplay = @"男";
      } else if ([self.cellInputItems[SubViewCellTypeGender] isEqualToString:@"F"]) {
        genderDisplay = @"女";
      } else {
        genderDisplay = @"不透露";
      }

      cellView.detailTextLabel.text = genderDisplay;
      break;
    }

    case SubViewCellTypeBirth: {
      cellView.textLabel.text = self.cellTitles[indexPath.row];

      NSString *birthdateString = self.cellInputItems[SubViewCellTypeBirth];
      if (birthdateString.length == 0) {
        cellView.detailTextLabel.text = @"";
        break;
      }

      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"YYYY/MM/dd"];

      NSTimeInterval unixTimeStamp = [birthdateString doubleValue];
      NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:unixTimeStamp];
      birthdateString = [dateFormatter stringFromDate:birthDate];

      cellView.detailTextLabel.text = birthdateString;
      break;
    }

    case SubViewCellTypeNumber:
    case SubViewCellTypeName:
    case SubViewCellTypePhone:
    case SubViewCellTypeEmail:
    case SubViewCellTypeAddress:
      cellView.textLabel.text = self.cellTitles[indexPath.row];
      cellView.detailTextLabel.text = self.cellInputItems[indexPath.row];
      break;

    default:
      break;
  }

  return cellView;
}

@end
