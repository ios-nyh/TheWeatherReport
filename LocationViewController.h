//
//  LocationViewController.h
//  TheWeatherReport
//
//  Created by ios on 13-8-28.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationViewController : UIViewController<CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    CLLocationManager *_locationManager;
    
    float _latitude ;
    float _longitude;
    
    UILabel *_addressLabel;
    
    UIImageView *_bgImgView;
    
    //天气展示
    UIImageView *_imgView1;
    UIImageView *_imgView2;
    
    UILabel *_str;//当日最佳温度
    UILabel *_weather;//天气描述
    UILabel *_temp;//温度范围
    UILabel *_wind;//风速描述
    UILabel *_date;//日期
   
}


@end

