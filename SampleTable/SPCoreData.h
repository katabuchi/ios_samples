//
//  SPCoreData.h
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/24.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPCoreData : UIViewController<UITextFieldDelegate>
{
    NSString *registName;
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
