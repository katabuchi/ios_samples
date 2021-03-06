//
//  STAppDelegate.h
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/26.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STViewController, STPostViewController, STSettingViewController, STFavoriteViewController;

@interface STAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) STViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) STPostViewController *postViewController;
@property (strong, nonatomic) UINavigationController *navigationController2;
@property (strong, nonatomic) STSettingViewController *settingViewController;
@property (strong, nonatomic) STFavoriteViewController *favoriteViewController;

@end
