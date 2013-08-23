//
//  SPCoreData.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/24.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPCoreData.h"
#import "Customer.h"

@interface SPCoreData ()

@end

@implementation SPCoreData

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    [self _settingCoreData];
    [self _createView];
    [self _fetchCoreData];
}

//CoreDataに情報を登録するところ
- (void)_settingCoreData
{
    Customer *customer = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Customer class]) inManagedObjectContext:_managedObjectContext];
    [customer setName:registName];
    [customer setAge:23];    
    NSError *error = nil;
    if(![_managedObjectContext save:&error]){
        NSLog(@"エラー%@",error);
        abort();
    }
    
    NSLog(@"ローカルホストにあるものを追加した感じ");
}

//CoreDataの情報を取得するところ
- (void)_fetchCoreData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    //検索結果を保持する順番
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    if(![fetchedResultsController performFetch:&error]){
        NSLog(@"エラー%@",error);
    }
    NSArray *moArray = [fetchedResultsController fetchedObjects];
    for(int i=0; i<[moArray count]; i++){
        Customer *customer = [moArray objectAtIndex:i];
        NSLog(@"確認情報%@",[customer name]);
    }
    NSLog(@"登録している個数 -> %d",[moArray count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createView
{
    CGFloat textFieldWidth = 100;
    CGFloat textFieldHeight = 50;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width - textFieldWidth)/2, 100, textFieldWidth, textFieldHeight)];
    [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [textField setBorderStyle:UITextBorderStyleBezel];
    [textField setDelegate:self];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addButton setFrame:CGRectMake((self.view.frame.size.width - addButton.frame.size.width)/2, textField.frame.size.height + textField.frame.origin.y + 10, addButton.frame.size.width, addButton.frame.size.height)];
    [addButton addTarget:self action:@selector(onClickAddButton:withEvent:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:textField];
    [self.view addSubview:addButton];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    registName = textField.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *text = [textField.text mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    registName = text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)onClickAddButton:(id)sender withEvent:(UIEvent *)event
{
    [self _settingCoreData];
}


@end
