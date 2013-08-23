//
//  SPCoreAnimationTestViewController.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/19.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPCoreAnimationTestViewController.h"

@interface SPCoreAnimationTestViewController ()

@end

@implementation SPCoreAnimationTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.navigationItem setTitle:@"CABasicAnimation"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _createView];
}

- (void)_createView
{
    //押したらmoveViewが動くようにボタンを配置
    UIButton *moveButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [moveButton setFrame:CGRectMake((self.view.frame.size.width - moveButton.frame.size.width)/2, (self.view.frame.size.height - moveButton.frame.size.height)/2, moveButton.frame.size.width, moveButton.frame.size.height)];
    [self.view addSubview:moveButton];
    [moveButton addTarget:self action:@selector(_onClickMoveButton:withEvent:) forControlEvents:UIControlEventTouchDown];
    
    //動かす対象を作る
    moveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [moveView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:moveView];    
}

#pragma mark -
#pragma mark ---- onClick Method ----
- (void)_onClickMoveButton:(id)sender withEvent:(UIEvent *)event
{
    //y軸方向に動くアニメーションを作る
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    
    //開始位置を指定
    [basicAnimation setFromValue:[NSNumber numberWithFloat:moveView.frame.origin.y]];
    //移動位置を指定
    [basicAnimation setToValue:[NSNumber numberWithFloat:self.view.frame.size.width]];
    //完了してもアニメーションをリセットしない。ここがないと、最初の位置に戻ってしまう
    [basicAnimation setRemovedOnCompletion:NO];
    [basicAnimation setFillMode:kCAFillModeForwards];
    [basicAnimation setDuration:1.0f];
    //動かす対象にアニメーションを付加する
    [moveView.layer addAnimation:basicAnimation forKey:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
