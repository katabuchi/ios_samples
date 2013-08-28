//
//  Youtube.h
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/26.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GData,Youtube,GTMOAuth2Authentication;
@protocol YoutubeDelegate <NSObject>
@optional
- (void)youtube:(Youtube *)youtube didRecieveData:(NSData *)data;
@end

@interface Youtube : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData *receiveData;
}

@property (nonatomic, strong) NSURL *path;
@property (nonatomic, weak) id<YoutubeDelegate>delegate;

- (void)getLists:(GTMOAuth2Authentication *)authentication;
- (void)getVideo;

@end
