//
//  YoutubeOAuth.m
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/26.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "YoutubeOAuth.h"
#import "YoutubeConfig.h"

@interface YoutubeOAuth()

- (GTMOAuth2Authentication *)authForGoogle;
- (NSURL *)authorizationURL;

@end


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

- (void)signOut
{
    if([self isLogin]){
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kYoutubeOAuthKeychainForName];
        [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:self.authentication];
    }
}

- (BOOL)isLogin
{
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kYoutubeOAuthKeychainForName clientID:kYoutubeOAuthClientID clientSecret:kYoutubeOAuthClientSecret];
    [self setAuthentication:auth];
    if([auth canAuthorize]){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark -
#pragma mark ---- private Method ----
- (GTMOAuth2Authentication *)authForGoogle
{
    NSURL * tokenURL = [NSURL URLWithString:GoogleTokenURL];
    NSString * redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
    GTMOAuth2Authentication * auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"SampleTube"
                                                                                       tokenURL:tokenURL
                                                                                    redirectURI:redirectURI
                                                                                       clientID:kYoutubeOAuthClientID
                                                                                   clientSecret:kYoutubeOAuthClientSecret];
    [auth setScope:kYoutubeOAuthScope];
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
                                                                                                   keychainItemName:kYoutubeOAuthKeychainForName
                                                                                                           delegate:self
                                                                                                   finishedSelector:@selector(viewController:finishedWithAuth:error:)];
        [_delegate youtubeOAuth:self didCreateAuth2ViewControllerTouch:viewController];
    }
}

#pragma mark -
#pragma mark ---- GTMOAuth2ViewControllerTouch CallBackMethod ----
- (void)viewController:(GTMOAuth2ViewControllerTouch * )viewController finishedWithAuth:(GTMOAuth2Authentication * )auth error:(NSError * )error
{
    [_delegate youtubeOAuth:self didFinishedWithOAuthController:viewController authentication:auth error:error];
}


@end
