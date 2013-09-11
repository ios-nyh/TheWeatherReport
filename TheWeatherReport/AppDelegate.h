//
//  AppDelegate.h
//  TheWeatherReport
//
//  Created by ios on 13-9-11.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class HomeViewController,Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HomeViewController *home;

@property (strong, nonatomic) Reachability *hostReach;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
