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
#import "STYoutubeStreamingViewController.h"

@interface STViewController ()<YoutubeDelegate,YoutubeOAuthDelegate>

@end

@implementation STViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0]];
        isEditMode = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar setShowsCancelButton:YES];
    [searchBar setDelegate:self];
    [searchBar setPlaceholder:@"Search..."];
    [self.navigationItem setTitleView:searchBar];
    [self.navigationItem.titleView setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:[[self tableViewController] view]];
    
    youtubeOAuth = [YoutubeOAuth sharedYoutubeOAuth];
    [youtubeOAuth setDelegate:self];
    [youtubeOAuth signIn];
    
    testTube = [[Youtube alloc] init];
    [testTube setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark -
#pragma mark ---- UITableViewDelegateMethod ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [entries count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    STYoutubeStreamingViewController *detailController = [[STYoutubeStreamingViewController alloc] init];
    GDataEntryBase *entry = [entries objectAtIndex:indexPath.row];
    NSString *title = [[entry title] stringValue];
    NSArray *contents = [[(GDataEntryYouTubeVideo *)entry mediaGroup] mediaContents];
    GDataMediaContent *flashContent = [GDataUtilities firstObjectFromArray:contents withValue:@"application/x-shockwave-flash" forKeyPath:@"type"];
    NSString *tempURL = [flashContent URLString];
    NSString *description = [[[(GDataEntryYouTubeVideo *)entry mediaGroup] mediaDescription] contentStringValue];
    [detailController setVideoString:tempURL];
    [detailController setTitleString:title];
    [detailController setDescriptionString:description];
    [detailController setEntryBase:entry];
    [self.navigationController pushViewController:detailController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifire = @"YoutubeCell";
    UITableViewCell *cell = [tableViewController.tableView dequeueReusableCellWithIdentifier:CellIdentifire];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifire];
    }
    GDataFeedBase *entry = [entries objectAtIndex:indexPath.row];
    NSArray *thumnails = [[(GDataEntryYouTubeVideo *)entry mediaGroup] mediaThumbnails];
    NSString *urlString = [[thumnails objectAtIndex:1] URLString];
    NSData *resorce = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    UIImage *image = [UIImage imageWithData:resorce];
    [cell.imageView setImage:image];
    [cell.textLabel setText:[[entry title] stringValue]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [cell.textLabel setNumberOfLines:0];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [entries removeObjectAtIndex:indexPath.row];
        [tableViewController.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -
#pragma mark ---- UISearchBarDelegateMethod ----
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *searchString = [searchBar text];
    [testTube getFeedList:searchString];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark -
#pragma mark ----- YoutubeOAuth DelegateMethod ----
- (void)youtubeOAuth:(YoutubeOAuth *)youtubeOAuth didCreateAuth2ViewControllerTouch:(GTMOAuth2ViewControllerTouch *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)youtubeOAuth:(YoutubeOAuth *)youtubeOAuth didFinishedWithOAuthController:(GTMOAuth2ViewControllerTouch *)viewController authentication:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
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
    }
}

#pragma mark -
#pragma mark ---- YoutubeDelegate Method ----
- (void)youtube:(Youtube *)youtube didRecieveData:(NSData *)data
{
    NSDictionary *json = [GTMOAuth2Authentication dictionaryWithJSONData:data];
    NSLog(@"確認%@",json);
}

- (void)youtube:(Youtube *)youtube didRecieveList:(GDataServiceTicket *)ticket withFeed:(GDataFeedBase *)aFeed error:(NSError *)error
{
    if(error == nil){
        GDataFeedYouTubeVideo *feeds = (GDataFeedYouTubeVideo *)aFeed;
        entries = [[NSMutableArray alloc] init];
        [entries setArray:feeds.entries];
        [tableViewController.tableView reloadData];
    }
}

@end
