//
//  Youtube.m
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/26.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "Youtube.h"
#import "GData.h"
#import "GTMOAuth2Authentication.h"

@implementation Youtube

- (void)getLists:(GTMOAuth2Authentication *)authentication
{
    NSURL *path = self.path;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:path];
    
    GTMHTTPFetcher *fetcher = [[GTMHTTPFetcher alloc] initWithRequest:request];
    [fetcher setAuthorizer:authentication];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        [_delegate youtube:self didRecieveData:data];
    }];
}

- (void)upLoadVideoFile
{
    
}

- (void)getVideo
{
    NSURL *url = self.path;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *feed = [result objectForKey:@"feed"];
        NSDictionary *entry = [feed objectForKey:@"entry"];
        NSLog(@"確認結果、%@",entry);
    }];
}

@end
