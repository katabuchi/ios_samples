//
//  CameraSample.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/22.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "CameraSample.h"
#import "CameraPreviewViewController.h"
#import "SPAppDelegate.h"

@interface CameraSample ()

@end

@implementation CameraSample

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:@"AVCaptureVideoDataOutput"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _createView];
    [self _sessingCamera];
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
#pragma mark ---- PrivateMethod ----
- (void)_sessingCamera
{
    //デバイスを取得
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    //インプットを取得
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if(!deviceInput){
        return;
    }
    //アウトプット情報を設定
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings setObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVCaptureVideoDataOutput *dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [dataOutput setVideoSettings:settings];
    [dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    //セッションを作成
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetPhoto];
    [_session addInput:deviceInput];
    [_session addOutput:dataOutput];
    
    [_session startRunning];
}

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

#pragma mark -
#pragma mark ----- onClickMethod ----
- (void)takePicture:(id)sender withEvent:(UIEvent *)event
{
    SPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    CameraPreviewViewController *cameraPreviewController = [[CameraPreviewViewController alloc] init];
    [cameraPreviewController setImage:_image];
    [appDelegate.navigationController pushViewController:cameraPreviewController animated:YES];
    //セッションストップ
    [_session stopRunning];
}

#pragma mark -
#pragma mark ---- AVCaptureVideoDataOutputSampleBufferDelegate ----
- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    //イメージバッファのロック
    CVPixelBufferLockBaseAddress(buffer, 0);
    
    //イメージバッファ情報の取得
    u_int8_t *base;
    size_t width,height,bytesPerRow;
    base = CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    //ビットマップコンテキストの作成
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    //画像の作成
    CGImageRef cgImage;
    UIImage *image;
    cgImage = CGBitmapContextCreateImage(context);
    image = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationRight];
    
    CGImageRelease(cgImage);
    CGContextRelease(context);
    
    //イメージバッファのアンロック
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    //画像の表示
    _image = image;
    [imageView setImage:_image];
}

@end
