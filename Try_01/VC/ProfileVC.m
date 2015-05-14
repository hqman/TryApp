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
#import "Masonry.h"


@interface ProfileVC ()<UINavigationBarDelegate,UIImagePickerControllerDelegate >
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
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
    
    
    UIView *redView=[UIView new];
    redView.backgroundColor=[UIColor colorWithRed:1.000 green:0.329 blue:0.633 alpha:1.000];
    [self.view addSubview:redView];
    
    
    WS(ws)
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@150);
        //make.leading.equalTo(ws.view).with.offset(50);
        make.left.equalTo(@50);
//        make.centerX.equalTo(ws.view.mas_centerX);
//        make.centerY.equalTo(ws.view.mas_centerY);
        make.height.mas_equalTo(@50);
        make.width.greaterThanOrEqualTo(@30);
    }];
    
    [self  addNaturalOnTopEffectWithMaximumRelativeValue:50 view:redView];
//[self  addNaturalBelowEffectWithMaximumRelativeValue:25 view:_aButton];

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


#pragma mark - ImagePicker
 
- (IBAction)takePIc:(id)sender {
    
    
   
    
    
    UIImagePickerController *pvc=[UIImagePickerController new];
    pvc.delegate=self;
    
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        pvc.sourceType=UIImagePickerControllerSourceTypeCamera;
    }else{
        pvc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;

    }
    
    
    if([[[UIDevice
          currentDevice] systemVersion] floatValue]>=8.0) {
        NSLog(@"UIDevice 8 ");
        pvc .modalPresentationStyle=UIModalPresentationOverCurrentContext;
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }
    
  [self presentViewController:pvc animated:YES completion:nil];
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image=info[UIImagePickerControllerOriginalImage];
    
    _myImageView.image=image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@" %@ ",@"cancel pick");
    [self dismissViewControllerAnimated:YES completion:nil];
}


 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addNaturalOnTopEffectWithMaximumRelativeValue:(CGFloat)maximumRealtiveValue view:(UIView *)view{
    UIInterpolatingMotionEffect* motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffect.minimumRelativeValue = @(maximumRealtiveValue);
    motionEffect.maximumRelativeValue = @(-maximumRealtiveValue);
    [view addMotionEffect:motionEffect];
    motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffect.minimumRelativeValue = @(maximumRealtiveValue);
    motionEffect.maximumRelativeValue = @(-maximumRealtiveValue);
    [view addMotionEffect:motionEffect];
}

- (void)addNaturalBelowEffectWithMaximumRelativeValue:(CGFloat)maximumRealtiveValue view:(UIView *)view{
    UIInterpolatingMotionEffect* motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    motionEffect.minimumRelativeValue = @(-maximumRealtiveValue);
    motionEffect.maximumRelativeValue = @(maximumRealtiveValue);
    [view addMotionEffect:motionEffect];
    motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffect.minimumRelativeValue = @(-maximumRealtiveValue);
    motionEffect.maximumRelativeValue = @(maximumRealtiveValue);
    [view addMotionEffect:motionEffect];
}

@end
