//
//  STQuestion.m
//  Try_01
//
//  Created by hqman on 15/5/1.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "STQuestion.h"

#import "NSDate+Common.h"
//#import "ReactiveCocoa.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"

NSString *const HW_BASE_URL = @"http://api.stackexchange.com/2.1/";
NSString *const RSOWebServicesSortType = @"hot";
NSString *const RSOWebServicesSort = @"desc";



@implementation STQuestion
/**
 NSNumber *questionID = questionDictionary[@"question_id"];
 NSNumber *score = questionDictionary[@"score"];
 question.postID = [questionID longValue];
 question.score=[score intValue];
 question.url=questionDictionary[@"link"];
 question.text=questionDictionary[@"title"];

 */

/**
answer_count" = 2;
"creation_date" = 1430436074;
"is_answered" = 0;
"last_activity_date" = 1430442922;
"last_edit_date" = 1430436647;
link = "http://stackoverflow.com/questions/29979404/save-and-load-an-arraylist-under-strings";
*/

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postID": @"question_id",
             @"score": @"score",
             @"url": @"link",
             @"text": @"title",
             @"created_at": @"creation_date",
             @"userId":@"owner.user_id",
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    // Store a value that needs to be determined locally upon initialization.
    _created_at = [NSDate date];
    
    return self;
    
    
}


+ (NSValueTransformer *)created_atJSONTransformer {
    // 1
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    } reverseBlock:^(NSDate *date) {
        return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    }];
}


+ (RACSignal *)loadWithTagRac:(NSString *)tag{
    
    NSURL *baseUrl = [NSURL URLWithString:HW_BASE_URL];
    NSURL  *url = [NSURL URLWithString:[STQuestion createRelativeURLWithTag:tag ] relativeToURL:baseUrl ];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    return [[NSURLConnection rac_sendAsynchronousRequest:request] reduceEach:^id(NSURLResponse *response, NSData *data){
        //NSLog(@"data %@",data);
        return data;
    }];
    
    
    
//    RACSignal *signal =[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSURL *baseUrl = [NSURL URLWithString:BASE_URL];
//        NSURL  *url = [NSURL URLWithString:[STQuestion createRelativeURLWithTag:tag ] relativeToURL:baseUrl ];
//        //NSLog(@"xxxx %@",url);
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSURLSessionTask  *task = [session dataTaskWithURL:url
//                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                    if(error)
//                                                    {
//                                                        [subscriber sendError:error];
//                                                    }
//                                                    else if(!data)
//                                                    {
//                                                      
//                                                        [subscriber sendError:error];
//                                                    }
//                                                    else
//                                                    {
//                                                        NSError *jsonError;
//                                                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
//                                                                                                             options:NSJSONReadingMutableContainers
//                                                                                                               error:&jsonError];
//                                                        
//                                                        if(jsonError)
//                                                        {
//                                                            [subscriber sendError:jsonError];
//                                                        }
//                                                        else
//                                                        {
//                                                            NSMutableArray *questions = [[NSMutableArray alloc]init];
//                                                            for(NSDictionary *questionDictionaryItem in dict[@"items"])
//                                                            {
//                                                                STQuestion *question = [STQuestion questionForDictionary:questionDictionaryItem];
//                                                                [questions addObject:question];
//                                                            }
//                                                            [subscriber sendNext:[questions copy]];
//                                                            [subscriber sendCompleted];
//                                                        }
//                                                    }
//                                                }];
//        
//        [task resume];
//        
//        return [RACDisposable disposableWithBlock:^{
//            [task cancel];
//        }];
//    }];
//    return signal;
}

+(RACSignal *)importQuestionsWithTag:(NSString *) tag{
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

+(void) loadWithTag:(NSString *) tag andBlock:(void (^)(NSArray  *listdata, NSError *error))block{
    NSURL *baseUrl = [NSURL URLWithString:HW_BASE_URL];
    NSURL  *url = [NSURL URLWithString:[STQuestion createRelativeURLWithTag:tag ] relativeToURL:baseUrl ];
    //NSLog(@"xxxx %@",url);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task
    = [session dataTaskWithURL:url
             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                 NSError *jsonError;
                 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                 if(jsonError)
                 {
                     NSLog(@"error ");                 }
                 else
                 {
                     //NSLog(@"%@",dict[@"items"][0]);
                     NSMutableArray *questions = [[NSMutableArray alloc]init];
                     for(NSDictionary *questionDictionaryItem in dict[@"items"])
                     {
                        
                         STQuestion *question = [STQuestion questionForDictionary:questionDictionaryItem];
                         [questions addObject:question];
                     }
                     
                     block([questions copy],jsonError);
                 }
         
             }];
    [task resume];
    
}

+(instancetype) loadWith:(NSUInteger) postID{
    
    STQuestion *sq=[[STQuestion alloc]init];
    
    
    return sq;
}

+ (instancetype ) questionForDictionary:(NSDictionary *)questionDictionary{
    STQuestion *question= [STQuestion new];
    NSNumber *questionID = questionDictionary[@"question_id"];
    NSNumber *score = questionDictionary[@"score"];
    question.postID = [questionID longValue];
    question.score=[score intValue];
    question.url=questionDictionary[@"link"];
    question.text=questionDictionary[@"title"];
    
    
    question.created_at = [NSDate dateWithTimeIntervalSince1970:
                         [[questionDictionary objectForKey:@"creation_date"] doubleValue]];
    return question;
}

- (NSString *)description
{
    //
    //NSLog(@"%@",[self.created_at  stringTimesAgo]);
    
   // NCLog(@"%@",[MTLJSONAdapter JSONDictionaryFromModel:ques error:&error]);
    
     
    
    
    
    return [NSString stringWithFormat:@" %@  ",  [super description]];
}

+  (NSString *)createRelativeURLWithTag:(NSString *)tag
{
    NSString *relativeUrl = [NSString stringWithFormat:@"questions/?site=%@&order=%@&sort=%@%@",
                             @"stackoverflow",
                             RSOWebServicesSort,
                             RSOWebServicesSortType,
                             tag ? [NSString stringWithFormat:@"&tagged=%@", tag] : @""];
    
    return relativeUrl;
}

- (NSString *)path
{
    return @"";
}
@end
