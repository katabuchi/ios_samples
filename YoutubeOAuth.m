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
    self.authentication = auth;
    return auth;
}

- (NSURL *)authorizationURL
{
    return [NSURL URLWithString:GoogleAuthURL];
}

- (void)signIn
{
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:[self keychainForName] clientID:[self googleClientID] clientSecret:[self googleClientSecret]];
    if([auth canAuthorize]){
        
    }else{
        GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:[self authForGoogle]
                                                                                                    authorizationURL:[self authorizationURL]
                                                                                                    keychainItemName:[self keychainForName]
                                                                                                            delegate:self.delegate
                                                                                                    finishedSelector:@selector(viewController:finishedWithAuth:error:)];
        [_delegate youtubeOAuth:self didCreateAuth2ViewControllerTouch:viewController];
    }
}

- (void)signOut
{
    GTMOAuth2Authentication *auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:[self keychainForName] clientID:[self googleClientID] clientSecret:[self googleClientSecret]];
    if([auth canAuthorize]){
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:[self keychainForName]];
        [GTMOAuth2ViewControllerTouch revokeTokenForGoogleAuthentication:auth];
    }
}

@end
