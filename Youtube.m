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
#import "GTMOAuth2ViewControllerTouch.h"
#import "GDataEntryYouTubeUpload.h"
#import "YoutubeConfig.h"

@implementation Youtube

- (id)init
{
    if((self=[super init])!=nil){
        
    }
    return self;
}

//youtube再生リスト取得
- (void)getFeedList
{
    GDataServiceGoogleYouTube *service = [self youtubeService];
    NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForFeedID:nil];
    GDataQueryYouTube *query = [GDataQueryYouTube youTubeQueryWithFeedURL:feedURL];
    [query setStartIndex:1];
    [query setMaxResults:8];
    [query setAuthor:@"mototomizou"];
    [query setOrderBy:@"published"];
    [service fetchFeedWithQuery:query
                       delegate:self
              didFinishSelector:@selector(request:finishedWithFeed:error:)
     ];
}

//再生リスト取得後のcallback Method
- (void)request:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedBase *)aFeed error:(NSError *)error {
    [_delegate youtube:self didRecieveList:ticket withFeed:aFeed error:error];
}

//youtubeに動画をアップロード
- (void)upLoadVideoFilePath:(NSString *)movieURL parameters:(NSDictionary *)parameters
{    
    NSString *movieTitleString = [parameters objectForKey:@"title"];
    NSString *movieCategoryString = [parameters objectForKey:@"category"];
    NSString *movieDescriptionString = [parameters objectForKey:@"description"];
    NSString *movieKeywordsString = [parameters objectForKey:@"keyword"];
    
    if([self.authentication canAuthorize]){
        NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:@"default"];
        
        NSString *path = movieURL;
        NSData *data = [NSData dataWithContentsOfFile:path];
        if(!data){
            NSLog(@"投稿出来ない形式 or 選択されていない");
            return;
        }
        
        NSString *fileName = [path lastPathComponent];
        GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:movieTitleString];
        GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:movieCategoryString];
        [category setScheme:kGDataSchemeYouTubeCategory];
        NSArray *categoryArray = @[category];
        
        GDataMediaDescription *description = [GDataMediaDescription textConstructWithString:movieDescriptionString];
        NSArray *keyArray = @[movieKeywordsString];
        GDataMediaKeywords *keywords = [GDataMediaKeywords keywordsWithStrings:keyArray];
        
        BOOL isPrivate = YES;
        
        GDataServiceGoogleYouTube *service = [self youtubeService];
        [service setYouTubeDeveloperKey:kYoutubeDeveloperKey];
        
        GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
        [mediaGroup setMediaTitle:title];
        [mediaGroup setMediaCategories:categoryArray];
        [mediaGroup setMediaDescription:description];
        [mediaGroup setMediaKeywords:keywords];
        [mediaGroup setIsPrivate:isPrivate];
        
        NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:path defaultMIMEType:@"video/mov"];
        
        GDataEntryYouTubeUpload *entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                                                       data:data
                                                                                   MIMEType:mimeType
                                                                                       slug:fileName
                                          ];
        
        SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
        [service setServiceUploadProgressSelector:progressSel];
        GDataServiceTicket *ticket = [service fetchEntryByInsertingEntry:entry
                                                              forFeedURL:url
                                                                delegate:self
                                                       didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)
                                      ];
        
        [self setUpLloadTicket:ticket];
        
        GTMHTTPUploadFetcher *uploadFetcher = (GTMHTTPUploadFetcher *)[ticket objectFetcher];
        [uploadFetcher setLocationChangeBlock:^(NSURL *url) {
            [self setUploadLocationURL:url];
        }];
        
    }else{
        //not Authorize..
    }
}

#pragma mark -
#pragma mark ---- GDataServiceTicket CallBackMethod ----
- (void)uploadTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry error:(NSError *)error
{
    if(error == nil){
        NSLog(@"成功");
    }else{
        NSLog(@"エラー%@",error);
    }
    
    [self setUpLloadTicket:nil];
}

- (void)ticket:(GDataServiceTicket *)ticket hasDeliveredByteCount:(unsigned long long)numberOfBytesRead ofTotalByteCount:(unsigned long long)dataLength
{
    NSLog(@"データ転送中....");
    [_delegate youtube:self recievingDataTicket:ticket hasDeliveredByteCount:numberOfBytesRead ofTotalByteCount:dataLength];
}


- (GDataServiceGoogleYouTube *)youtubeService
{
    static GDataServiceGoogleYouTube *service = nil;
    if(!service){
        service = [[GDataServiceGoogleYouTube alloc] init];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    
    if(self.authentication){
        [service setAuthorizer:self.authentication];
    }else{
        [service setUserCredentialsWithUsername:nil
                                       password:nil
         ];
    }
    
    NSString *devKey =  kYoutubeDeveloperKey;
    [service setYouTubeDeveloperKey:devKey];

    return service;
}


- (void)ticket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed error:(NSError *)error {
    if (error == nil) {
        NSArray *entries = [feed entries];
        if ([entries count] > 0) {
            
            GDataEntryCalendar *firstCalendar = [entries objectAtIndex:0];
            GDataTextConstruct *titleTextConstruct = [firstCalendar title];
            NSString *title = [titleTextConstruct stringValue];
            
            NSLog(@"first movies title: %@", title);
        } else {
            NSLog(@"the user has no calendars");
        }
    } else {
        NSLog(@"fetch error: %@", error);
    }
}



@end
