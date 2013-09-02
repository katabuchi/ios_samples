//
//  STPostViewController.h
//  SampleTube
//
//  Created by 片淵 雄介 on 13/08/27.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPostViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *photoView;
    NSString *moviePath;
    UIPopoverController *popController;
    BOOL isShowCamra;
}
@end
