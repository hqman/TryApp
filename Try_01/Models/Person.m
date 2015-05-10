//
//  Person.m
//  Try_01
//
//  Created by hqman on 15/4/25.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "Person.h"

NSString *const PERSON_CONSTANCE=@"VALUE";
NSString *const SaveNotificationKey=@"SaveNotificationKey";
@implementation Person

- (instancetype)initWithName:(NSString *)aname
                         age:(NSUInteger) aage
{
    self = [super init];
    if (self) {
        _name=aname;
        _age=aage;
    }
    return self;

}


- (void)doSomething{
    void (^updateValue) ()=^{
        _name=[NSString stringWithFormat:@"xxx%@",_name];
        NSLog(@"%@",_name);
    };

    updateValue();

}

@end
