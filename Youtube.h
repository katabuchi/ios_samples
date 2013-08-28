//
//  Youtube.h
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/26.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GData,Youtube, GTMOAuth2Authentication, GDataServiceTicket, GDataServiceGoogleYouTube, GDataFeedBase;
@protocol YoutubeDelegate <NSObject>
@optional
- (void)youtube:(Youtube *)youtube didRecieveData:(NSData *)data;
- (void)youtube:(Youtube *)youtube didRecieveList:(GDataServiceTicket *)ticket withFeed:(GDataFeedBase *)aFeed error:(NSError *)error;
@end

@interface Youtube : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData *receiveData;
}

@property (nonatomic, strong) NSURL *path;
@property (nonatomic, weak) id<YoutubeDelegate>delegate;
@property (nonatomic, strong) GTMOAuth2Authentication *authentication;
@property (nonatomic, strong) GDataServiceTicket *upLloadTicket;
@property (nonatomic, strong) GDataServiceGoogleYouTube *youtubeService;
@property (nonatomic, strong) NSURL *uploadLocationURL;

- (void)getLists:(GTMOAuth2Authentication *)authentication;
- (void)getVideo;
- (void)upLoadVideoFilePath:(NSString *)movieURL parameters:(NSDictionary *)parameters;
- (void)readList;

- (void)upLoadVideo:(NSString *)path;


@end
