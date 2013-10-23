//
//  WeatherData.m
//  TheWeatherReport
//
//  Created by ios on 13-10-23.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

- (void)dealloc
{
    [_temp release];
    [_weather release];
    [_content release];
    [_wind release];
    [_date release];
    
    [_imgView1 release];
    [_imgView2 release];
    
    
    [_weather2 release];
    [_content2 release];
    [_date2 release];
    
    
    [_weather3 release];
    [_content3 release];
    [_date3 release];

    [super dealloc];
}

@end
