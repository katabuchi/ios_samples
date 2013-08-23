//
//  SPPathAnimationViewController.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/24.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPPathAnimationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SPPathAnimationViewController ()

@end

@implementation SPPathAnimationViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self _createView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ---- PrivateMethod ----
- (void)_createView
{
    //動かす対象になるViewを生成
    targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [targetView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self.view addSubview:targetView];
}

- (CGMutablePathRef)_createPath
{
    CGMutablePathRef path;
    path = CGPathCreateMutable();
    //初回の位置
    CGPathMoveToPoint(path, NULL, 0.0f, 0.0f);
    
    //一回目の移動での座標
    CGPathAddCurveToPoint(path, NULL, 0.0, 500.0, 120.0, 500.0, 120.0, 500.0);
    //二回目の移動での座標
    CGPathAddCurveToPoint(path, NULL, 120.0, 500.0, 566.0, 500.0, 166.0, 0.0);
    return path;
}

- (void)_movingAction:(UIView *)taeget
{
    //パスを取得
    CGMutablePathRef path = [self _createPath];
    //アニメーションを設定
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyFrameAnimation setDuration:5.0f];
    [keyFrameAnimation setPath:path];
    [keyFrameAnimation setRepeatCount:NSUIntegerMax];
    [keyFrameAnimation setAutoreverses:YES];
    [keyFrameAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [targetView.layer addAnimation:keyFrameAnimation forKey:@"startAnimation"];
}

#pragma mark -
#pragma mark ---- UIGestureRecognizerEvent ----
- (void)tapped:(UITapGestureRecognizer *)gesture
{
    [self _movingAction:targetView];
}

@end
