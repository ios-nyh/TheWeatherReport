//
//  HomeViewController.h
//  TheWeatherReport
//
//  Created by ios on 13-9-11.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ActivityIndicatorView;

@interface HomeViewController : UIViewController<UIAlertViewDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UILabel *_cityLabel;       //当前城市
    
    UILabel *_temp;            // 当日最佳温度
    UILabel *_weather;         // 当日天气情况
    UILabel *_content;         // 天气内容
    UILabel *_wind;            // 风速描述
    UILabel *_date;            // 日期
    
    UIImageView *_imgView1;    // 天气图标
    UIImageView *_imgView2;    
    
    
    UILabel *_weather2;        //温度范围
    UILabel *_content2;        //天气内容
    UILabel *_date2;           //日期
    
    UILabel *_weather3;
    UILabel *_content3;
    UILabel *_date3;
    
        
    NSDictionary *_subDic;    //装载天气内容
    
    UIButton *_cameraBtn;     //拍照
    UIButton *_infoBtn;       //详细信息
    UIButton *_refreshBtn;    //刷新按钮
    
 
    UILabel *_refreshDate;    //刷新日期
    
    
    NSString *_cityid;        //城市编号
    UILabel *_curLocation;;   //当前位置
    
    UIActivityIndicatorView *_activityView;   //指示视图
    UIView *_loading;
    
    //滚动视图One
    UILabel *_OcityName;
    UILabel *_Otemp;
    UIImageView *_OimgView1;
    UIImageView *_OimgView2;
    UILabel *_Odate;
    //Two
    UILabel *_Ttemp;
    UILabel *_Tdate;
    UILabel *_TcityName;
    UILabel *_Tcontent;
    UILabel *_Twind;
    UILabel *_Tweather;
    
    UIImageView *_TimgView1;    // 天气图标
    UIImageView *_TimgView2;
    
    UILabel *_Tdate2;
    UILabel *_Tweather2;
    UIView *_Tview2;

    UIImageView *_TimgView21;
    UIImageView *_TimgView22;
    
    UILabel *_Tdate3;
    UILabel *_Tweather3;
    UIView *_Tview3;

    UIImageView *_TimgView31;    // 天气图标
    UIImageView *_TimgView32;
    
    
    //three
    UILabel *_tHDate;
    UIImageView *_tHImgView1;
    UIImageView *_tHImgView2;
    UILabel *_tHArea;
}


@property (retain, nonatomic) NSMutableData *mData;                 
@property (retain, nonatomic) NSDictionary *cityDic;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *subLocality;

@property (retain, nonatomic) CLLocationManager *locationManager;

@property (retain, nonatomic) UIView *liveView;                      //摄像视图
@property (retain, nonatomic) UIImageView *preview;                  //预览视图

@property (retain,nonatomic) UIImagePickerController *imagePicker;

@property (retain,nonatomic) ActivityIndicatorView *activity;


@end
