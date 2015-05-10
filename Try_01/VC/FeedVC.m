//
//  FeedVC.m
//  Try_01
//
//  Created by hqman on 15/4/21.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "FeedVC.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "UIImageView+AFNetworking.h"

#import "RACEXTScope.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "HWApi.h"


// 类内部 使用 常量 kXXX 不对外公开

static const NSTimeInterval kAnimationDuration = 0.3;


@interface FeedVC ()
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic,strong) UITextView *mainContent;



@end

@implementation FeedVC

- (void)loadView{
    [super loadView];
    NSLog(@"loadView...." );
}

- (void)viewDidLoad {
     NCLog(@"start viewDidLoad....     ");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加一个 按钮
    
    UIButton *saveButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame=CGRectMake(120, 100, 100, 44);
    [saveButton setTitle:@" save something" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    [NSThread sleepForTimeInterval:1];
    NCLog(@"viewDidLoad....     ");
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40, 50)];
    _indicator.frame=CGRectMake(50  , 50, 50, 40);
    _indicator.backgroundColor = [UIColor grayColor];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_indicator startAnimating];
    [self.view addSubview:_indicator];
    
    
    _mainContent= [[UITextView alloc]initWithFrame:CGRectMake(100, 200, 200, 200)];
    _mainContent.text = @"HELLO";
    _mainContent.backgroundColor=[UIColor grayColor];
    _mainContent.textColor = [UIColor blackColor];
    [self.view addSubview:_mainContent];
    
    
//    @weakify(self);
//    RACSignal *responseSignal=[[HWManager sharedManager] getQuestionsWithTag:@"ios"];
//                           
//    [responseSignal subscribeNext:^(id x) {
//         NCLog(@"response %@",x);
//    }error:^(NSError *error) {
//        NCLog(@"error");
//        [_indicator stopAnimating];
//    }completed:^{
//        NCLog(@"completed");
//        [_indicator stopAnimating];
//    }];
    
    //@weakify(self);
    RACSignal *listSignal=[[HWManager sharedManager] importQuestionsWithTag:@"ios"];
    [listSignal subscribeNext:^(NSArray  *qes) {
        //@strongify(self);
        //[self loadQuestions:qes];
    }error:^(NSError *error) {
        NCLog(@"error");
              [_indicator stopAnimating];

    } completed:^{
        NCLog(@"completed");
        [_indicator stopAnimating];
    }];
//    RACSignal *textSignal=[self.mainContent rac_textSignal];
//    [textSignal subscribeNext:^(id x)   {
    //         NSLog(@"completed" );

//    }completed:^{
//        NSLog(@"completed" );
//    }];
    
    RACSignal *textSignal=[self.mainContent rac_textSignal];
    
    
    
    
    // filter 用法 过滤值
    RACSignal *filteredSignal=[textSignal filter:^BOOL(id value) {
//        NSLog(@"x  is %@",x );
        NSString *text=(NSString *)value;
        return text.length>3;
    }  ];
    
//    [filteredSignal subscribeNext:^(id x) {
//        NSLog(@"x  is %@",x );
//    }];
    // map 用法 转移值
    RACSignal *length_signal=[[textSignal map:^id(NSString *text) {
        return @([self validText:text]);
    }  ]distinctUntilChanged];
    //distinctUntilChanged  当 length_signal 值改变时候 才触发
    [length_signal subscribeNext:^(id x) {
        NSLog(@"x  is %@",x );
    }];
    
     
    
    //rac 宏  指定 一个 signal 发生时候 设置 视图的 属性
    RAC(self.mainContent ,backgroundColor)=[length_signal map:^id(NSNumber *valid) {
        
         NSLog(@"x  is %@",valid );
        if (valid.intValue>0) {
            return [UIColor yellowColor];
        }else{
            return [UIColor grayColor  ];
        }
    }];
    
//    [length_signal subscribeNext:^(id x) {
//        NSLog(@"x  is %@",x );
//    }];
    


}

-(NSInteger) validText:(NSString *) text{
    if (text.length>10) {
        return 1;
    }else{
        return 0;
    }
}

-(void)loadQuestions:(NSArray *)ques{
     NCLog(@"%@,%lu",ques,[ques count]);
}

-(void) save:(UIButton *)sender {
    NSLog(@"save user defualt...." );
    NSLog(@"A_D DEFINE %f",FANIMATION_DURATION);
    NSLog(@"PERSON CONSTANCE %@",PERSON_CONSTANCE);
    NSUserDefaults *nd=[NSUserDefaults standardUserDefaults];
    
    [nd setObject:@"hqmank@gmail.com" forKey:@"name"];
    NSDictionary *udict=@{@"username":@"Wangka2i",@"age":@33};
     [nd setObject:udict forKey:@"userdict"]  ;
    
    NSDictionary *factorySettings = @{@"FavoriteGreeting": @"Hey!",@"HoursBetweenMothershipConnection" : @2};
    [nd registerDefaults:factorySettings];
                                     
    [nd synchronize];
    
    
    NSString *homeDirectory = NSHomeDirectory();
    NSLog(@"path:%@", homeDirectory);
    
    [factorySettings writeToFile:[NSString stringWithFormat:@"%@/%@",homeDirectory,@"test.plist"] atomically:YES];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"path:%@", path);
    // [[self rdv_tabBarController] setTabBarHidden:!self.rdv_tabBarController.tabBarHidden animated:YES];
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:SaveNotificationKey object:@"hqman"];
//   //[self performSelectorInBackground:@selector(backWork) withObject:nil];
//    //sleep(5);
//    NSBlockOperation *op=[NSBlockOperation blockOperationWithBlock:^{
//        NCLog(@"NSBlockOperation xxx....");
//         sleep(5);
//        [self performSelectorOnMainThread:@selector(mainWork) withObject:nil waitUntilDone:NO];
//    }];
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [queue addOperation:op];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NCLog(@"dispatch_async xxx....");
        [self.indicator startAnimating];

                 sleep(5);
        dispatch_async(dispatch_get_main_queue(), ^{
             [self  mainWork];
            [self.indicator stopAnimating];

        });
    });
    //[self.indicator startAnimating];
}

-(void) backWork{
    NCLog(@"background thread %@",[NSThread currentThread]);
    
    sleep(5);
    //back to run main thread selector
    [self performSelectorOnMainThread:@selector(mainWork) withObject:nil waitUntilDone:NO];
}


-(void) mainWork{
    NCLog(@"main  thread %@",[NSThread currentThread]);
[self.indicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Feed";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated    {
      [[self rdv_tabBarController] setTabBarHidden: NO animated:YES];
     NSLog(@"viewWillAppear....     ");
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear....     ");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
