//
//  SPAppDelegate.h
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/19.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPViewController;

@interface SPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SPViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
