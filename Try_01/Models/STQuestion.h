//
//  STQuestion.h
//  Try_01
//
//  Created by hqman on 15/5/1.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWObject.h"


typedef NS_ENUM(NSInteger, QuestionType) {
    QuestionType_New,
    QuestionType_Vot,
    QuestionType_Hot
};

@interface STQuestion : HWObject 



@property (nonatomic) NSUInteger postID;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic) NSUInteger score;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy ) NSString *userName;

@property (nonatomic  ) NSUInteger userId;


@property (readwrite, nonatomic, strong) NSDate *created_at;
+(void) loadWithTag:(NSString *) tag andBlock:(void (^)(NSArray *list, NSError *error))block;

+(instancetype) loadWith:(NSUInteger) postID;

+ (instancetype) questionForDictionary:(NSDictionary *)questionDictionary;

+ (RACSignal *)loadWithTagRac:(NSString *)tag;
+(RACSignal *)importQuestionsWithTag:(NSString *) tag;
@end
