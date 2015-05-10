//
//  Person.h
//  Try_01
//
//  Created by hqman on 15/4/25.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWObject.h"
//定义 对外 常量

extern NSString  *const PERSON_CONSTANCE;

extern NSString  *const SaveNotificationKey;

@interface Person : HWObject

@property (strong,nonatomic  ) NSString   * name;

@property (nonatomic,readonly) NSUInteger age;

- (instancetype)initWithName:(NSString *)aname
                         age:(NSUInteger) aage;

- (void)doSomething;
@end
