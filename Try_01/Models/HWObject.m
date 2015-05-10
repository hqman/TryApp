//
//  HWObject.m
//  Try_01
//
//  Created by hqman on 15/5/6.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "HWObject.h"

@implementation HWObject


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ };
}


+ (NSString *)keyForJSONAPIContent
{
    return @"";
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[HWObject class]]) {
        HWObject *otherModel = (HWObject *)object;
        return [self.id isEqualToString:otherModel.id];
    }
    return false;
}



+ (instancetype)modelFromJSONDictionary:(NSDictionary *)dictionaryValue
{
    NSError *error = nil;
    id model = [MTLJSONAdapter modelOfClass:self fromJSONDictionary:dictionaryValue error:&error];
    if (error){
        NSLog(@"Error parsing model %@", error);
    }
    
    return model;
}

- (NSDictionary *)JSONDictionary
{
    return  [[MTLJSONAdapter JSONDictionaryFromModel:self error:nil] copy];
    
}

-(void) dealloc{
    NCLog(@"hwobject dealloc...");
}

@end
