//
//  ViewController.m
//  Try_01
//
//  Created by hqman on 15/4/21.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //设置 view。。。
    [self.view setBackgroundColor:[UIColor yellowColor]];
    self.firstButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.firstButton.frame=CGRectMake(100, 100, 100, 44);
    [self.firstButton setTitle:@"make 100%" forState:  UIControlStateNormal ];
    [self.firstButton addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.secondButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.secondButton.frame=CGRectMake(100, 300, 100, 44);
    self.secondButton.backgroundColor=[UIColor whiteColor];
    [self.secondButton setTitle:@"make 50%" forState:UIControlStateNormal];
    [self.secondButton addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    //add lable
    UILabel *aLable=[[UILabel alloc]initWithFrame:CGRectMake(50, 60, 80, 20)];
    aLable.backgroundColor=[UIColor whiteColor];

    [aLable setText:@"i am a lable"];
        //
    [self.view addSubview:self.firstButton];
     [self.view addSubview:self.secondButton];
    [self.view addSubview:aLable];
}

-(void) press:(UIButton *)sender {
if ([sender isEqual:self.firstButton] ) {
        self.view.alpha=1;
            NSLog(@"press1 %@",sender);

    }else{
        self.view.alpha=0.5;
        NSLog(@"press2 %@",sender);

    }
    
}

-(void) loadView{
    CGRect viewRect=[[UIScreen mainScreen] bounds];
    UIView *colorView =[[UIView alloc]initWithFrame:viewRect];
    self.view=colorView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event    {
    NSLog(@"touch ......");
}
@end
