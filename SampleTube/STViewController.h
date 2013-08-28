//
//  STViewController.h
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/26.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YoutubeOAuth,Youtube;

@interface STViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableViewController *tableViewController;
    YoutubeOAuth *youtubeOAuth;
    Youtube *testTube;
}
@end
