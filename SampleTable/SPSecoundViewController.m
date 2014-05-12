//
//  SPSecoundViewController.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/09/24.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPSecoundViewController.h"

@interface SPSecoundViewController ()

@end

@implementation SPSecoundViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"親のビューを確認%@",[[self parentViewController] childViewControllers]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
