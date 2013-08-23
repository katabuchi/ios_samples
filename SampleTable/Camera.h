//
//  Camera.h
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/19.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>

@interface Camera : UIViewController
{
    UIImageView *imageView;
    UIToolbar *toolBar;
}
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@end
