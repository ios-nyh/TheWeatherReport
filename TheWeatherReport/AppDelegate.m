//
//  AppDelegate.m
//  TheWeatherReport
//
//  Created by ios on 13-9-11.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "HelperViewController.h"
#import "Reachability.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_home release];
    [_hostReach release];
    
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // ios7和ios6 屏幕适配
    if (IOS_VERSION >= 7.0) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    } else {
    
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
    }
    
    //加入导航视图
    [self setHelperViewController];
   
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //开始监听网络
    [self startNotificationNetwork];

    //启动位置管理器
    if ([CLLocationManager locationServicesEnabled]) {
        
        CLLocationManager *locManager = [[CLLocationManager alloc]init];
        locManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locManager startUpdatingLocation];
        [locManager setDistanceFilter:10.0f];
        self.locationManager = locManager;
        [locManager release];
    }

    return YES;
}

//设置导航视图
- (void)setHelperViewController
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:@"Helper"];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path] == NO) {
        
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        HelperViewController *helper = [[HelperViewController alloc]init];
        [self.window setRootViewController:helper];
        [helper release];
        
    } else {
        
        self.home = [[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil]autorelease];
        UINavigationController *naHome = [[[UINavigationController alloc]initWithRootViewController:self.home]autorelease];
        self.window.rootViewController = naHome;
    }
}

//处理连接改变后的情况,对连接改变做出响应的处理动作
- (void)updateInterfaceWithReachability:(Reachability *)curReach
{
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if(status == NotReachable) {
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                          message:@"网络连接失败,请检查网络"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
    } else {
        
        NSLog(@"connect with the internet successfully!");
    }
}

//连接改变
- (void)reachabilityChanged: (NSNotification* )note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

//开始监听网络状态
-(void)startNotificationNetwork
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([self.hostReach currentReachabilityStatus])
    {
        case NotReachable:
            NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            NSLog(@"正在使用wifi网络");
            break;
        default:
            break;
    }
    
    [self.hostReach startNotifier];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
