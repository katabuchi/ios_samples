//
//  SPCoreMotion.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/24.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPCoreMotion.h"

@interface SPCoreMotion ()

@end

@implementation SPCoreMotion

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view.
    [self _createContents];
    [self _settingCoreMotion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ---- PrivateMethod ----
- (void)_settingCoreMotion
{
    motionManager = [[CMMotionManager alloc] init];
    [motionManager setAccelerometerUpdateInterval:0.1f];
    if(motionManager.isAccelerometerAvailable){
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            double x = accelerometerData.acceleration.x*100;
            double y = accelerometerData.acceleration.y*100;
            double z = accelerometerData.acceleration.z*100;
            CGFloat posX = self.view.frame.size.width/2 + x;
            CGFloat posY = self.view.frame.size.height/2 - y;
            CGFloat contentsSize = 100 - z;
            CGRect rect = moveView.frame;
            rect.size = CGSizeMake(contentsSize, contentsSize);
            [UIView animateWithDuration:0.1f animations:^{
                moveView.frame = rect;
                [moveView setCenter:CGPointMake(posX, posY)];
            }];
        }];
    }
}

- (void)_createContents
{
    //動かすオブジェクトを配置しておく
    moveView = [[UIView alloc] init];
    [moveView setBackgroundColor:[UIColor blackColor]];
    [moveView setFrame:CGRectMake(0, 0, 100, 100)];
    [moveView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [self.view addSubview:moveView];
}

@end
