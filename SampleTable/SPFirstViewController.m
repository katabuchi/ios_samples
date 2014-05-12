//
//  SPFirstViewController.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/09/24.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPFirstViewController.h"

@interface SPFirstViewController ()

@end

@implementation SPFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self == [[self.parentViewController childViewControllers] objectAtIndex:0]){
    [self.parentViewController transitionFromViewController:self
                                           toViewController:[[self.parentViewController childViewControllers] objectAtIndex:1]
                                                   duration:1.0f
                                                    options:UIViewAnimationOptionTransitionCurlUp
                                                 animations:^{
                                                     
                                                 } completion:^(BOOL finished) {
                                                     
                                                 }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
