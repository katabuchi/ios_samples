//
//  STPostViewController.m
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/27.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "STPostViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "YoutubeOAuth.h"
#import "Youtube.h"

@interface STPostViewController ()<YoutubeOAuthDelegate>
    
@end

@implementation STPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:1]];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(onClickCameraButton:withEvent:)]];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onClickPostButton:withEvent:)]];
        [self setTitle:@"投稿"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self _createView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createView
{
    CGFloat photoViewAreaWidth = 300;
    CGFloat photoViewAreaHeight = 250;
    CGFloat marginTop = 20;
    
    photoView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-photoViewAreaWidth)/2, marginTop, photoViewAreaWidth, photoViewAreaHeight)];
    [photoView setBackgroundColor:[UIColor blackColor]];
    [photoView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:photoView];
}

- (UIButton *)_createCustomButton:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    [button.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:0.3 green:0.23 blue:0.53 alpha:1.0]];
    [button.layer setCornerRadius:6.0f];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor:[[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] CGColor]];
    return button;
}

- (void)onClickCameraButton:(id)sender withEvent:(UIEvent *)event
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }else{
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setMediaTypes:@[@"public.movie",@"public.image"]];
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        if([popController isPopoverVisible]){
            return;
        }
        popController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [popController presentPopoverFromBarButtonItem:sender
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES
         ];
    }else{        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
}

- (void)onClickPostButton:(id)sender withEvent:(UIEvent *)event
{
    YoutubeOAuth *youtubeOAuth = [YoutubeOAuth sharedYoutubeOAuth];
    [youtubeOAuth setDelegate:self];
    if([youtubeOAuth isLogin]){
        NSLog(@"ログイン済み");
        Youtube *youtube = [[Youtube alloc] init];
        [youtube setAuthentication:[youtubeOAuth authentication]];
        //アップロードするパラメーターを設定しておくところ
        NSDictionary *parameters = @{@"title": @"test",
                                     @"category": @"Sports",
                                     @"description": @"test",
                                     @"keyword": @"test"};
        [youtube upLoadVideoFilePath:moviePath parameters:parameters];
    }else{
        [youtubeOAuth signIn];
    }
}


#pragma mark -
#pragma mark ---- UIImagePickerController DelegateMethod ----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.movie"]){
        NSURL *movieURL = [info objectForKey:UIImagePickerControllerMediaURL];
        moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        AVPlayer *player = [AVPlayer playerWithURL:movieURL];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        [playerLayer setFrame:photoView.bounds];
        [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        [photoView.layer addSublayer:playerLayer];
    }else{
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [photoView setImage:originalImage];
    }
}

#pragma mark -
#pragma mark ---- YoutubeOAuth DelegateMethod ----
- (void)youtubeOAuth:(YoutubeOAuth *)youtubeOAuth didCreateAuth2ViewControllerTouch:(GTMOAuth2ViewControllerTouch *)viewController
{
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (void)youtubeOAuth:(YoutubeOAuth *)youtubeOAuth didFinishedWithOAuthController:(GTMOAuth2ViewControllerTouch *)viewController authentication:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
