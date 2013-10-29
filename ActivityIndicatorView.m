//
//  ActivityIndicatorView.m
//  TheWeatherReport
//
//  Created by iOS on 13-10-29.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "ActivityIndicatorView.h"

@implementation ActivityIndicatorView

- (void)dealloc
{
    [_activityIV release];
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //创建活动指示器
        UIActivityIndicatorView *activity = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
        self.activityIV = activity;
        
        //设置活动指示器的中间位置
        self.activityIV.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - 10);
        
        //添加到视图
        [self addSubview:self.activityIV];
    }
    
    return self;
}

//显示、隐藏该视图方法
-(void) show
{
    //改变视图的位置,居中显示
    
    self.center = CGPointMake(self.superview.bounds.size.width/2, self.superview.bounds.size.height/2);
    
    //活动指示器开启动画
    
    [self.activityIV startAnimating];
    
    //显示该视图
    
    self.hidden = NO;
}

-(void) hidden
{
    
    //活动指示器停止动画
    
    [self.activityIV stopAnimating];
    
    //隐藏该视图
    
    self.hidden = YES;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
