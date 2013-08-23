//
//  SPCoreMotion.h
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/24.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface SPCoreMotion : UIViewController
{
    CMMotionManager *motionManager;
    UIView *moveView;
}
@end
