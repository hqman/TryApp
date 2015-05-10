//
//  HWManager.m
//  Try_01
//
//  Created by hqman on 15/5/6.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "HWManager.h"

//#import "STQuestion.h"
NSString *const BASE_URL = @"http://api.stackexchange.com/2.1/";



@implementation HWManager
- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [self setResponseSerializer:[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments    ]];
    }
    return self;
}

+ (instancetype)sharedManager {
    static HWManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [NSURL URLWithString:BASE_URL];
        _sharedManager = [[HWManager alloc] initWithBaseURL:baseURL];
        
    });
    return _sharedManager;
}
//STQuestion *ques = [MTLJSONAdapter modelOfClass:STQuestion.class fromJSONDictionary:JSONDictionary error:&error];
- (RACSignal *)fetchResponseAtPath:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass {
    NSCParameterAssert(path);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task= [self GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
             
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
        
}
             
     @end
