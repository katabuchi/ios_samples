//
//  SPViewController.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/19.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPViewController.h"
#import "SPCoreAnimationTestViewController.h"
#import "SPTransitionTestViewController.h"
#import "SPBox2DSampleViewController.h"
#import "Camera.h"
#import "CameraSample.h"
#import "SPPathAnimationViewController.h"
#import "SPCoreMotion.h"
#import "SPCoreData.h"
#import "SPCoreImageViewController.h"
#import "SPRootViewController.h"

@interface SPViewController ()

@end

@implementation SPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self.navigationItem setTitle:@"Samples"];
    self.mainTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.mainTable setDelegate:self];
    [self.mainTable setDataSource:self];
    [self.mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifire"];
    [self.view addSubview:self.mainTable];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mainTable setFrame:self.view.frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ---- UITableViewDelegate ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifire = @"cellIdentifire";
    UITableViewCell *cell = [self.mainTable dequeueReusableCellWithIdentifier:cellIdentifire forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifire];
    }
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row == 0){
                [cell.textLabel setText:@"AVCaptureStillImageOutput"];
            }else if(indexPath.row == 1){
                [cell.textLabel setText:@"AVCaptureVideoDataOutput"];
            }else if(indexPath.row == 2){
                [cell.textLabel setText:@"CoreMotionSample"];
            }else if(indexPath.row == 3){
                [cell.textLabel setText:@"CoreIimageSample"];
            }
        }
            break;
        case 1:
        {
            if(indexPath.row == 0){
                [cell.textLabel setText:@"CoreAnimation"];
            }else if(indexPath.row == 1){
                [cell.textLabel setText:@"CATransition"];
            }else if(indexPath.row == 2){
                [cell.textLabel setText:@"CAKeyFrameAnimation"];
            }else if(indexPath.row == 3){
                [cell.textLabel setText:@"Sample04"];
            }else if(indexPath.row == 4){
                [cell.textLabel setText:@"Sample05"];
            }else if(indexPath.row == 5){
                [cell.textLabel setText:@"Sample06"];
            }else if(indexPath.row == 6){
                [cell.textLabel setText:@"Sample07"];
            }else if(indexPath.row == 7){
                [cell.textLabel setText:@"Sample08"];
            }else if(indexPath.row == 8){
                [cell.textLabel setText:@"Sample09"];
            }else if(indexPath.row == 9){
                [cell.textLabel setText:@"Sample10"];
            }
        }
            break;
        case 2:
        {
            if(indexPath.row == 0){
                [cell.textLabel setText:@"Box2D"];
            }else if(indexPath.row == 1){
                [cell.textLabel setText:@"Core Data"];
            }else if(indexPath.row == 2){
                [cell.textLabel setText:@"ChangeViewController"];
            }else if(indexPath.row == 3){
                [cell.textLabel setText:@"Sample04"];
            }
        }
            break;
        default:
        {
            [cell.textLabel setText:@"テスト"];
        }
            break;
    }
    return cell;
}

//テーブルビューのセルをタップしたとき
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger tapSection = indexPath.section;
    NSInteger tapRow = indexPath.row;
    switch (tapSection) {
        case 0:
            [self _tapCameraSample:tapRow];
            break;
        case 1:
            [self _tapCoreAnimationSample:tapRow];
            break;
        case 2:
            [self _tapBox2DSample:tapRow];
            break;
        default:
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"CameraApp系";
            break;
        case 1:
            return @"CoreAnimation系";
            break;
        default:
            return @"Box2D系";
            break;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //選択状態の解除
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark ---- PrivateMethod ----
- (void)_tapCameraSample:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            Camera *camera = [[Camera alloc] init];
            [appDelegate.navigationController pushViewController:camera animated:YES];
        }
            break;
        case 1:
        {
            CameraSample *cameraSample = [[CameraSample alloc] init];
            [appDelegate.navigationController pushViewController:cameraSample animated:YES];
        }
            break;
        case 2:
        {
            SPCoreMotion *coreMotion = [[SPCoreMotion alloc] init];
            [appDelegate.navigationController pushViewController:coreMotion animated:YES];
        }
        case 3:
        {
            SPCoreImageViewController *coreImageViewControlller = [[SPCoreImageViewController alloc] init];
            [appDelegate.navigationController pushViewController:coreImageViewControlller animated:YES];
        }
        default:
            break;
    }
}

- (void)_tapCoreAnimationSample:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            SPCoreAnimationTestViewController *coreAnimationTestViewController = [[SPCoreAnimationTestViewController alloc] init];
            [appDelegate.navigationController pushViewController:coreAnimationTestViewController animated:YES];
        }
            break;
        case 1:
        {
            SPTransitionTestViewController *coreAnimationTestViewController = [[SPTransitionTestViewController alloc] init];
            [appDelegate.navigationController pushViewController:coreAnimationTestViewController animated:YES];
        }
            break;
        case 2:
        {
            SPPathAnimationViewController *pathAniimationSample = [[SPPathAnimationViewController alloc] init];
            [appDelegate.navigationController pushViewController:pathAniimationSample animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)_tapBox2DSample:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            SPBox2DSampleViewController *box2DSampleViewController = [[SPBox2DSampleViewController alloc] init];
            [appDelegate.navigationController pushViewController:box2DSampleViewController animated:YES];
        }
            break;
        case 1:
        {
            SPCoreData *coreData = [[SPCoreData alloc] init];
            [coreData setManagedObjectContext:appDelegate.managedObjectContext];
            [appDelegate.navigationController pushViewController:coreData animated:YES];
        }
        case 2:
        {
            SPRootViewController *rootViewController = [[SPRootViewController alloc] init];
            [appDelegate.navigationController pushViewController:rootViewController animated:YES];
        }
        default:
            break;
    }
}

@end
