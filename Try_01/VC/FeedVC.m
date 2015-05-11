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
#import "UIActionSheet+Common.h"
#import "HWApi.h"

#import "Masonry.H"

#import "ListVC.h"
// 类内部 使用 常量 kXXX 不对外公开

static const NSTimeInterval kAnimationDuration = 0.3;

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface FeedVC ()
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@property (nonatomic,strong) UITextView *mainContent;
@property (nonatomic,strong) UITextView *mainContent2;




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
    
    
    //_mainContent= [[UITextView alloc]initWithFrame:CGRectMake(100, 200, 200, 200)];
    _mainContent=  [UITextView new];
    _mainContent.translatesAutoresizingMaskIntoConstraints=NO;

    _mainContent.text = @"HELLO";
    _mainContent.backgroundColor=[UIColor grayColor];
    _mainContent.textColor = [UIColor blackColor];
    
    _mainContent2=  [UITextView new];
    _mainContent2.translatesAutoresizingMaskIntoConstraints=NO;
    
    _mainContent2.text = @"HELLO2";
    _mainContent2.backgroundColor=[UIColor colorWithRed:0.292 green:0.500 blue:0.207 alpha:1.000];
    _mainContent2.textColor = [UIColor colorWithRed:0.841 green:1.000 blue:0.781 alpha:1.000];
    
    
    @weakify(self);   //[_mainContent mas_]
    [self.view addSubview:_mainContent];
    [self.view addSubview:_mainContent2];
    
    
    [self setUpTests];

    WS(ws)
    
    
    
    
    [_mainContent mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.center.equalTo(ws.view);
        make.top.equalTo(@150);//.with.offset(350);
        make.right.equalTo(_mainContent2.mas_left).offset(-5);
        make.left.equalTo(ws.view).with.offset(5);
       // make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2-20, 300));
        make.width.equalTo(_mainContent2.mas_width);
        make.height.equalTo(_mainContent2.mas_height);
        make.height.equalTo(@100);
    }];
    
    
    [_mainContent2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.center.equalTo(ws.view);
        make.top.equalTo(@150);//.with.offset(150);
        make.left.equalTo(_mainContent.mas_right).offset(5);
        make.trailing.equalTo(ws.view).with.offset(-10);
        //make.size.mas_greaterThanOrEqualTo(CGSizeMake(ws.view.bounds.size.width/2-20, 300));
        //make.width.equalTo(ws.view.mas_width/2-10);
        make.width.equalTo(_mainContent.mas_width);
        make.height.equalTo(_mainContent.mas_height);
         make.height.equalTo(@100);

    }];
    
    // red view top 50 width 200 left 50
    
    UIView *redView=[UIView new];
    redView.backgroundColor=[UIColor redColor];
    [self.view addSubview:redView];
    redView.translatesAutoresizingMaskIntoConstraints   =NO;
    
    //高度100 蓝色 左侧 靠近 redview
    UIView *blueView=[UIView new];
    blueView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:blueView];
    blueView.translatesAutoresizingMaskIntoConstraints   =NO;
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@50);
        make.leading.equalTo(ws.view).with.offset(50);
        //make.left.equalTo(sv.mas_left).with.offset(padding1);
        
        make.height.mas_equalTo(@50);
        make.width.greaterThanOrEqualTo(@200);
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@50);
        make.leading.equalTo(redView.mas_right).with.offset(10);
        //make.left.equalTo(sv.mas_left).with.offset(padding1);
        
        make.height.mas_equalTo(@100);
        make.width.greaterThanOrEqualTo(@50);
    }];
    
//    NSDictionary *views = NSDictionaryOfVariableBindings(self.view, redView,blueView);
//    NSArray *hConstrains=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[redView(>=200)]" options:0 metrics:nil views:views];
//    
//    NSArray *vConstrains=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[redView(>=50)]" options:0 metrics:nil views:views];
//    
//    NSArray *bHConstrains=[NSLayoutConstraint constraintsWithVisualFormat:@"H:[redView]-10-[blueView(>=50)]" options:0 metrics:nil views:views];
//    
//    NSArray *bVConstrains=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[blueView(>=100)]" options:0 metrics:nil views:views];
//    
//    [self.view addConstraints:hConstrains];
//    [self.view addConstraints:vConstrains];
//    
//    [self.view addConstraints:bHConstrains];
//    [self.view addConstraints:bVConstrains];
    
    

    
    
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

#pragma mark - Tests

-(void) setUpActionSheet{
    __weak typeof(self) weakSelf = self;
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"do1" handler:nil];
    [actionSheet bk_addButtonWithTitle:@"do2" handler:nil];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [actionSheet bk_setDidDismissBlock:^(UIActionSheet *sheet, NSInteger index) {
        switch (index) {
            case 0:
               NSLog(@" do1 " );
                break;
            case 1:
                 NSLog(@" do2 " );
                break;
            default:
                break;
        }
    }];
    [actionSheet showInView:weakSelf.view];
}

-(void) setUpTests{
     @weakify(self);
    UIButton *testList =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testList setTitle:@"list测试" forState:UIControlStateNormal];
    
    
    [[testList rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         // @strongify(self);
         ListVC *list=[ListVC new];
         [self.navigationController pushViewController:list animated:YES];
     }];
    
    UIButton *testList2 =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testList2 setTitle:@"actionsheet测试" forState:UIControlStateNormal];
    
    
    [[testList2 rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
          @strongify(self);
         [self setUpActionSheet];
     }];
    [self.view addSubview:testList];
      [self.view addSubview:testList2];
    
    
    
    
    [testList mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.center.equalTo(ws.view);
        make.top.equalTo(@350);//.with.offset(350);
        //make.right.equalTo(_mainContent2.mas_left).offset(-5);
        make.left.equalTo(self.view).with.offset(5);
        // make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2-20, 300));
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    
    [testList2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.center.equalTo(ws.view);
        make.top.equalTo(@380);//.with.offset(350);
        //make.right.equalTo(_mainContent2.mas_left).offset(-5);
        make.left.equalTo(self.view).with.offset(5);
        // make.size.mas_equalTo(CGSizeMake(ws.view.bounds.size.width/2-20, 300));
        make.width.equalTo(@60);
        make.height.equalTo(@40);
    }];
    
  
}

@end
