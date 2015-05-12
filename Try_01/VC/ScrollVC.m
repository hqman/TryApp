//
//  ScrollVC.m
//  TryApp
//
//  Created by hqman on 15/5/11.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "ScrollVC.h"
#import "HWCenteredScrollView.h"
#import "Masonry.h"
#import "RACEXTScope.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface ScrollVC() <UIScrollViewDelegate,UITextViewDelegate>
@property (strong ,nonatomic) HWCenteredScrollView * scrollView;
@property (strong ,nonatomic) UIView * imageView;
@property (strong ,nonatomic) UITextView * textView;

@end

@implementation ScrollVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Scroll";
        //self.tabBarItem.image = [UIImage imageNamed:@"first_normal"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView=[UIView new];//[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bigPic"]];
    
    self.imageView.frame=CGRectMake(0, 0, 400, 600);
    self.imageView.backgroundColor=[UIColor colorWithRed:0.246 green:0.984 blue:1.000 alpha:1.000];
    self.scrollView=[[HWCenteredScrollView alloc]initWithFrame:self.view.bounds];
    
    //self.scrollView.backgroundColor=[UIColor blackColor];
    self.scrollView.contentSize=self.imageView.bounds.size;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    [self.scrollView addSubview:_imageView];
    self.textView=UITextView.new;
    
    
    [self.imageView addSubview:_textView];
    self.scrollView.delegate=self;
    //[self.navigationController.navigationBar ]
    //[self.navigationController.navigationBar setTranslucent:YES];
    //self.scrollView.contentInset=UIEdgeInsetsMake(CGRectGetHeight(self.navigationController.navigationBar.frame), 0, 0, 0);
    
    WS(ws)
    //
    
    [self.scrollView setScale];
//    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //make.center.equalTo(ws.view);
//        make.left.top.equalTo(_scrollView);
//        make.width.greaterThanOrEqualTo(ws.view.mas_width);
//        make.width.equalTo(_scrollView);
//
//        make.height.equalTo(@600);
//        
//    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imageView).offset(-10);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
        make.left.equalTo(_imageView).offset(20);
    }];
    
//    @weakify(self);
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil]
//     subscribeNext:^(id x) {
//         @strongify(self);
//         NCLog(@"show ...");
//     }];
//    
//    
//    
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
//     subscribeNext:^(id x) {
//         @strongify(self);
//         NCLog(@"hide...");
//     }];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    [self.scrollView addGestureRecognizer:gestureRecognizer];
    
}




#pragma UIScrollViewDelegate

//设置那个view 需要 放大缩小
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

//屏幕 横向 变化 或者 view 大小变化
-(void)viewWillLayoutSubviews{
    
    [self.scrollView setScale];
    //[self.scrollView centerContent ];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NCLog(@"show...");
    NSDictionary *info = [notification userInfo];
//    UIEdgeInsets insets2 = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, 0, 0);
//    self.scrollView.contentInset = insets2;
//    self.scrollView.scrollIndicatorInsets = insets2;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    
   
    CGSize keyboardSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets insets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, keyboardSize.height, 0);
    //self.scrollView.contentInset = insets;
    self.scrollView.contentInset = insets;
    self.scrollView.scrollIndicatorInsets = insets;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y + keyboardSize.height);
    
     [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NCLog(@"hide...");
    UIEdgeInsets insets = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, 0, 0);
    self.scrollView.contentInset = insets;
    self.scrollView.scrollIndicatorInsets = insets;
    
}

- (void) hideKeyboard {
    [_textView resignFirstResponder];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
