//
//  Macro.h
//  TemplateProj
//
//  Created by shoshino21 on 12/20/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define NAVIGATION_HEIGHT 42
#define TABBAR_HEIGHT 49
#define STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#define IOS_VERSION [UIDevice currentDevice].systemVersion.floatValue

#define IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define CURRENT_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])


// Color

#define RGB(R, G, B) [UIColor colorWithRed:R/255.00 green:G/255.00 blue:B/255.00 alpha:1.0]

#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBA(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


// Avoid retain cycle

#define declareWeakSelf() __weak __typeof(self) weakSelf = self
#define declareStrongSelf() __strong __typeof(weakSelf) strongSelf = weakSelf


// Log

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


// Masonry

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
