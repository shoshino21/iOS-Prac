//
//  MainViewController.m
//  TemplateProj
//
//  Created by shoshino21 on 12/20/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#import "SHOMainViewController.h"

#import "SHOInputViewController.h"
#import "SHOPersonTableViewCell.h"

static CGFloat const kSegmentedCtrlWidth = 140.f;
static CGFloat const kSegmentedCtrlHeight = 29.f;
static CGFloat const kSegmentedCtrlMarginY = 10.f;
static CGFloat const kSegmentedCtrlPaddingX = 20.f;

static CGFloat const kMainTableViewCellHeight = 80.f;
static NSString *const kPersonTableViewCellStr = @"kPersonTableViewCellStr";

@interface SHOMainViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SHOMainViewController {
  UIView *_containerView;
  UITableView *_mainTableView;
  UISegmentedControl *_sortKindSegmentedCtrl;
  UISegmentedControl *_sortOrderSegmentedCtrl;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  [self settingUI];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  [self addConstraints];
}

#pragma mark - UI

- (void)settingUI {
  [self settingNavigationBar];

  _containerView = [UIView new];
  _containerView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_containerView];

  _sortKindSegmentedCtrl = [[UISegmentedControl alloc] initWithItems:@[ @"1", @"2" ]];  // Test
  [_containerView addSubview:_sortKindSegmentedCtrl];

  _sortOrderSegmentedCtrl = [[UISegmentedControl alloc] initWithItems:@[ @"a", @"b" ]]; // Test
  [_containerView addSubview:_sortOrderSegmentedCtrl];

  _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _mainTableView.dataSource = self;
  _mainTableView.delegate = self;
  _mainTableView.backgroundColor = [UIColor whiteColor];
  _mainTableView.allowsSelection = NO;
  _mainTableView.showsVerticalScrollIndicator = NO;
  [_containerView addSubview:_mainTableView];

  [_mainTableView registerClass:[SHOPersonTableViewCell class] forCellReuseIdentifier:kSHOPersonTableViewCellStr];
}

- (void)settingNavigationBar {
  self.navigationItem.title = @"objc.io #1-1";

  UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(addPerson:)];
  self.navigationItem.rightBarButtonItem = addBarButton;
}

- (void)addConstraints {
  [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(STATUSBAR_HEIGHT + NAVIGATION_HEIGHT);
    make.width.equalTo(SCREEN_WIDTH);
    make.height.equalTo(SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATION_HEIGHT);
  }];

  [_sortKindSegmentedCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(_containerView.top).offset(kSegmentedCtrlMarginY);
    make.right.equalTo(_containerView.centerX).offset(-kSegmentedCtrlPaddingX / 2);
    make.width.equalTo(kSegmentedCtrlWidth);
    make.height.equalTo(kSegmentedCtrlHeight);
  }];

  [_sortOrderSegmentedCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(_containerView.top).offset(kSegmentedCtrlMarginY);
    make.left.equalTo(_containerView.centerX).offset(kSegmentedCtrlPaddingX / 2);
    make.width.equalTo(kSegmentedCtrlWidth);
    make.height.equalTo(kSegmentedCtrlHeight);
  }];

  [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(_sortKindSegmentedCtrl.bottom).offset(kSegmentedCtrlMarginY);
    make.width.equalTo(SCREEN_WIDTH);
    make.height.equalTo(SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATION_HEIGHT -
                        kSegmentedCtrlMarginY * 2 - kSegmentedCtrlHeight);
  }];
}

#pragma mark - Actions

- (IBAction)addPerson:(id)sender {
  SHOInputViewController *inputViewCtrl = [SHOInputViewController new];
  [self.navigationController pushViewController:inputViewCtrl animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SHOPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonTableViewCellStr];

  if (!cell) {
    cell = [[SHOPersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPersonTableViewCellStr];
  }

  cell.avatarImageView.backgroundColor = [UIColor brownColor];
  if (indexPath.row % 2 == 0) {

    cell.nameLabel.text = @"123213";
  }
  else
  {
    cell.nameLabel.text = @"123213ABCDEFGHJJIKqweruiopqweruiopqeruiop";

  }
  cell.birthLabel.text = @"2000/10/10";

  return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kMainTableViewCellHeight;
}

@end
