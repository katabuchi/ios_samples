//
//  STYoutubeStreamingViewController.h
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/29.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STYoutubeStreamingViewController : UIViewController
{
    UIWebView *mainWebViwe;
}
@property (nonatomic, strong) NSString *videoString;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *descriptionString;

@end
