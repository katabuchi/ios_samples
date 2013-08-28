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

@implementation Youtube

- (id)init
{
    if((self=[super init])!=nil){
        
    }
    return self;
}

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

- (void)readList
{
    GDataServiceGoogleYouTube *service = [[GDataServiceGoogleYouTube alloc] init];
    NSURL *feedURL = [GDataServiceGoogleYouTube youTubeURLForFeedID:nil];
    GDataQueryYouTube *query = [GDataQueryYouTube youTubeQueryWithFeedURL:feedURL];
    [query setStartIndex:1];
    [query setMaxResults:8];
//    [query setAuthor:@"ppcmaster100"];
    [query setOrderBy:@"published"];
    [service fetchFeedWithQuery:query delegate:self didFinishSelector:@selector(request:finishedWithFeed:error:)];
}

- (void)request:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedBase *)aFeed error:(NSError *)error {
    [_delegate youtube:self didRecieveList:ticket withFeed:aFeed error:error];
}

- (void)upLoadVideoFilePath:(NSString *)movieURL parameters:(NSDictionary *)parameters
{
    NSString *movieTitleString = [parameters objectForKey:@"title"];
    NSString *movieCategoryString = [parameters objectForKey:@"category"];
    NSString *movieDescriptionString = [parameters objectForKey:@"description"];
    NSString *movieKeywordsString = [parameters objectForKey:@"keyword"];
    
    /*
     ここでもしパラーメータが一つでもnilになってた場合は、どうやって条件分岐するのがベストなのか。
     ex)ifで分岐してネスト。関数を切り分ける。変数を使う直前でnilかどうかをチェックする。最初にnilチェックをする。
     ex)三項演算子で代入とか。[GDataMediaTitle textConstructWithString:movieTitleString?movieTitleString:@"noTitle"];
    */
    
    if([self.authentication canAuthorize]){
        NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:@"default"];
        NSLog(@"URLの情報%@",url);
        NSString *path = [[NSBundle mainBundle] pathForResource:movieURL ofType:@"mov"];
        NSData *data = [NSData dataWithContentsOfMappedFile:path];
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
                                                                                       slug:fileName];
        
        SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
        [service setServiceUploadProgressSelector:progressSel];
        
        GDataServiceTicket *ticket = [service fetchEntryByInsertingEntry:entry
                                                              forFeedURL:url
                                                                delegate:self didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
        [self setUpLloadTicket:ticket];
        
        GTMHTTPUploadFetcher *uploadFetcher = (GTMHTTPUploadFetcher *)[ticket objectFetcher];
        [uploadFetcher setLocationChangeBlock:^(NSURL *url) {
            [self setUploadLocationURL:url];
        }];
        
    }else{
        //not Authorize..
    }
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


#pragma mark -
#pragma mark ---- GDataServiceTicket CallBackMethod ----
- (void)uploadTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry error:(NSError *)error
{
    if(error == nil){
        NSLog(@"notエラー%@",error);
    }else{
        NSLog(@"エラー%@",error);
    }
    
    [self setUpLloadTicket:nil];
}

@end
