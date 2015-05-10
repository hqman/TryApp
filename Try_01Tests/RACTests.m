//
//  RACTests.m
//  TryApp
//
//  Created by hqman on 15/5/7.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "STQuestion.h"
#import "NSString+Common.h"
#import "HWApi.h"

@interface RACTests : XCTestCase

@end

@implementation RACTests

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
    NCLog(@"testRAC_stream" );
    NSArray *list=@[@1,@2,@3];
    NSArray *list2=@[@4,@5,@6];

    RACSequence *slist=[list rac_sequence];
    
    
    NCLog(@"foldLeftWithStart %@",[slist foldLeftWithStart:@0 reduce:^id(id accumulator, id value) {
        return @([accumulator integerValue] + [value integerValue]);
    }]);
    
    RACSequence *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence;
    RACSequence *numbers = [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence;
    RACSequence *sequenceOfSequences = @[ letters, numbers ].rac_sequence;
    
    // Contains: A B C D E F G H I 1 2 3 4 5 6 7 8 9
    RACSequence *flattened = [sequenceOfSequences flatten];
    
//    NCLog(@"%@", [flattened array] );
    
    
    
    
    
//    slist=[slist map:^id(id value) {
//        return @(pow([value integerValue], 2));
//    } ];
//    
//    NCLog(@"slist %@",[slist array]);
//    
//    NSArray *array=@[@(1),@(2),@(3)];
//    
//    RACSequence *sarray=[array rac_sequence];
//    
//    
//    NSNumber *sum=[sarray foldLeftWithStart:@1 reduce:^id(id accumulator, id value) {
//        return @([accumulator integerValue] + [value integerValue]);
//    }];
//    
//    NCLog(@"foldLeftWithStart %@",sum);

    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testSignal_Subscribe {
    __block unsigned subscriptions = 0;
    //定义 了一个 信号 为一个变量 值的改变
    RACSignal *loggingSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        subscriptions++;
        [subscriber sendCompleted];

        [subscriber sendNext:@(subscriptions)];
        [subscriber sendError:nil];
               return nil;
    } ];
    
    //注射 一些 信号 发生 前后的 拦截方法
//    loggingSignal =[loggingSignal initially:^{
//        NCLog(@"initially subscription %u", subscriptions);
//    }];
//    
//    // Does not output anything yet
//    loggingSignal = [loggingSignal doCompleted:^{
//        NCLog(@"about to complete subscription %u", subscriptions);
//    }];
    
     //Outputs:
     //about to complete subscription 1
    // subscription 1
        [loggingSignal subscribeCompleted:^{
            NCLog(@"subscribeCompleted is %u", subscriptions);
        }];
    
    NCLog(@"---------------  " );

    [loggingSignal subscribeNext:^(id x) {
        NCLog(@"subscribeNext subscription %u", subscriptions);
    } error:^(NSError *error) {
        NCLog(@"subscriptions error  " );
    } completed:^{
        NCLog(@"subscriptions completed  " );
    }];
    
    RACSignal *letters = @[@"A",@"B",@"C" ].rac_sequence.signal;
    //输出：A B C D E F G H I
    [letters subscribeNext:^(NSString *x){
        NCLog(@"%@",x);
    } error:^(NSError *error) {
        NCLog(@"subscriptions error  " );
    } completed:^{
        NCLog(@"subscriptions completed  " );
    }];

    
}

- (void)testSignal_Subject {
    RACSubject *letter=[RACSubject subject];
    
    RACSignal *signal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:letter];
        [subscriber sendCompleted];
        return nil;
    }];
    
    
    [signal subscribeNext:^(id x) {
        NCLog(@"letter is %@",x);
    }];
    
    [letter sendNext:@"A"];
    [letter sendNext:@"B"];
    [letter sendNext:@"C"];

 
}

-(void) test_Sequncing{
    RACSignal *letters = [@"A B C D E F G H I" componentsSeparatedByString:@" "].rac_sequence.signal;
    
    // 新水龙头只包含: 1 2 3 4 5 6 7 8 9
    //
    // 但当有接收时，仍会执行旧水龙头doNext的内容，所以也会输出 A B C D E F G H I
    RACSignal *sequenced = [[letters
                             doNext:^(NSString *letter) {
                                 NCLog(@"%@", letter);
                             }]
                            then:^{
                                return [@"1 2 3 4 5 6 7 8 9" componentsSeparatedByString:@" "].rac_sequence.signal;
                            }];
//     [sequenced subscribeNext:^(id x) {
//        NCLog(@"x is %@",x);
//        }];
}

-(void) test_combine{
    RACSubject *letters = [RACSubject subject];
    RACSubject *numbers = [RACSubject subject];
    RACSignal *combined = [RACSignal
                           combineLatest:@[ letters, numbers ]
                           reduce:^(NSString *letter, NSString *number) {
                               return [letter stringByAppendingString:number];
                           }];
    
    // Outputs: B1 B2 C2 C3
    [combined subscribeNext:^(id x) {
        NCLog(@"%@", x);
    }];
    
    [letters sendNext:@"A"];
    [letters sendNext:@"B"];
   // [numbers sendNext:@"1"];
    [numbers sendNext:@"2"];
    [letters sendNext:@"C"];
    [numbers sendNext:@"3"];
    
    [letters sendNext:@"A"];
    
    [letters sendNext:@"A"];
}

-(void) test_lazy{
    NSArray *strings = @[ @"A", @"B", @"C" ];
    RACSequence *sequence = [strings.rac_sequence map:^(NSString *str) {
        return [str stringByAppendingString:@"_"];
    }];
    
    
    NCLog(@"%@",[sequence eagerSequence]);
}

@end
