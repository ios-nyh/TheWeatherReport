//
//  ActivityIndicatorView.h
//  TheWeatherReport
//
//  Created by iOS on 13-10-29.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicatorView : UIView

//活动指示器
@property (retain,nonatomic) UIActivityIndicatorView *activityIV;

- (void)show;

- (void)hidden;


@end
