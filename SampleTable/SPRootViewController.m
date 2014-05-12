//
//  SPRootViewController.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/09/24.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPRootViewController.h"
#import "SPFirstViewController.h"
#import "SPSecoundViewController.h"

@interface SPRootViewController ()

@end

@implementation SPRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //チャイルドビューコントローラーに追加
    SPFirstViewController *firstViewController = [[SPFirstViewController alloc] init];
    [firstViewController.view setFrame:self.view.bounds];
    SPSecoundViewController *secoundViewController = [[SPSecoundViewController alloc] init];
    [secoundViewController.view setFrame:self.view.bounds];
    [self addChildViewController:firstViewController];
    [self addChildViewController:secoundViewController];
    
    NSLog(@"確認、子供のビューコントローラーの数%@",[self childViewControllers]);
    
    [self.view addSubview:firstViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
