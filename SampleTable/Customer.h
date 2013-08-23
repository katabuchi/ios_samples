//
//  Customer.h
//  SampleTable
//
//  Created by 片淵 雄介 on 13/08/20.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Customer : NSManagedObject

@property (nonatomic) int32_t age;
@property (nonatomic, retain) NSString * name;

@end
