//
//  STYoutubeStreamingViewController.m
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/29.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "STYoutubeStreamingViewController.h"
#import "GData.h"

@interface STYoutubeStreamingViewController ()

@end

@implementation STYoutubeStreamingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onClickAddButton:withEvent:)]];
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
}

- (void) displayGoogleVideo:(NSString *)urlString frame:(CGRect)frame
{
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head><body style=\"background:#000000;margin-top:%0.0fpx;margin-left:0px\"><div><param name=\"movie\" value=\"%@\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"%@\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"%0.0f\" height=\"%0.0f\"></embed></object></div></body></html>",frame.origin.y,urlString,urlString,frame.size.width,frame.size.height];
    [mainWebViwe loadHTMLString:htmlString baseURL:nil];
}


- (void)configureView
{
    CGFloat rate = 175.0f/320.0f;
    CGFloat videoWidth = self.view.frame.size.width;
    CGFloat videoHeight = self.view.frame.size.width*rate;
    CGFloat centerPosY = (self.view.frame.size.height - videoHeight)/2 - 44;
    [self displayGoogleVideo:self.videoString frame:CGRectMake(0, centerPosY, videoWidth, videoHeight)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickAddButton:(id)sender withEvent:(UIEvent *)event
{
    
}

@end
