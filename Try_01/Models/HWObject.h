//
//  HWObject.h
//  Try_01
//
//  Created by hqman on 15/5/6.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/Mantle.h>

@interface HWObject :   MTLModel <MTLJSONSerializing>


- (BOOL)isEqual:(id)object;

/**
 The unique identifier assigned to this model.
 */
@property (nonatomic, copy) NSString *id;

/**
 the base url for this model object
 */
@property (nonatomic) NSURL *baseURL;


@property (nonatomic, readonly) NSString *path;

+ (NSString *)keyForJSONAPIContent;

/**
 Convenience method for instantiating class from a JSON dictionary.
 json --> model object
 */
+ (instancetype)modelFromJSONDictionary:(NSDictionary *)dictionaryValue;

/**
 Convenience method for turning model into JSON dictionary.
 self->json
 */
- (NSDictionary *)JSONDictionary;

@end
