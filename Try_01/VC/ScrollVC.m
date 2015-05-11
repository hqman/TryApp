//
//  ScrollVC.m
//  TryApp
//
//  Created by hqman on 15/5/11.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "ScrollVC.h"
#import "HWCenteredScrollView.h"
@interface ScrollVC() <UIScrollViewDelegate>
@property (strong ,nonatomic) HWCenteredScrollView * scrollView;
@property (strong ,nonatomic) UIImageView * imageView;
@end

@implementation ScrollVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bigPic"]];
    self.scrollView=[[HWCenteredScrollView alloc]initWithFrame:self.view.bounds];
    
    self.scrollView.backgroundColor=[UIColor blackColor];
    self.scrollView.contentSize=self.imageView.bounds.size;
     self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    [self.scrollView addSubview:_imageView];
    self.scrollView.delegate=self;
    
    [self.scrollView setScale];
}




#pragma UIScrollViewDelegate

//设置那个view 需要 放大缩小
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

//屏幕 横向 变化 或者 view 大小变化
-(void)viewWillLayoutSubviews{
    
     //[self setScale];
    //[self.scrollView centerContent ];
}

@end
