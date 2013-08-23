//
//  SPViewController.h
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/19.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPAppDelegate.h"

@interface SPViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    SPAppDelegate *appDelegate;
}
@property (nonatomic, strong) UITableView *mainTable;

@end
