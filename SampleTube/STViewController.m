//
//  STViewController.m
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/26.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "STViewController.h"
#import "YoutubeOAuth.h"
#import "Youtube.h"
#import "GData.h"

@interface STViewController ()<YoutubeDelegate,YoutubeOAuthDelegate>

@end

@implementation STViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0]];
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar setDelegate:self];
    [self.navigationItem setTitleView:searchBar];
    [self.navigationItem.titleView setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:[[self tableViewController] view]];
    
    testTube = [[Youtube alloc] init];
    youtubeOAuth = [[YoutubeOAuth alloc] init];
    [youtubeOAuth setGoogleClientID:@"916411767679.apps.googleusercontent.com"];
    [youtubeOAuth setGoogleClientSecret:@"GNc6nPW20WWO9BCTo_1Zj7Co"];
    [youtubeOAuth setKeychainForName:@"SampleTube"];
    [youtubeOAuth setScope:@"https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/youtube.readonly https://www.googleapis.com/auth/youtube.upload"];
    [youtubeOAuth setDelegate:self];
    [youtubeOAuth signOut];
    [youtubeOAuth signIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark ----- GTMOAuth2ViewControllerTouchDelegateMethod From YoutubeOAuth ----
- (void)viewController:(GTMOAuth2ViewControllerTouch * )viewController finishedWithAuth:(GTMOAuth2Authentication * )auth error:(NSError * )error
{
    NSLog(@"finished");
    NSLog(@"auth access token: %@", auth.accessToken);
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //オーソライズに成功したか、失敗したか。
    if (error != nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Authorizing with Google"
                                                         message:[error localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Success Authorizing with Google"
                                                         message:[error localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
        
        
//        [testTube setPath:[NSURL URLWithString:@"https://www.googleapis.com/youtube/v3/activities?part=id%2Csnippet&mine=true&key=AIzaSyC1AitH7pdRVdCHirT3HkTUfExcDMS0Bpw"]];
        [testTube setPath:[NSURL URLWithString:@"https://www.googleapis.com/youtube/v3/channels?part=id%2Csnippet&id=HCFnuAirTSuOI&mine=true&key=AIzaSyC1AitH7pdRVdCHirT3HkTUfExcDMS0Bpw"]];
        [testTube setDelegate:self];
        [testTube getLists:auth];
    }
}

#pragma mark -
#pragma mark ---- UITableViewDelegateMethod ----
- (void)youtubeOAuth:(YoutubeOAuth *)youtubeOAuth didCreateAuth2ViewControllerTouch:(GTMOAuth2ViewControllerTouch *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (UITableViewController *)tableViewController
{
    if(tableViewController != nil){
        return tableViewController;
    }
    
    tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [tableViewController.view setFrame:self.view.bounds];
    [tableViewController.tableView setDelegate:self];
    [tableViewController.tableView setDataSource:self];
    return tableViewController;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark -
#pragma mark ---- UISearchBarDelegateMethod ----
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark ---- YoutubeDelegate Method ----
- (void)youtube:(Youtube *)youtube didRecieveData:(NSData *)data
{
    NSDictionary *json = [GTMOAuth2Authentication dictionaryWithJSONData:data];
    NSLog(@"確認%@",json);
}

@end
