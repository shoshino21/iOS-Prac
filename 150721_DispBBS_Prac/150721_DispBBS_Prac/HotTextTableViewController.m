//
//  HotTextTableViewController.m
//  150721_DispBBS_Prac
//
//  Created by shoshino21 on 7/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "HotTextTableViewController.h"
#import "HotTextTableViewCell.h"
#import "ReadingViewController.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface HotTextTableViewController ()

@property(nonatomic, strong) NSMutableArray *hotTexts;

@end

@implementation HotTextTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadHotTexts];
}

- (void)loadHotTexts {
  self.hotTexts = [NSMutableArray arrayWithCapacity:20];
  NSString *urlString = @"http://disp.cc/api/hot_text.json";

  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  manager.responseSerializer = [AFJSONResponseSerializer serializer];

  [manager GET:urlString
      parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data = (NSDictionary *)responseObject;
        NSLog(@"err:%@", data[@"err"]);
        self.hotTexts = data[@"list"];
        [self.tableView reloadData];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:@"Error Retrieving HotTexts"
                                       message:[error localizedDescription]
                                      delegate:nil
                             cancelButtonTitle:@"Ok"
                             otherButtonTitles:nil];
        [alertView show];
      }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.hotTexts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HotTextTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"HotTextCell"
                                      forIndexPath:indexPath];

  NSDictionary *hotText = self.hotTexts[indexPath.row];
  cell.titleLabel.text = hotText[@"title"];
  cell.descLabel.text = hotText[@"desc"];

  NSArray *img_list = hotText[@"img_list"];
  if ([img_list count]) {
    UIImage *placeholderImage =
        [UIImage imageNamed:@"displogo120.png"];  // 讀取完成前先顯示預設圖片
    NSURL *url = [NSURL URLWithString:img_list[0]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [cell.thumbImage
        setImageWithURLRequest:request
              placeholderImage:placeholderImage
                       success:^(NSURLRequest *request,
                                 NSHTTPURLResponse *response, UIImage *image) {
                         cell.thumbImage.image = image;
                         [cell setNeedsLayout];
                       }
                       failure:nil];
  } else {
    cell.thumbImage.image = [UIImage imageNamed:@"displogo120.png"];
  }

  return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSDictionary *hotText =
      self.hotTexts[self.tableView.indexPathForSelectedRow.row];
  NSString *urlString =
      [NSString stringWithFormat:@"http://disp.cc/m/%@-%@", hotText[@"bi"],
                                 hotText[@"ti"]];
  ReadingViewController *readingViewController =
      segue.destinationViewController;
  readingViewController.urlString = urlString;
}

@end
