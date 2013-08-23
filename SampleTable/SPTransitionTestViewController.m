//
//  SPTransitionTestViewController.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/19.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPTransitionTestViewController.h"

@interface SPTransitionTestViewController ()

@end

@implementation SPTransitionTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.navigationItem setTitle:@"CATransition"];
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
    //動かす対象のView
    moveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [moveView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:moveView];
    
    //アニメーションスタートのボタン
    UIButton *animationButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [animationButton setFrame:CGRectMake((self.view.frame.size.width - animationButton.frame.size.width)/2, (self.view.frame.size.height - animationButton.frame.size.height)/2, animationButton.frame.size.width, animationButton.frame.size.height)];
    [self.view addSubview:animationButton];
    [animationButton addTarget:self action:@selector(_onClickStartAnimation:withEvent:) forControlEvents:UIControlEventTouchDown];
}

- (void)_onClickStartAnimation:(id)sender withEvent:(UIEvent *)event
{
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.5f];
    [transition setType:@"cube"];
    [moveView.layer addAnimation:transition forKey:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
