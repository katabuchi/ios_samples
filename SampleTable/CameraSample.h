//
//  CameraSample.h
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/22.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface CameraSample : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    UIImageView *imageView;
    UIToolbar *toolBar;
}
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIImage *image;
@end
