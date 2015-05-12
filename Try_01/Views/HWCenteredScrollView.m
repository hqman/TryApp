//
//  HWCenteredScrollView.m
//  TryApp
//
//  Created by hqman on 15/5/11.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "HWCenteredScrollView.h"
#import "Masonry.h"
@implementation HWCenteredScrollView

 



-(void)layoutSubviews{
    
    [super layoutSubviews];
    //[self setScale];
    //[self centerContent];
}


// 设置 scroll
-(void)setScale{
    UIView *centerView=[self.delegate viewForZoomingInScrollView:self];
    CGSize boundSize=self.bounds.size;
    CGSize imageSize=centerView.bounds.size;
    
    float xScale=boundSize.width/imageSize.width;
    float yScale=boundSize.height/imageSize.height;
    //计算 适合屏幕 宽度 或者 高度的比例大小 fit 模式
    float zoomScale=MIN(xScale, yScale);
    //_scrollView.frame=self.view.bounds;
    self.minimumZoomScale=zoomScale;
    //开始 大小比例
    self.zoomScale=zoomScale;//zoomScale  ;
    self.maximumZoomScale=3.0;
    self.xScale=zoomScale;
     }

-(void) centerContent{
    if(self.delegate && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]){
        UIView *centerView=[self.delegate viewForZoomingInScrollView:self];
        
        CGSize boundSize=self.bounds.size;
        CGRect frameToCenter=centerView.frame;
        //设置 imageView 被scroll的这个视图 居中屏幕
        if(frameToCenter.size.width<boundSize.width){
            frameToCenter.origin.x=(boundSize.width-frameToCenter.size.width  )/2;
        }else{
            
                frameToCenter.origin.x = 0;
            
        }
        if (frameToCenter.size.height<boundSize.height) {
            frameToCenter.origin.y=(boundSize.height-frameToCenter.size.height  )/2;
            
        }else {
            frameToCenter.origin.y = 0;
        }
        centerView.frame=frameToCenter;
    }
}

@end
