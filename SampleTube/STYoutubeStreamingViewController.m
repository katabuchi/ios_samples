//
//  STYoutubeStreamingViewController.m
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/29.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "STYoutubeStreamingViewController.h"

@interface STYoutubeStreamingViewController ()

@end

@implementation STYoutubeStreamingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainWebViwe = [[UIWebView alloc] init];
    [mainWebViwe setFrame:self.view.bounds];
    [self.view addSubview:mainWebViwe];
    [self configureView];
    NSLog(@"詳細を調べる%@",self.descriptionString);
}

- (void) displayGoogleVideo:(NSString *)urlString frame:(CGRect)frame
{
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head><body style=\"background:#ffffff;margin-top:0px;margin-left:0px\"><div><param name=\"movie\" value=\"%@\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"%@\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%0.0f\" height=\"%0.0f\"></embed></object></div></body></html>",urlString,urlString,frame.size.width,frame.size.height];
    
    [mainWebViwe loadHTMLString:htmlString baseURL:nil];
}


- (void)configureView
{
    [self displayGoogleVideo:self.videoString frame:CGRectMake(0, 0, 320, 175)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
