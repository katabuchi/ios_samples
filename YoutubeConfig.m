//
//  YoutubeConfig.m
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/29.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "YoutubeConfig.h"

@implementation YoutubeConfig

//Youtube Developer Key 取得　url)http://code.google.com/apis/youtube/dashboard/
NSString *const kYoutubeDeveloperKey = @"YourDeveloperKey";
//Google Developer Key 取得　url)https://code.google.com/apis/console/
NSString *const kYoutubeOAuthClientID = @"YourClientID";
NSString *const kYoutubeOAuthClientSecret = @"YourClientSecret";
NSString *const kYoutubeOAuthKeychainForName = @"YourApplicationBundleIdentifire";
NSString *const kYoutubeOAuthScope = @"https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/youtube.upload";

@end
