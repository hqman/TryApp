//
//  HWLayoutVC.m
//  TryApp
//
//  Created by hqman on 15/5/12.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "HWLayoutVC.h"
#import "Masonry.H"
@implementation HWLayoutVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *closeButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    UIView *redView=[UIView new];
    redView.backgroundColor=[UIColor colorWithRed:1.000 green:0.329 blue:0.633 alpha:1.000];
    [self.view addSubview:redView];
    WS(ws)
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //make.top.equalTo(@50);
        //make.leading.equalTo(ws.view).with.offset(50);
        //make.left.equalTo(sv.mas_left).with.offset(padding1);
        make.centerX.equalTo(ws.view.mas_centerX);
        make.centerY.equalTo(ws.view.mas_centerY);
        make.height.mas_equalTo(@250);
        make.width.greaterThanOrEqualTo(@200);
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@25);
        make.right.equalTo(@5);

        //make.leading.equalTo(ws.view).with.offset(50);
        //make.left.equalTo(sv.mas_left).with.offset(padding1);
//        make.centerX.equalTo(ws.view.mas_centerX);
//        make.centerY.equalTo(ws.view.mas_centerY);
//        make.height.mas_equalTo(@250);
        make.width.greaterThanOrEqualTo(@20);
    }];

    
}

-(void) goback:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NCLog(@" i gonna go  back");

    }];
}
@end
