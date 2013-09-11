//
//  HomeViewController.h
//  TheWeatherReport
//
//  Created by ios on 13-9-11.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeViewController : UIViewController<UIAlertViewDelegate,CLLocationManagerDelegate>
{
    UILabel *_cityLabel;
    
    UILabel *_temp;//当日最佳温度
    UILabel *_weather;//当日天气情况
    UILabel *_content;//天气内容
    UILabel *_date;//日期
    
    UIImageView *_imgView1;
    UIImageView *_imgView2;
    
    
    UILabel *_weather2;//温度范围
    UILabel *_date2;
    
    UILabel *_weather3;//温度范围
    UILabel *_date3;
    
    UIView *_view1;
    UIView *_view2;
    UIView *_view3;
    
    NSDictionary *_subDic;
    
    
    UIView *_loading;
    UIActivityIndicatorView *_activityView;
    
    
    UIButton *_cameraBtn;//拍照
    UIButton *_cancelBtn;//取消拍照
    UIButton *_infoBtn;
    
    
    NSString *_cityid;


}

@property (retain, nonatomic) NSMutableData *mData;
@property (retain, nonatomic) NSDictionary *cityDic;
@property (retain, nonatomic) NSString *address;

@property (retain, nonatomic) CLLocationManager *locationManager;

@property (retain, nonatomic) UIView *liveView;//摄像视图
@property (retain, nonatomic) UIImageView *preview;//预览视图


@end
