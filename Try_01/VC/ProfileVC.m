//
//  ProfileVC.m
//  Try_01
//
//  Created by hqman on 15/4/21.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "ProfileVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Person.h"
#import "RACEXTScope.h"
#import "HWCricleView.h"
#import "HWLayoutVC.h"

@interface ProfileVC ()
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@property (weak, nonatomic) IBOutlet UIButton *aButton;
@end

@implementation ProfileVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
        //self.tabBarItem.image = [UIImage imageNamed:@"first_normal"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // button event 触发 事件 & 实现
    
    @weakify(self)
    [[self.aButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         Person *p=[ [Person alloc]initWithName:@"Wang Kai" age:33 ];
         [p doSomething ];
         self.title = @"Profile";
         NSLog(@"click me");
     }];
    //draw view
   // HWCricleView *subView=[[HWCricleView alloc]initWithFrame:self.view.bounds];
    //subView.backgroundColor=[UIColor redColor];
   // [self.view addSubview:subView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)go:(id)sender {
    HWLayoutVC *vc=[HWLayoutVC new];
    
    vc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    vc.dismissBlock=^(NSString *backs){
        NCLog(@" i am about to go  %@",backs);
    };
    [self presentViewController:vc animated:YES completion:^{
        NCLog(@" i am about to go  ");
    } ];
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
