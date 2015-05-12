//
//  HWCenteredScrollView.h
//  TryApp
//
//  Created by hqman on 15/5/11.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
@interface HWCenteredScrollView : TPKeyboardAvoidingScrollView

@property (nonatomic) float xScale;
//居中
-(void) centerContent;
//设置放大比例
-(void)setScale;
@end
