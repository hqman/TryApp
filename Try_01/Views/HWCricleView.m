//
//  HWCricleView.m
//  TryApp
//
//  Created by hqman on 15/5/11.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "HWCricleView.h"
@interface HWCricleView ()
//画圆 1：半径 圆心

@property ( nonatomic) CGPoint c_center;
@property ( nonatomic)  float  c_radius;

@property (nonatomic, strong) NSMutableDictionary *cProgress;
@end


@implementation HWCricleView


-(void) touchesAction:(NSSet *)touches {
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        //        BNRLine *line = [[BNRLine alloc] init];
        //        line.begin = location;
        //        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.cProgress[key] = [NSValue valueWithCGPoint:location];
    }
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //NCLog(@"touchesBegan ");
    [self touchesAction:touches];

}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event   {
    //NCLog(@"touchesMovedß// ");
    [self touchesAction:touches];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //NCLog(@"touchesEnded ");
     //[self setNeedsDisplay];
    [self.cProgress removeAllObjects];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.multipleTouchEnabled=YES;
        self.cProgress=[NSMutableDictionary new];
    }
    return self;
}

-(void)strokeCircle{
    UIBezierPath *path=[[UIBezierPath alloc]init];
    [path addArcWithCenter:self.c_center radius:self.c_radius startAngle:0.0 endAngle:M_PI*2.0 clockwise:YES];
    path.lineWidth=3;
    [[UIColor colorWithRed:0.243 green:0.939 blue:0.439 alpha:1.000] setStroke];
    [path stroke];
    
    [self setNeedsLayout];
}

-(void)drawRect:(CGRect)rect   {
    CGRect bounds=self.bounds;
    NCLog(@"%@",NSStringFromCGRect(bounds));
    
    float radius=bounds.size.height/2;
    CGPoint center;
    center.x=bounds.origin.x+bounds.size.width/2;
    center.y=bounds.origin.y+bounds.size.height/2;
    for (float rd=radius ; rd>0; rd=rd-20 ) {
        UIBezierPath *path=[[UIBezierPath alloc]init];
        [path addArcWithCenter:center radius:rd startAngle:0.0 endAngle:M_PI*2.0 clockwise:YES];
        path.lineWidth=6;
        [[UIColor lightGrayColor] setStroke];
        [path stroke];
    }
//
//    UIImage *image=[UIImage imageNamed:@"voice_input_word_12"];
//    [@"Wang kai" drawInRect:CGRectMake(50, 50, 100, 50) withFont:[UIFont systemFontOfSize:15]];
//    [image drawInRect:CGRectMake(center.x, center.y, image.size.width*10, image.size.height*10)];
    
    
    
    
    NSArray *points=[self.cProgress allValues];
    NCLog(@"draw View ...%d",[points count]);
    
    if (points.count==2){
        //
        CGPoint endPoint1, endPoint2;
        endPoint1= [(NSValue *)points[0] CGPointValue];
        endPoint2= [(NSValue *)points[1] CGPointValue];
        _c_center= CGPointMake((endPoint1.x + endPoint2.x)/2, (endPoint1.y + endPoint2.y)/2);
        
        CGFloat xDist = (endPoint2.x - endPoint1.x); //[2]
        CGFloat yDist = (endPoint2.y - endPoint1.y); //[3]
        CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist)); //[4]
        
        _c_radius=distance/2;
    }
    
    if(_c_center.x && _c_center.y && _c_radius >0){
        [self strokeCircle];
    }
    
    CGRect newbounds=self.bounds;
    
    newbounds.origin.x=self.bounds.origin.x+50.0;
    
    newbounds.origin.y=self.bounds.origin.y+50;
    
    self.bounds=newbounds;


}


@end
