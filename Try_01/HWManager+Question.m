//
//  HWManager+Question.m
//  Try_01
//
//  Created by hqman on 15/5/6.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "HWManager+Question.h"
#include "STQuestion.h"
@implementation HWManager (Question)



-(RACSignal *)importQuestionsWithTag:(NSString *) tag{
    return [[[[[STQuestion loadWithTagRac:tag] deliverOn:[RACScheduler mainThreadScheduler]] map:^id(NSData *data) {
        id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        return [[[results[@"items"] rac_sequence] map:^id(NSDictionary *qDictionary ) {
            
            //STQuestion *question = [STQuestion classForParsingJSONDictionary:qDictionary];
            //NCLog(@"%@",qDictionary);
            NSError *error = nil;
            STQuestion *question = [MTLJSONAdapter modelOfClass:STQuestion.class fromJSONDictionary:qDictionary error:&error];
            return question;
            
        }] array];
    }] publish] autoconnect];
}

//todo 利用AFN 来实现 api 调用

-(RACSignal *)getQuestionsWithTag:(NSString *) tag{
    
    NSDictionary* parameters = @{
                                 @"site":@"stackoverflow",
                                 @"order":@"desc",
                                 @"sort":@"hot",
                                 @"tagged":tag
                                 };
    RACSignal *signal=[self fetchResponseAtPath:@"questions/" parameters:parameters modelClass:nil];
    return signal; // 转 dict -> array 1：转换 2：传递 返回
    
}


@end
