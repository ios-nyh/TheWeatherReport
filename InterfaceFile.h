//
//  InterfaceFile.h
//  TheWeatherReport
//
//  Created by iOS on 13-11-1.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#ifndef TheWeatherReport_InterfaceFile_h
#define TheWeatherReport_InterfaceFile_h


/**
 *  定义物理屏幕大小
 */
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define WIDTH  [UIScreen mainScreen].bounds.size.width

/**
 *  判断系统版本
 */
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 *  判断设备版本
 */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)




/**
 *  获取天气数据
 */
#define WEATHER_API @"http://m.weather.com.cn/data/%@.html"


/**
 *  获取城市数据
 */
#define CITY_DATA @"http://www.coolelife.com/weather/josn.php"


/**
 *  发表建议
 */
#define PUBLISH_COMMENT_API @"http://www.coolelife.com/weather/addComment_json.php"
#define PUBLISH_COMMENT_ARGUMENT @"cont=%@"


/**
 *  获取建议列表
 */
#define GET_COMMENT_LIST_API @"http://www.coolelife.com/weather/getComment_json.php"



#endif
