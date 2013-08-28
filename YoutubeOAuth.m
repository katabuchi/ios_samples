//
//  YoutubeOAuth.m
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/26.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "YoutubeOAuth.h"

@implementation YoutubeOAuth

#define GoogleAuthURL   @"https://accounts.google.com/o/oauth2/auth"
#define GoogleTokenURL  @"https://accounts.google.com/o/oauth2/token"
static YoutubeOAuth *sharedYoutubeOAuth = nil;

+ (YoutubeOAuth *)sharedYoutubeOAuth
{
    @synchronized(self){
        if(sharedYoutubeOAuth == nil){
            sharedYoutubeOAuth = [[self alloc] init];
        }
    }
    return sharedYoutubeOAuth;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if(sharedYoutubeOAuth == nil){
            sharedYoutubeOAuth = [super allocWithZone:zone];
            return sharedYoutubeOAuth;
        }
    }
    return nil;
}


- (GTMOAuth2Authentication *)authForGoogle
{
    NSURL * tokenURL = [NSURL URLWithString:GoogleTokenURL];
    NSString * redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
    GTMOAuth2Authentication * auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"SampleTube"
                                                             tokenURL:tokenURL
                                                          redirectURI:redirectURI
                                                             clientID:_googleClientID
                                                         clientSecret:_googleClientSecret];
    [auth setScope:[self scope]];
    return auth;
}

- (NSURL *)authorizationURL
{
    return [NSURL URLWithString:GoogleAuthURL];
}

- (void)signIn
{
    if([self isLogin]){
        
    }else{
        GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:[self authForGoogle]
                                                                                                    authorizationURL:[self authorizationURL]
                                                                                                    keychainItemName:[self keychainForName]
                                                                                                            delegate:self
                                                                                                    finishedSelector:@selector(viewController:finishedWithAuth:error:)];
        [_delegate youtubeOAuth:self didCreateAuth2ViewControllerTouch:viewController];
    }
}

- (void)signOut
{
    if([self isLogin]){
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:[self keychainForName]];
        [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:self.authentication];
    }
}

- (BOOL)isLogin
{
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:[self keychainForName] clientID:[self googleClientID] clientSecret:[self googleClientSecret]];
    [self setAuthentication:auth];
    
    if([auth canAuthorize]){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -
#pragma mark ---- GTMOAuth2ViewControllerTouch CallBackMethod ----
- (void)viewController:(GTMOAuth2ViewControllerTouch * )viewController finishedWithAuth:(GTMOAuth2Authentication * )auth error:(NSError * )error
{
    [_delegate youtubeOAuth:self didFinishedWithOAuthController:viewController authentication:auth error:error];
}


@end
