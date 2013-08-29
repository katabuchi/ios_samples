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
NSString *const kYoutubeDeveloperKey = @"AI39si78J7MYMDXBhJR6UHNGHe1xl9J7-Jq6ElVAnj6tSNV81ctAr-7LLwKfQM1vl774H-mBBja7Dl-WEmE22vVmC7WVDSMI7Q";
//Google Developer Key 取得　url)https://code.google.com/apis/console/
NSString *const kYoutubeOAuthClientID = @"916411767679.apps.googleusercontent.com";
NSString *const kYoutubeOAuthClientSecret = @"GNc6nPW20WWO9BCTo_1Zj7Co";
NSString *const kYoutubeOAuthKeychainForName = @"SampleTube";
NSString *const kYoutubeOAuthScope = @"https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/youtube.upload";

@end
