//
//  WeatherData.h
//  TheWeatherReport
//
//  Created by ios on 13-10-23.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject

//{
//    UILabel *_temp;            // 当日最佳温度
//    UILabel *_weather;         // 当日天气情况
//    UILabel *_content;         // 天气内容
//    UILabel *_wind;            // 风速描述
//    UILabel *_date;            // 日期
//    
//    UIImageView *_imgView1;    // 天气图标
//    UIImageView *_imgView2;
//    
//    
//    UILabel *_weather2;        //第二天温度范围
//    UILabel *_content2;        //第二天温天气内容
//    UILabel *_date2;           //第二天温日期
//    
//    UILabel *_weather3;
//    UILabel *_content3;
//    UILabel *_date3;
//}


@property (copy,nonatomic) NSString *temp;
@property (copy,nonatomic) NSString *weather;
@property (copy,nonatomic) NSString *content;
@property (copy,nonatomic) NSString *wind;
@property (copy,nonatomic) NSString *date;


@property (retain,nonatomic) UIImageView *imgView1;
@property (retain,nonatomic) UIImageView *imgView2;


@property (copy,nonatomic) NSString *weather2;
@property (copy,nonatomic) NSString *content2;
@property (copy,nonatomic) NSString *date2;

@property (copy,nonatomic) NSString *weather3;
@property (copy,nonatomic) NSString *content3;
@property (copy,nonatomic) NSString *date3;




@end




