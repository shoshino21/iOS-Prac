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

@interface SubViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSArray *cellTitles;
@property (strong, nonatomic) PhotoTableViewCell *photoCellView;

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
  [self p_reloadTableViewInMainThread];
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
  if (![identifier isEqualToString:@"fromSubView"]) { return YES; }

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

#pragma mark - Delegate (UITableViewDataSource / Delegate)

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

  switch (indexPath.row) {
    case SubViewCellTypePhoto: {
      self.photoCellView = (PhotoTableViewCell *)cellView;

      // A photo picked but have not saved yet.
      if (self.isCustomPhotoPicked) { break; }

      NSString *imageName;
      if ([self.cellInputItems[SubViewCellTypePhoto] length] != 0) {
        imageName = self.cellInputItems[SubViewCellTypePhoto];
      } else {
        // default image
        imageName = self.cellInputItems[SubViewCellTypeGender];
        if (imageName.length == 0) { imageName = @"U"; }
      }

      self.photoCellView.photoImageView.image = [UIImage imageNamed:imageName];
      break;
    }

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row != SubViewCellTypePhoto) { return; }

  // iOS8~ //
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];

  UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
  }];

  // Check if camera enabled
  cameraAction.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];

  UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"開啟相簿"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.modalPresentationStyle = UIModalPresentationPopover;

    UIPopoverPresentationController *popover = imagePicker.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:imagePicker animated:YES completion:nil];
  }];

  UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"移除照片"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
    self.cellInputItems[SubViewCellTypePhoto] = @"";
    self.resizedPhotoImage = nil;
    self.isCustomPhotoPicked = NO;
    [self p_reloadTableViewInMainThread];
  }];

  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];

  [alertController addAction:cameraAction];
  [alertController addAction:libraryAction];
  [alertController addAction:removeAction];
  [alertController addAction:cancelAction];
  [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Delegate (UIImagePickerControllerDelegate)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
  self.resizedPhotoImage = [self p_imageWithImage:image scaledToSize:CGSizeMake(80.f, 80.f)];
  self.photoCellView.photoImageView.image = self.resizedPhotoImage;
  self.isCustomPhotoPicked = YES;

  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)p_reloadTableViewInMainThread {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.subTableView reloadData];
  });
}

- (UIImage *)p_imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
  UIGraphicsBeginImageContext(newSize);
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return newImage;
}

- (UIImage *)p_imageFromSandboxWithFileName:(NSString *)theFileName {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths[0];
  NSString *fileNameWithPaths = [NSString stringWithFormat:@"%@/%@", documentsDirectory, theFileName];
  return [UIImage imageWithContentsOfFile:fileNameWithPaths];
}

@end
