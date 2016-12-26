//
//  MainViewController.m
//  TemplateProj
//
//  Created by shoshino21 on 12/20/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#import "MainViewController.h"

#import "InputViewController.h"

static CGFloat const kSegmentedCtrlWidth = 140.f;
static CGFloat const kSegmentedCtrlHeight = 29.f;
static CGFloat const kSegmentedCtrlMarginY = 10.f;
static CGFloat const kSegmentedCtrlPaddingX = 20.f;

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MainViewController {
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
  _mainTableView.allowsSelection = NO;
  [_containerView addSubview:_mainTableView];
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
  InputViewController *inputViewCtrl = [InputViewController new];
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
  static NSString *cellIdentifierStr;
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStr];

  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierStr];
  }

  cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];

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
  return 60.f;
}

@end
