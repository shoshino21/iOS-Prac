//
//  InputViewController.m
//  TemplateProj
//
//  Created by shoshino21 on 12/25/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#import "SHOInputViewController.h"

#import "SHOInputAvatarTableViewCell.h"

typedef NS_ENUM(NSUInteger, SHOInputType) {
  SHOInputTypeAvatar,
  SHOInputTypeName,
  SHOInputTypeGender,
  SHOInputTypeBirth,
};

static CGFloat const kInputTableViewCellHeight = 80.f;
static NSString *const kInputAvatarTableViewCellStr = @"kInputAvatarTableViewCell";
static NSString *const kInputCommonTableViewCellStr = @"kInputCommonTableViewCell";

@interface SHOInputViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SHOInputViewController {
  UITableView *_inputTableView;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  [self settingUI];
}

#pragma mark - UI

- (void)settingUI {
  [self settingNavigationBar];

  _inputTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
  _inputTableView.dataSource = self;
  _inputTableView.delegate = self;
  _inputTableView.backgroundColor = [UIColor whiteColor];
  _inputTableView.allowsSelection = NO;
  _inputTableView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_inputTableView];

  [_inputTableView registerClass:[kInputAvatarTableViewCellStr class] forCellReuseIdentifier:kInputAvatarTableViewCellStr];
}

- (void)settingNavigationBar {
  self.navigationItem.title = @"New person";

  UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                 target:self
                                                                                 action:@selector(donePress:)];
  self.navigationItem.rightBarButtonItem = doneBarButton;
}

#pragma mark - Actions

- (IBAction)donePress:(id)sender {
  DLog(@"done pressed");
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    SHOInputAvatarTableViewCell *avatarCell =
    [tableView dequeueReusableCellWithIdentifier:kInputAvatarTableViewCellStr];
  }
  else {
    UITableViewCell *subTitleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                           reuseIdentifier:kInputCommonTableViewCellStr];
  }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kInputTableViewCellHeight;
}

@end
