//
//  SPCoreImageViewController.h
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/25.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>

@interface SPCoreImageViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    UIImageView *imageView;
}
@property (nonatomic, strong) AVCaptureSession *session;
@end
