//
//  Camera.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/19.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "Camera.h"
#import "CameraPreviewViewController.h"
#import "SPAppDelegate.h"
#import <ImageIO/ImageIO.h>

@interface Camera ()

@end

@implementation Camera

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setTitle:@"AVCaptureStillImageOutput"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self _createView];
    [self _settingCamera];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [toolBar setFrame:CGRectMake(0, self.view.frame.size.height-45, self.view.frame.size.width, 45)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_session startRunning];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ---- onClickMethod ----
- (void)takePicture:(id)sender withEvent:(UIEvent *)event
{
    SPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //videoコネクションを設定
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if(connection == nil){
        return;
    }
    
    //ビデオ入力から画像出力を非同期で取得。ブロックで定義されている処理が呼び出されて、画像データを取得
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer == NULL){
            return;
        }
        
        //入力された画像データからJPEGフォーマットとしてデータを取得
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        //JPEGデータからUIImageを作成
        self.image = [UIImage imageWithData:imageData];
        //カメラ撮影後のプレビューの部分を作成
        CameraPreviewViewController *cameraPreviewController = [[CameraPreviewViewController alloc] init];
        [cameraPreviewController setImage:_image];
        [appDelegate.navigationController pushViewController:cameraPreviewController animated:YES];
        //セッションストップ
        [_session stopRunning];
        
    }];
}

#pragma mark -
#pragma mark ---- PrivateMethod ----
- (void)_createView
{
    //メインになるイメージビューのとこを作成
    imageView = [[UIImageView alloc] init];
    [imageView setFrame:self.view.bounds];
    [self.view addSubview:imageView];
    
    //撮影ボタンを作成
    toolBar = [[UIToolbar alloc] init];
    [self.view addSubview:toolBar];
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:withEvent:)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[leftItem, cameraButton, rightItem]];
}

- (void)_settingCamera
{
    //セッションの作成
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    NSError *error = nil;
    //デバイスを取得する
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //デバイス入力の取得
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if(!deviceInput){
        
        return;
    }
    
    //メタデータが欲しいからAVCaptureStillImageOutputでデータを取得
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //キャプチャーセッションから入力のプレビューを出力
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    [previewLayer setFrame:self.view.bounds];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //レイヤーをviewに設定
    CALayer *layer = imageView.layer;
    [layer setMasksToBounds:YES];
    [layer addSublayer:previewLayer];
    
    //セッションにインプットとアウトプットを追加
    [_session addInput:deviceInput];
    [_session addOutput:_stillImageOutput];
    
    [_session startRunning];
}

@end
