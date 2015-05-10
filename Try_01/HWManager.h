//
//  HWManager.h
//  Try_01
//
//  Created by hqman on 15/5/6.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@class RACSignal;

@interface HWManager : AFHTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url;

+ (instancetype)sharedManager  ;

- (RACSignal *)fetchResponseAtPath:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass ;
@end

