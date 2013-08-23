//
//  CameraPreviewViewController.h
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/22.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraPreviewViewController : UIViewController
{
    UIImageView *imageView;
}
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDictionary *metaData;
@end
