//
//  SPBox2DSampleViewController.h
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/19.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Box2D/Box2d.h"

#define kPointMeter 16
@interface SPBox2DSampleViewController : UIViewController
{
    b2World *world;
}
@property (nonatomic, assign) NSTimer *timer;
@end
