//
//  ReadingViewController.h
//  150721_DispBBS_Prac
//
//  Created by shoshino21 on 7/22/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadingViewController : UIViewController<UIWebViewDelegate>

@property(weak, nonatomic) IBOutlet UIWebView *webView;
@property(strong, nonatomic) NSString *urlString;

@end
