//
//  Try_01Tests.m
//  Try_01Tests
//
//  Created by hqman on 15/4/21.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "STQuestion.h"
#import "NSString+Common.h"
#import "HWApi.h"



@class RACSignal;

NSString *const BASE_URL = @"http://api.stackexchange.com/2.1/";
NSString *const RSOWebServicesSortType = @"hot";
NSString *const RSOWebServicesSort = @"desc";
@interface Try_01Tests : XCTestCase

@end

@implementation Try_01Tests


- (NSString *)createRelativeURLWithTag:(NSString *)tag
{
    NSString *relativeUrl = [NSString stringWithFormat:@"questions/?site=%@&order=%@&sort=%@%@",
                             @"stackoverflow",
                             RSOWebServicesSort,
                             RSOWebServicesSortType,
                             tag ? [NSString stringWithFormat:@"&tagged=%@", tag] : @""];
    
    return relativeUrl;
}


- (void)setUp {
    
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    setenv("XcodeColors", "YES", 0);
    
    // Standard lumberjack initialization
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // And then enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    // Check out default colors:
    // Error : Red
    // Warn  : Orange
    
    UIColor *green = [UIColor colorWithRed:0.165 green:0.734 blue:0.301 alpha:1.000];
    
    
    
    [[DDTTYLogger sharedInstance] setForegroundColor:green backgroundColor:nil forFlag:DDLogFlagInfo];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testRAC_stream {
    NCLog(@"testRAC_stream" );
    NSArray *list=@[@1,@2,@3];
    RACSequence *slist=[list rac_sequence];
    
    slist=[slist map:^id(id value) {
        return @(pow([value integerValue], 2));
    } ];
    
    NCLog(@"slist %@",[slist array]);
    
    NSArray *array=@[@(1),@(2),@(3)];
    
    RACSequence *sarray=[array rac_sequence];
    
    
    NSNumber *sum=[sarray foldLeftWithStart:@1 reduce:^id(id accumulator, id value) {
        return @([accumulator integerValue] + [value integerValue]);
    }];
    
    NCLog(@"foldLeftWithStart %@",sum);
    XCTAssert(YES, @"Pass");
}

- (void)testSQ_loadWithTag_RAC{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"HTTP request"];
    
    RACSignal *signal=   [STQuestion importQuestionsWithTag:@"java"];
    
    [signal subscribeNext:^(id x) {
        NCLog(@"x  is %@",x );
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
    XCTAssert(YES, @"Pass");
    
}


- (void)testSQ_RAC{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"HTTP request"];
    
    RACSignal *signal=  [ [HWManager sharedManager] getQuestionsWithTag:@""];
    
    [signal subscribeNext:^(id x) {
        NSDictionary *dictt=x;
        NCLog(@"x  is %@",dictt[@"items"]
              );
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
    XCTAssert(YES, @"Pass");
    
}
- (void)testSQ_mantle {
    
    /**{
     "answer_count" = 2;
     "creation_date" = 1430779867;
     "is_answered" = 1;
     "last_activity_date" = 1430799534;
     "last_edit_date" = 1430799534;
     link = "http://stackoverflow.com/questions/30041332/a-useful-metric-for-determining-when-the-jvm-is-about-to-get-into-memory-gc-trou";
     owner =     {
     "accept_rate" = 83;
     "display_name" = "Arne Claassen";
     link = "http://stackoverflow.com/users/32577/arne-claassen";
     "profile_image" = "https://www.gravatar.com/avatar/bd7129fd7971ef0cae9749d5638742e1?s=128&d=identicon&r=PG";
     reputation = 3599;
     "user_id" = 32577;
     "user_type" = registered;
     };
     "question_id" = 30041332;
     score = 4;
     tags =     (
     java,
     scala,
     "garbage-collection",
     jvm
     );
     title = "A useful metr2015-05-05 12:44:34.877 Try_01[18814:229642] creat:2015-05-05 04:44:34 +0000   now:2015-05-05 04:44:34 +0000
     ic for determining when the JVM is about to get into memory/GC trouble";
     "view_count" = 43;
     }*/
    NSError *error = nil;
    NSDictionary *JSONDictionary=@{ @"creation_date" : @1430779867,@"title":@"test java",@"link":@"http://stackoverflow.com/users/32577/arne-claassen",
                                    @"score":@2,
                                    @"question_id":@1231,
                                    @"owner": @{ @"user_id": @1212 }
                                    };
    STQuestion *ques = [MTLJSONAdapter modelOfClass:STQuestion.class fromJSONDictionary:JSONDictionary error:&error];
    NCLog(@"userId %lu",ques.userId);
    NCLog(@"%@",[MTLJSONAdapter JSONDictionaryFromModel:ques error:&error]);
    
}


- (void)testSQ_loadWithTag {
    // This is an example of a functional test case.
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"HTTP request"];
    
    
    [STQuestion loadWithTag:@"ios" andBlock:^(NSArray *list, NSError *error) {
        
        if(error)
        {
            NSLog(@"error %@",error);                 }
        else
        {
            NSLog(@"%@,%lu",list,[list count]);
            
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
    XCTAssert(YES, @"Pass");
}

- (void)test2 {
    // asynchronous block callback was called expectation
    XCTestExpectation *expectation = [self expectationWithDescription:@"HTTP request"];
    
    // setup asynchronous block callback
    
    NSURL *baseUrl = [NSURL URLWithString:BASE_URL];
    
    NSURL  *url = [NSURL URLWithString:[self createRelativeURLWithTag:@"java"] relativeToURL:baseUrl ];
    NSLog(@"xxxx %@",url);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task
    = [session dataTaskWithURL:url
             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                 /* fulfill asynchronous block callback was called expectation
                  causes -waitForExpectationsWithTimeout:handler: to stop waiting */
                 
                 NSError *jsonError;
                 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                 
                 if(jsonError)
                 {
                     NSLog(@"error ");                 }
                 else
                 {
                     NSLog(@"%@",dict[@"items"]);
                 }
                 
                 
                 [expectation fulfill];
             }];
    
    // call asynchronous method
    [task resume];
    
    /* wait for the asynchronous block callback was called expectation to be fulfilled
     fail after 5 seconds */
    [self waitForExpectationsWithTimeout:5
                                 handler:^(NSError *error) {
                                     // handler is called on _either_ success or failure
                                     if (error != nil) {
                                         XCTFail(@"timeout error: %@", error);
                                     }
                                 }];
    //__unused NSArray *a=@[@1,@2,ob];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)test_Sha1 {
    NSString *password=@"wangkai";
    NCLog(@"sha is %@",[password sha1Str]);
    XCTAssert(  [[password sha1Str] isEqualToString:@"4d89b5b19a94dbad54f36608831ed758d319ef1b" ]  , @"Pass");
}

@end
