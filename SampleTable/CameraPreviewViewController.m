//
//  CameraPreviewViewController.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/22.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "CameraPreviewViewController.h"

@interface CameraPreviewViewController ()

@end

@implementation CameraPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self _createView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [imageView setFrame:self.view.frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ---- PrivateMethod ----
- (void)_createView
{
    imageView = [[UIImageView alloc] init];
    [imageView setImage:_image];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imageView];
    
    //決定ボタンを作成
    UIBarButtonItem *useButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(use:withEvent:)];
    [self.navigationItem setRightBarButtonItem:useButton];
}

#pragma mark -
#pragma mark ---- onClickMethod ----
- (void)use:(id)sender withEvent:(UIEvent *)event
{
    UIImageWriteToSavedPhotosAlbum(_image, self, nil, nil);
}

@end
