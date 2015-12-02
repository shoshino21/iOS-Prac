//
//  SHOAppDelegate.m
//  151201_Snake
//
//  Created by shoshino21 on 12/1/15.
//  Copyright (c) 2015 shoshino21. All rights reserved.
//

#import "SHOAppDelegate.h"
#import "SHOViewController.h"

@interface SHOAppDelegate ()

@end

@implementation SHOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = [[SHOViewController alloc] init];
  [self.window makeKeyAndVisible];

  [application setStatusBarHidden:YES];

  return YES;
}

@end
