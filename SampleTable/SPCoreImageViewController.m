//
//  SPCoreImageViewController.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/25.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPCoreImageViewController.h"
#import "CameraPreviewViewController.h"

@interface SPCoreImageViewController ()

@end

@implementation SPCoreImageViewController

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
    [self _settingCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ---- privateMethod ----
- (void)_createView
{
    imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
}

- (void)_settingCamera
{
    //デバイスの取得
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //デバイスのinputを取得
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if(!deviceInput){
        return;
    }
    
    //セッションにinputを追加
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    [self.session addInput:deviceInput];
    
    //ビデオのアウトプットを作成
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    //ビデオの出力画像を設定
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings setObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:settings];
    
    [videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:videoDataOutput];
    
    [self.session startRunning];
}

- (UIImage *)_imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    //ロック
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    uint8_t *baseAddress;
    size_t width,height,bytePerRow;
    
    baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    width = CVPixelBufferGetWidth(imageBuffer);
    height = CVPixelBufferGetHeight(imageBuffer);
    bytePerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    
    //RGBの色空間
    CGColorSpaceRef colorSpace;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(baseAddress,
                                                 width,
                                                 height,
                                                 8,
                                                 bytePerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    CIImage *inputImage = [CIImage imageWithCGImage:cgImage];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:1.0f] forKey:@"inputIntensity"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *outputImage = filter.outputImage;
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImageRef = [ciContext createCGImage:outputImage fromRect:outputImage.extent];
    
    //UIImageに変換
    UIImage *image = [UIImage imageWithCGImage:cgImageRef scale:1.0 orientation:UIImageOrientationRight];
    
    CGImageRelease(cgImageRef);
    CGImageRelease(cgImage);
    
    return image;
}

- (UIImage *)_addFilter:(UIImage *)image
{
    CIImage *inputImage = [CIImage imageWithCGImage:[image CGImage]];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:1.0f] forKey:@"inputIntensity"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *outputImage = filter.outputImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *reslt = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return reslt;
}

#pragma mark -
#pragma mark ---- AVCaptureVideoDataOutputDelegateMethod ----
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    UIImage *image = [self _imageFromSampleBuffer:sampleBuffer];
//    UIImage *resultImage = [self _addFilter:image];
    dispatch_async(dispatch_get_main_queue(), ^{
        [imageView setImage:image];
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    
    
}


@end
