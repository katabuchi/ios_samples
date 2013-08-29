//
//  YoutubeOAuth.h
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/26.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"

@class YoutubeOAuth;
@protocol YoutubeOAuthDelegate <NSObject>

- (void)youtubeOAuth:(YoutubeOAuth *)youtubeOAuth didCreateAuth2ViewControllerTouch:(GTMOAuth2ViewControllerTouch *)viewController;
- (void)youtubeOAuth:(YoutubeOAuth *)youtubeOAuth didFinishedWithOAuthController:(GTMOAuth2ViewControllerTouch *)viewController authentication:(GTMOAuth2Authentication *)auth error:(NSError *)error;

@end

@interface YoutubeOAuth : NSObject

@property (nonatomic, strong) GTMOAuth2Authentication *authentication;
@property (nonatomic, weak) id<YoutubeOAuthDelegate>delegate;

+ (YoutubeOAuth *)sharedYoutubeOAuth;
- (GTMOAuth2Authentication *)authForGoogle;
- (NSURL *)authorizationURL;
- (void)signIn;
- (void)signOut;
- (BOOL)isLogin;
@end
