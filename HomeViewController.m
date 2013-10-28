//
//  HomeViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-11.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "HomeViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "CameraImageHelper.h"
#import "ShowInfoViewController.h"

#import "CheckNetwork.h"
#import "CycleScrollView.h"

#import <ShareSDK/ShareSDK.h>

@interface HomeViewController ()<AVHelperDelegate>
{
    float rHeignt;    // 刷新高度
    float vHeight;    // 系统高度
    float cHeight;    // 截屏高度
    BOOL isAlertTwo;  //判断alert响应的代理方法
}

@property (retain,nonatomic) CameraImageHelper *cameraHelper;

@end

@implementation HomeViewController

- (void)dealloc
{
    [_cityLabel release];
    
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
    
    
    //滚动视图One
    [_OcityName release];
    [_Otemp release];
    [_OimgView1 release];
    [_OimgView2 release];
    [_Odate release];
    //Two
    [_Ttemp release];
    [_Tdate release];
    [_TcityName release];
    [_Tcontent release];
    [_Twind release];
    [_Tweather release];
    
    [_TimgView1 release];    // 天气图标
    [_TimgView2 release];
    
    [_Tdate2 release];
    [_Tweather2 release];
    [_Tview2 release];
    
    [_TimgView21 release];
    [_TimgView22 release];
    
    [_Tdate3 release];
    [_Tweather3 release];
    [_Tview3 release];
    
    [_TimgView31 release];    // 天气图标
    [_TimgView32 release];
    
    //three
    [_tHDate release];
    [_tHImgView1 release];
    [_tHImgView2 release];
    [_tHArea release];
    
    
    //指示视图
    [_loading release];
    [_activityView release];
    
    
    [_mData release];
    [_cityDic release];
    [_address release];
    [_location release];
    [_subLocality release];
    
    [_subDic release];
    
    [_preview release];
    [_liveView release];
    
    [_cameraHelper release];
    [_locationManager release];
    
    [_cityid release];
    [_curLocation release];
    [_refreshDate release];
    
    [_imagePicker release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectedCityNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectedCityCodeidNotification" object:nil];
    
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}


#pragma mark - 系统方法，用于拍照
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    //开始定位服务
    [self startUpdates];

    
    //开始实时取景
    [self.cameraHelper startRunning];
    
    //在刷新按钮位置，加入指示视图
    [self activityIndicatorViewWithFrame:CGRectMake(WIDTH - 50, rHeignt, 20, 20)];
    
    //无网络时，停止菊花转动
    if (![CheckNetwork isNetworkRunning]) {
        
        [self stopAnimating];
    }

}
- (void)viewWillDisappear:(BOOL)animated
{   //停止取景
    [self.cameraHelper stopRunning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - 判断版本及屏幕适配

- (void)setVersionAndScreen
{
    //判断ios系统版本
    if (IOS_VERSION >= 7.0) {
        
        vHeight = HEIGHT - 45;
        rHeignt = 40;
        
        cHeight = HEIGHT;
        
    } else {
        
        vHeight = HEIGHT - 65;
        rHeignt = 20;
        
        cHeight = HEIGHT - 20;
    }
}

#pragma mark - 自定义界面按钮

- (void)customUIBtn
{
    //刷新按钮
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refreshBtn setFrame:CGRectMake(WIDTH - 65, rHeignt, 50, 38)];
    [_refreshBtn setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(refreshControlMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refreshBtn];
    //给刷新按钮加上阴影效果
    _refreshBtn.layer.shadowOffset = CGSizeMake(0, 0);
    _refreshBtn.layer.shadowOpacity = 0.6;
    _refreshBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    
    
    //拍摄按钮
    _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cameraBtn setFrame:CGRectMake(15, vHeight, 50, 38)];
    [_cameraBtn setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [_cameraBtn addTarget:self action:@selector(snapPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraBtn];
    
    
    //信息按钮
    _infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_infoBtn setFrame:CGRectMake(WIDTH - 65, vHeight, 50, 38)];
    [_infoBtn setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [_infoBtn addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_infoBtn];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //当前背景颜色
    [self.view setBackgroundColor:[UIColor blackColor]];

    //判断版本及屏幕适配
    [self setVersionAndScreen];

//    //开始定位服务
//    [self startUpdates];

    //获取城市信息
    NSString *path = [[NSBundle mainBundle]pathForResource:@"CityInfo" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.cityDic = dic;
    
    
    //当前拍摄视图
    UIView *liveView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.liveView = liveView;
    liveView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:liveView];
    [liveView release];
    
    
    //当前预览视图
    UIImageView *preview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    preview.clipsToBounds = YES;  //超过边界的不显示
    preview.contentMode = UIViewContentModeScaleAspectFill;  //自适应，不变形
//    preview.contentMode = UIViewContentModeScaleAspectFit; //自适应，但是不能全覆盖
//    preview.contentMode = UIViewContentModeScaleToFill;    //自适应，但是会拉伸
    
    self.preview = preview;
    [self.view addSubview:preview];
    [preview release];
    
    
    //初始化天气信息label
    [self scrollViewMethod];
    
    
    //初始化相机
    CameraImageHelper *cameraHelper = [[CameraImageHelper alloc]init];
    cameraHelper.delegate = self;
    self.cameraHelper = cameraHelper;
    [cameraHelper release];
    
    //载入拍摄视图
    [self.cameraHelper embedPreviewInView:self.liveView];
    
    //自定义按钮
    [self customUIBtn];
    
    //增加一个计时器，每隔两小时刷新一次
    [NSTimer scheduledTimerWithTimeInterval:7200.0f target:self selector:@selector(refreshControlMethod) userInfo:nil repeats:YES];
    
    //监听进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshControlMethod)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    //城市选择的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCity:) name:@"selectedCityNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCityCodeid:) name:@"selectedCityCodeidNotification" object:nil];
}

#pragma mark - 加入滚动视图

- (void)scrollViewMethod
{
    NSMutableArray *picArray = [[NSMutableArray alloc] init];
    
    UIView *v1 = [[UIView alloc]init];
    UIView *v2 = [[UIView alloc]init];
    UIView *v3 = [[UIView alloc]init];
    UIView *v4 = [[UIView alloc]init];
    
    
    [self setBackgroundView1:v1];
    [self setBackgroundView2:v2];
    [self setBackgroundView3:v3];
    [self setBackgroundView4:v4];

    [picArray addObject:v1];
    [picArray addObject:v2];
    [picArray addObject:v3];
    [picArray addObject:v4];

    [v1 release];
    [v2 release];
    [v3 release];
    [v4 release];
    
    
    //显示数组对象
    CFShow(picArray);
    
    CycleScrollView *cycle = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, cHeight)
                                                     cycleDirection:CycleDirectionLandscape
                                                           pictures:picArray];
    [self.view addSubview:cycle];
    [cycle release];
    [picArray release];
}

//- (UIImage *)convertViewToImage:(UIView *)v
//{
////    CGSize s = v.bounds.size;
////    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
////    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
////    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
////    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
////    UIGraphicsEndImageContext();
////    
////    return image;
//    
//    UIGraphicsBeginImageContext(v.bounds.size);
//    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}


#pragma mark - 开启定位服务
- (void)startUpdates
{
    if (_locationManager == nil) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
        [_locationManager startUpdatingLocation];
    }
    
    //开启状态栏动画
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
}


#pragma mark - CLLocationManagerDelegate method

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    [self getCurrentLocation:location];
    
    [_locationManager stopUpdatingLocation];
}

- (void)getCurrentLocation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark *placemark in placemarks) {
            
//            NSLog(@"address dic ---->：%@",placemark.addressDictionary);
            NSString *address = [placemark.addressDictionary objectForKey:@"State"];
    

            self.location = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] lastObject];
            
            self.address = address;
    
            self.subLocality = [placemark.addressDictionary objectForKey:@"SubLocality"];
          
            
//            NSLog(@"FormattedAddressLines = %@",self.location);
//            NSLog(@"State = %@",self.address);
//            NSLog(@"SubLocality = %@",self.subLocality);
            
            
            //开始JSON解析
            [self JSONStartParse:[self.cityDic objectForKey:self.address]];
        }
    }];
    
    [geocoder release];
}

#pragma mark - 获取摄像图片
#pragma mark AVHelperDelegate Method

- (void)didFinishedCapture:(UIImage *)_img
{
    self.preview.image = nil;
    [self.preview setHidden:NO];
    
    if (_img) {
        
        self.preview.image = _img;
        
        NSLog(@" getImage height %f, width %f",_img.size.height,_img.size.width);
        
        
        [_cameraBtn setHidden:YES];
        [_infoBtn setHidden:YES];
        [_refreshBtn setHidden:YES];
        
        
        //提示，是否保存图片
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        
        isAlertTwo = NO;
        
        [alertView show];
        [alertView release];
        
       
        //获取当前位置信息
        _curLocation.text = self.location;
        
    }
    
    [self stopAnimating];
    
}

//- (void)getImage
//{
//     self.preview.image = nil;
//    [self.preview setHidden:NO];
//    
//    if ([self.cameraHelper image] != nil) {
//        
//        self.preview.image = [self.cameraHelper image];
//        
//        NSLog(@"getImage height %f, width %f",self.preview.image.size.height,self.preview.image.size.width);
//        
//        
//        [_cameraBtn setHidden:YES];
//        
//        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_cancelBtn setFrame:CGRectMake(15, HEIGHT - 45, 50, 38)];
//        [_cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
//        [_cancelBtn setImage:[UIImage imageNamed:@"cancel_pressed.png"] forState:UIControlStateHighlighted];
//        [_cancelBtn addTarget:self action:@selector(cancelPhotos:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_cancelBtn];
//        
//        //提示，是否保存图片
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
//        
//        [alertView show];
//        [alertView release];
//        
//        _curLocation.text = self.location;
//    }
//    
//    [self stopAnimating];
//}

#pragma mark - 对于特定UIView的截屏

- (UIImage *)captureView: (UIView *)theView
{
    //    CGRect rect = theView.frame;
    
    CGRect rect = CGRectMake(0, 0, WIDTH, cHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //另一种方法：全屏截图
//    UIGraphicsBeginImageContext(CGSizeMake(WIDTH,HEIGHT - 20));
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage*img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    return img;
}


#pragma mark - 设置相机界面
- (void)setCameraUI
{
    [_cameraBtn setHidden:NO];
    [_infoBtn setHidden:NO];
    [_refreshBtn setHidden:NO];
    
    [self.preview setHidden:YES];
    
    _curLocation.text = @"";
    
    //判断有无网络
    if ([CheckNetwork isNetworkRunning]) {
        
        _refreshDate.text = [self dataFormatter];
        
    } else {
        
        //清空刷新时间
        _refreshDate.text = @"";
        
        [self stopAnimating];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            
        case 0:
        {
            [self setCameraUI];
        }

            break;
            
        case 1:
        {
            // isAlertTwo == YES 分享图片
            if (isAlertTwo) {
                
                isAlertTwo = NO;
                
                [self share];
                
            } else {
            
            //保存图片到相册
            [_refreshBtn setHidden:YES];
            
            UIImage *img = [self captureView:self.view];
            UIImageWriteToSavedPhotosAlbum(img,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
            
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储照片成功"

                                                    message:@"您已将照片存储于图片库中，打开照片程序即可查看。"

                                                   delegate:self

                                          cancelButtonTitle:@"关闭"

                                          otherButtonTitles:@"分享",nil];
    isAlertTwo = YES;
    
    [alert dismissWithClickedButtonIndex:1 animated:YES];

    [alert show];

    [alert release];
    
}

#pragma mark - 分享图片

- (void)share
{
    UIImage *img = [self captureView:self.view];
    //分享的图片
    id<ISSCAttachment> fileName = [ShareSDK pngImageWithImage:img];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"天气图片"
                                       defaultContent:@"默认内容"
                                                image:fileName
                                                title:@"天气.相机"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"天气相机分享"
                                            mediaType:SSPublishContentMediaTypeImage];
    
    //创建弹出菜单容器,用于显示分享界面的容器，如果只显示在iPhone客户端可以传入nil。如果需要在iPad上显示需要指定容器。
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    //自定义分享列表
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeWeixiSession,ShareTypeQQ,ShareTypeTencentWeibo, nil];
    
   
    //分享选项，用于定义分享视图部分属性（如：标题、一键分享列表、功能按钮等）,默认可传入nil
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                              oneKeyShareList:nil
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:shareOptions
                            result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess) {
                                    
                                    NSLog(@"分享成功");
                                    
                                } else if (state == SSPublishContentStateFail) {
                                    
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                                
                                //重置相机界面
                                [self setCameraUI];
                                
                            }];

}

#pragma mark - 获取当前日期

- (NSString *)dataFormatter
{
    NSDate *data = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *currentDateStr = [formatter stringFromDate:data];
    
    NSLog(@" 当前时间 %@",currentDateStr);
    
    [formatter release];
    
    return currentDateStr;
}

#pragma mark - 刷新数据

- (void)refreshControlMethod
{
    //判断有无网络
    if ([CheckNetwork isNetworkRunning]) {
        
        if (_refreshBtn) {
            
            [_refreshBtn setHidden:YES];
            
            //在刷新按钮位置，加入指示视图
            [self activityIndicatorViewWithFrame:CGRectMake(WIDTH - 65, rHeignt, 20, 20)];
            //开启转动轮动画
            [self startAnimating];
        }
        
        //刷新天气数据
        if (_cityid) {
            
            [self JSONStartParse:_cityid];
            
        } else if (self.address) {
            
            [self JSONStartParse:[self.cityDic objectForKey:self.address]];
        }
        
    } else {
        
        //清空刷新时间
        _refreshDate.text = @"";
    }
}

#pragma mark - 点击调用相机拍照

- (void)snapPressed:(id)sender
{
    [self.cameraHelper CaptureStillImage];
    
    
    [self performSelector:@selector(didFinishedCapture:) withObject:nil];
    
    if ([CheckNetwork isNetworkRunning]) {
        
        //开启指示视图
        [self activityIndicatorViewWithFrame:CGRectMake(WIDTH/2 - 20, HEIGHT/2, 20, 20)];
        [self startAnimating];
        
    } else {
    
        [self stopAnimating];
    }
}


#pragma mark - 显示天气相机信息

- (void)showInfo
{
    ShowInfoViewController *info = [[ShowInfoViewController alloc]init];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:info];
    
    info.providesPresentationContextTransitionStyle = YES;
    
    [self presentViewController:navi animated:YES completion:nil];
    
    [info release];
    [navi release];
}


#pragma mark - 城市选择的通知响应方法

- (void)selectCity:(NSNotification *)noti
{
    NSString *cityName = [noti.userInfo objectForKey:@"cityName"];
    
    _cityid = [self.cityDic objectForKey:cityName];
    
    NSLog(@"城市编号selectCity：%@",_cityid);
    
    //重新解析新数据
    [self JSONStartParse:_cityid];
}


- (void)selectCityCodeid:(NSNotification *)noti
{
    _cityid = [noti.userInfo objectForKey:@"codeid"];
    
    NSLog(@"城市编号selectCityCodeid：%@",_cityid);
    
    //重新解析新数据
    [self JSONStartParse:_cityid];
}

#pragma mark - 定义天气信息UI

- (void)setBackgroundView1:(UIView *)view1
{
    /**
     当日天气状况
     **/
    //当日温度
    _temp = [[UILabel alloc]init];
    _temp.font = [UIFont systemFontOfSize:34.0f];
    _temp.backgroundColor = [UIColor clearColor];
    _temp.textColor = [UIColor whiteColor];
    _temp.shadowColor = [UIColor grayColor];
    [view1 addSubview:_temp];
    
    //当日天气情况描述
    _weather = [[UILabel alloc]init];
    _weather.backgroundColor = [UIColor clearColor];
    _weather.textColor = [UIColor whiteColor];
    _weather.shadowColor = [UIColor grayColor];
    [view1 addSubview:_weather];
    
    //天气内容
    _content = [[UILabel alloc]init];
    _content.backgroundColor = [UIColor clearColor];
    _content.textColor = [UIColor whiteColor];
    _content.shadowColor = [UIColor grayColor];
    [view1 addSubview:_content];
    
    _wind = [[UILabel alloc]init];
    _wind.backgroundColor = [UIColor clearColor];
    _wind.textColor = [UIColor whiteColor];
    _wind.shadowColor = [UIColor grayColor];
    _wind.font = [UIFont systemFontOfSize:14];
    _wind.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [view1 addSubview:_wind];
    
    
    //日期
    _date = [[UILabel alloc]init];
    _date.backgroundColor = [UIColor clearColor];
    _date.textColor = [UIColor whiteColor];
    _date.shadowColor = [UIColor grayColor];
    _date.font = [UIFont systemFontOfSize:14];
    [view1 addSubview:_date];
   
   
    //显示天气图片
    _imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, rHeignt, 80, 80)];
    [_imgView1 setBackgroundColor:[UIColor clearColor]];
    [view1 addSubview:_imgView1];
    
    _imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(75, rHeignt, 80, 80)];
    [_imgView2 setBackgroundColor:[UIColor clearColor]];
    [view1 addSubview:_imgView2];
    
    //刷新日期
    _refreshDate = [[UILabel alloc]initWithFrame:CGRectMake(60, rHeignt + 80, WIDTH - 60, 20)];
    _refreshDate.backgroundColor = [UIColor clearColor];
    _refreshDate.textColor = [UIColor whiteColor];
    _refreshDate.shadowColor = [UIColor grayColor];
    [view1 addSubview:_refreshDate];

    
    //城市名字
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, rHeignt + 100, WIDTH - 60, 20)];
    [_cityLabel setBackgroundColor:[UIColor clearColor]];
    _cityLabel.textColor = [UIColor whiteColor];
    _cityLabel.shadowColor = [UIColor grayColor];
    [view1 addSubview:_cityLabel];
    
    float font = 22;
    /**
     第二天天气状况
     */
    //天气描述
    _content2 = [[UILabel alloc]init];
    _content2.backgroundColor = [UIColor clearColor];
    _content2.textColor = [UIColor whiteColor];
    _content2.shadowColor = [UIColor grayColor];
    _content2.font = [UIFont systemFontOfSize:font/2];
    [view1 addSubview:_content2];

    //温度范围
    _weather2 = [[UILabel alloc]init];
    _weather2.backgroundColor = [UIColor clearColor];
    _weather2.textColor = [UIColor whiteColor];
    _weather2.shadowColor = [UIColor grayColor];
    _weather2.font = [UIFont systemFontOfSize:font/2];
    [view1 addSubview:_weather2];
    
    //日期
    _date2 = [[UILabel alloc]init];
    _date2.backgroundColor = [UIColor clearColor];
    _date2.textColor = [UIColor whiteColor];
    _date.shadowColor = [UIColor grayColor];
    _date2.font = [UIFont systemFontOfSize:font/2];
    [view1 addSubview:_date2];
    
    
    /**
     第三天天气状况
     */
    //天气描述
    _content3 = [[UILabel alloc]init];
    _content3.backgroundColor = [UIColor clearColor];
    _content3.textColor = [UIColor whiteColor];
    _content3.shadowColor = [UIColor grayColor];
    _content3.font = [UIFont systemFontOfSize:font/2];
    [view1 addSubview:_content3];

    
    //温度范围
    _weather3 = [[UILabel alloc]init];
    _weather3.backgroundColor = [UIColor clearColor];
    _weather3.textColor = [UIColor whiteColor];
    _weather3.shadowColor = [UIColor grayColor];
    _weather3.font = [UIFont systemFontOfSize:font/2];
    [view1 addSubview:_weather3];
    
    //日期
    _date3 = [[UILabel alloc]init];
    _date3.backgroundColor = [UIColor clearColor];
    _date3.textColor = [UIColor whiteColor];
    _date3.shadowColor = [UIColor grayColor];
//    _date3.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _date3.font = [UIFont systemFontOfSize:font/2];
    [view1 addSubview:_date3];
    
    
    //当前位置
    _curLocation = [[UILabel alloc]initWithFrame:CGRectMake(0, vHeight, WIDTH, 40)];
    _curLocation.textAlignment = NSTextAlignmentCenter;
    _curLocation.backgroundColor = [UIColor clearColor];
    _curLocation.textColor = [UIColor whiteColor];
    _curLocation.shadowColor = [UIColor grayColor];
    _curLocation.font = [UIFont systemFontOfSize:14.0f];
    [view1 addSubview:_curLocation];
    
    
    //设计UI界面Frame
    [_temp setFrame:CGRectMake(150, vHeight - 210, 120, 40)];
    [_weather setFrame:CGRectMake(150, vHeight - 170, WIDTH - 150, 20)];
    [_content setFrame:CGRectMake(150, vHeight - 150, 160, 20)];
    [_wind setFrame:CGRectMake(150, vHeight - 130, 170, 20)];
    [_date setFrame:CGRectMake(150, vHeight - 108, 170, 20)];
    
    
    [_content2 setFrame:CGRectMake(150, vHeight - 80, 80, 20)];
    [_weather2 setFrame:CGRectMake(150, vHeight - 60, 80, 20)];
    [_date2  setFrame:CGRectMake(150, vHeight - 40, 80, 20)];
    
    
    [_content3  setFrame:CGRectMake(240, vHeight - 80, 80, 20)];
    [_weather3  setFrame:CGRectMake(240, vHeight - 60, 80, 20)];
    [_date3  setFrame:CGRectMake(240, vHeight - 40, 80, 20)];
    
}


- (void)setBackgroundView2:(UIView *)view2
{
    //当地城市
    _OcityName = [[UILabel alloc]init];
    _OcityName.backgroundColor = [UIColor clearColor];
    _OcityName.textColor = [UIColor whiteColor];
    _OcityName.shadowColor = [UIColor grayColor];
    [view2 addSubview:_OcityName];
    
    _Otemp = [[UILabel alloc]init];
    _Otemp.backgroundColor = [UIColor clearColor];
    _Otemp.textColor = [UIColor whiteColor];
    _Otemp.shadowColor = [UIColor grayColor];
    [view2 addSubview:_Otemp];
    
    //中间细条图片
    UIImageView *barImgView = [[[UIImageView alloc]init]autorelease];
    [barImgView setBackgroundColor:[UIColor clearColor]];
    UIImage *img = [UIImage imageNamed:@"bar.png"];
    barImgView.image = img;
    [view2 addSubview:barImgView];
    
    //显示天气图片
    _OimgView1 = [[UIImageView alloc]init];
    [_OimgView1 setBackgroundColor:[UIColor clearColor]];
    [view2 addSubview:_OimgView1];
    
    _OimgView2 = [[UIImageView alloc]init];
    [_OimgView2 setBackgroundColor:[UIColor clearColor]];
    [view2 addSubview:_OimgView2];

    //时间显示
    _Odate = [[UILabel alloc]init];
    _Odate.backgroundColor = [UIColor clearColor];
    _Odate.textColor = [UIColor whiteColor];
    _Odate.shadowColor = [UIColor grayColor];
    [view2 addSubview:_Odate];
    
    
    //设计UI界面Frame
//    [_OcityName setFrame:CGRectMake(20, vHeight - 380, 100, 20)];
//    [_Otemp setFrame:CGRectMake(20, vHeight - 360, 100, 20)];
//    [barImgView setFrame:CGRectMake(20, vHeight - 330, img.size.width, img.size.height)];
//    [_Odate setFrame:CGRectMake(20, vHeight - 320, WIDTH - 20, 20)];
//    
//    [_OimgView1 setFrame:CGRectMake(120, vHeight - 380, 40, 40)];
//    [_OimgView2 setFrame:CGRectMake(160, vHeight - 380, 40, 40)];
    
    [_OcityName setFrame:CGRectMake(20, rHeignt, 100, 20)];
    [_Otemp setFrame:CGRectMake(20, rHeignt + 20, 100, 20)];
    [barImgView setFrame:CGRectMake(20, rHeignt + 50, img.size.width, img.size.height)];
    [_Odate setFrame:CGRectMake(20, rHeignt + 60, WIDTH - 20, 20)];
    
    [_OimgView1 setFrame:CGRectMake(120, rHeignt, 40, 40)];
    [_OimgView2 setFrame:CGRectMake(160, rHeignt, 40, 40)];

}

- (void)setBackgroundView3:(UIView *)view3
{
    //当地城市
    _Ttemp = [[UILabel alloc]init];
    _Ttemp.font = [UIFont systemFontOfSize:34.0f];
    _Ttemp.backgroundColor = [UIColor clearColor];
    _Ttemp.textColor = [UIColor whiteColor];
    _Ttemp.shadowColor = [UIColor grayColor];
    [view3 addSubview:_Ttemp];
    
    //显示天气图片
    _TimgView1 = [[UIImageView alloc]init];
    [_TimgView1 setBackgroundColor:[UIColor clearColor]];
    [view3 addSubview:_TimgView1];
    
    _TimgView2 = [[UIImageView alloc]init];
    [_TimgView2 setBackgroundColor:[UIColor clearColor]];
    [view3 addSubview:_TimgView2];

    
    _Tdate = [[UILabel alloc]init];
    _Tdate.backgroundColor = [UIColor clearColor];
    _Tdate.textColor = [UIColor whiteColor];
    _Tdate.shadowColor = [UIColor grayColor];
    [view3 addSubview:_Tdate];
    
    _TcityName = [[UILabel alloc]init];
    _TcityName.backgroundColor = [UIColor clearColor];
    _TcityName.textColor = [UIColor whiteColor];
    _TcityName.shadowColor = [UIColor grayColor];
    [view3 addSubview:_TcityName];
    
    _Tcontent = [[UILabel alloc]init];
    _Tcontent.backgroundColor = [UIColor clearColor];
    _Tcontent.textColor = [UIColor whiteColor];
    _Tcontent.shadowColor = [UIColor grayColor];
    [view3 addSubview:_Tcontent];
    
    
    _Twind = [[UILabel alloc]init];
    _Twind.backgroundColor = [UIColor clearColor];
    _Twind.textColor = [UIColor whiteColor];
    _Twind.shadowColor = [UIColor grayColor];
    [view3 addSubview:_Twind];
    
    _Tweather = [[UILabel alloc]init];
    _Tweather.backgroundColor = [UIColor clearColor];
    _Tweather.textColor = [UIColor whiteColor];
    _Tweather.shadowColor = [UIColor grayColor];
    [view3 addSubview:_Tweather];
    
    //明天
    UIView *bg2 = [[[UIView alloc]init]autorelease];
    [bg2 setBackgroundColor:[UIColor blackColor]];
    [bg2 setAlpha:0.5];
    [view3 addSubview:bg2];
    
    _Tdate2 = [[UILabel alloc]init];
    _Tdate2.backgroundColor = [UIColor clearColor];
    _Tdate2.textColor = [UIColor whiteColor];
    _Tdate2.shadowColor = [UIColor grayColor];
    [view3 addSubview:_Tdate2];
    
    _Tweather2 = [[UILabel alloc]init];
    _Tweather2.backgroundColor = [UIColor clearColor];
    _Tweather2.textColor = [UIColor whiteColor];
    _Tweather2.shadowColor = [UIColor grayColor];
    [view3 addSubview:_Tweather2];
    
    //显示天气图片
    _TimgView21 = [[UIImageView alloc]init];
    [_TimgView21 setBackgroundColor:[UIColor clearColor]];
    [view3 addSubview:_TimgView21];
    
    _TimgView22 = [[UIImageView alloc]init];
    [_TimgView22 setBackgroundColor:[UIColor clearColor]];
    [view3 addSubview:_TimgView22];
    
    //后天
    UIView *bg3 = [[[UIView alloc]init]autorelease];
    [bg3 setBackgroundColor:[UIColor blackColor]];
    [bg3 setAlpha:0.5];
    [view3 addSubview:bg3];

    _Tdate3 = [[UILabel alloc]init];
    _Tdate3.backgroundColor = [UIColor clearColor];
    _Tdate3.textColor = [UIColor whiteColor];
    _Tdate3.shadowColor = [UIColor grayColor];
    [view3 addSubview:_Tdate3];
    
    _Tweather3 = [[UILabel alloc]init];
    _Tweather3.backgroundColor = [UIColor clearColor];
    _Tweather3.textColor = [UIColor whiteColor];
    _Tweather3.shadowColor = [UIColor grayColor];
    [view3 addSubview:_Tweather3];
    
    //显示天气图片
    _TimgView31 = [[UIImageView alloc]init];
    [_TimgView31 setBackgroundColor:[UIColor clearColor]];
    [view3 addSubview:_TimgView31];
    
    _TimgView32 = [[UIImageView alloc]init];
    [_TimgView32 setBackgroundColor:[UIColor clearColor]];
    [view3 addSubview:_TimgView32];
    
    
    //设计UI界面Frame
//    //当天
//    [_Ttemp setFrame:CGRectMake(20, vHeight - 380, 100, 40)];
//    [_Tdate setFrame:CGRectMake(20, vHeight - 340, WIDTH - 20, 20)];
//    [_TcityName setFrame:CGRectMake(20, vHeight - 320, WIDTH - 20, 20)];
//    [_Tcontent setFrame:CGRectMake(20, vHeight - 300, WIDTH - 20, 20)];
//    [_Tweather setFrame:CGRectMake(20, vHeight - 280, 100, 20)];
//    [_Twind setFrame:CGRectMake(120, vHeight - 280, WIDTH - 20, 20)];
//    
//    [_TimgView1 setFrame:CGRectMake(120, vHeight - 380, 40, 40)];
//    [_TimgView2 setFrame:CGRectMake(160, vHeight - 380, 40, 40)];
//    
//    //明天
//    [_Tdate2 setFrame:CGRectMake(30, vHeight - 240, 100, 20)];
//    [_Tweather2 setFrame:CGRectMake(30, vHeight - 220, 100, 20)];
//    [_TimgView21 setFrame:CGRectMake(120, vHeight - 240, 40, 40)];
//    [_TimgView22 setFrame:CGRectMake(160, vHeight - 240, 40, 40)];
//    [bg2 setFrame:CGRectMake(20, vHeight - 250, 180, 60)];
//    
//    //后天
//    [_Tdate3 setFrame:CGRectMake(30, vHeight - 160, 100, 20)];
//    [_Tweather3 setFrame:CGRectMake(30, vHeight - 140, 100, 20)];
//
//    [_TimgView31 setFrame:CGRectMake(120, vHeight - 160, 40, 40)];
//    [_TimgView32 setFrame:CGRectMake(160, vHeight - 160, 40, 40)];
//    [bg3 setFrame:CGRectMake(20, vHeight - 170, 180, 60)];
    
    //当天
    [_Ttemp setFrame:CGRectMake(20, rHeignt, 100, 40)];
    [_Tdate setFrame:CGRectMake(20, rHeignt + 40, WIDTH - 20, 20)];
    [_TcityName setFrame:CGRectMake(20, rHeignt + 60, WIDTH - 20, 20)];
    [_Tcontent setFrame:CGRectMake(20, rHeignt + 80, WIDTH - 20, 20)];
    [_Tweather setFrame:CGRectMake(20, rHeignt + 100, 100, 20)];
    [_Twind setFrame:CGRectMake(120, rHeignt + 100, WIDTH - 20, 20)];
    
    [_TimgView1 setFrame:CGRectMake(120, rHeignt, 40, 40)];
    [_TimgView2 setFrame:CGRectMake(160, rHeignt, 40, 40)];
    
    //明天
    [_Tdate2 setFrame:CGRectMake(30, rHeignt + 160, 100, 20)];
    [_Tweather2 setFrame:CGRectMake(30, rHeignt + 180, 100, 20)];
    [_TimgView21 setFrame:CGRectMake(120, rHeignt + 160, 40, 40)];
    [_TimgView22 setFrame:CGRectMake(160, rHeignt + 160, 40, 40)];
    [bg2 setFrame:CGRectMake(20, rHeignt + 150, 180, 60)];
    
    //后天
    [_Tdate3 setFrame:CGRectMake(30, rHeignt + 240, 100, 20)];
    [_Tweather3 setFrame:CGRectMake(30, rHeignt + 260, 100, 20)];
    
    [_TimgView31 setFrame:CGRectMake(120, rHeignt + 240, 40, 40)];
    [_TimgView32 setFrame:CGRectMake(160, rHeignt + 240, 40, 40)];
    [bg3 setFrame:CGRectMake(20, rHeignt + 230, 180, 60)];
    
}

- (void)setBackgroundView4:(UIView *)view4
{
    UIImage *img = [UIImage imageNamed:@"v_three.png"];
    UIImageView *imgView = [[[UIImageView alloc]init]autorelease];
    imgView.image = img;
    [imgView setBackgroundColor:[UIColor clearColor]];
    [view4 addSubview:imgView];
    
    
    _tHDate = [[UILabel alloc]init];
    _tHDate.backgroundColor = [UIColor clearColor];
    _tHDate.textColor = [UIColor whiteColor];
    _tHDate.shadowColor = [UIColor grayColor];
    _tHDate.textAlignment = NSTextAlignmentCenter;
    [view4 addSubview:_tHDate];
    
    
    _tHImgView1 = [[UIImageView alloc]init];
    _tHImgView1.backgroundColor = [UIColor clearColor];
    [view4 addSubview:_tHImgView1];


    _tHImgView2 = [[UIImageView alloc]init];
    _tHImgView2.backgroundColor = [UIColor clearColor];
    [view4 addSubview:_tHImgView2];

    
    _tHArea = [[UILabel alloc]init];
    _tHArea.backgroundColor = [UIColor clearColor];
    _tHArea.textAlignment = NSTextAlignmentCenter;
    [view4 addSubview:_tHArea];
    
    
    [_tHDate setFrame:CGRectMake(20, rHeignt, 80, 20)];
    [_tHImgView1 setFrame:CGRectMake(20, rHeignt + 25, 40, 40)];
    [_tHImgView2 setFrame:CGRectMake(60, rHeignt + 25, 40, 40)];
    [_tHArea setFrame:CGRectMake(20, rHeignt + 70, 80, 20)];
    [imgView setFrame:CGRectMake(10, rHeignt, 95, 100)];
    
}


#pragma mark
#pragma mark - JSON 解析

- (void)JSONStartParse:(NSString *)cityid
{   //101080918
    NSString *URLStr = [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",cityid];
    NSURL *url = [NSURL URLWithString:URLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    //开启状态栏动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - NSURLConnectionDataDelegate method

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.mData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.mData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.mData) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.mData options:NSJSONReadingMutableContainers error:nil];
        
        if (dic) {
            
            //清空天气信息
            _temp.text = @"";
            _weather.text = @"";
            _content.text = @"";
            _wind.text = @"";
            _date.text = @"";
            _imgView1.image = [UIImage imageNamed:@""];
            _imgView2.image = [UIImage imageNamed:@""];
        
            
            //清空当前城市信息
            _cityLabel.text = @"";
            
            
            _content2.text = @"";
            _date2.text = @"";
            _weather2.text = @"";
                
                
            _content3.text = @"";
            _date3.text = @"";
            _weather3.text = @"";
            
            //清空当前位置信息
            _curLocation.text = @"";
            
            //清空刷新时间
            _refreshDate.text = @"";
            
        }
        
        _subDic = [[dic objectForKey:@"weatherinfo"] retain];
        NSLog(@"详细信息：%@",_subDic);
       
        //当天天气
        _temp.text = [NSString stringWithFormat:@"%@℃",[_subDic objectForKey:@"st1"]];
        _weather.text = [_subDic objectForKey:@"weather1"];
        _content.text = [_subDic objectForKey:@"temp1"];
        _wind.text = [_subDic objectForKey:@"wind1"];
        _date.text = [NSString stringWithFormat:@"%@%@",[_subDic objectForKey:@"date_y"],[_subDic objectForKey:@"week"]];
        
    
        //获取天气图片
        NSString *str1 = [_subDic valueForKey:@"img1"];
        NSString *str2 = [_subDic valueForKey:@"img2"];
        UIImage *img1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str1]];
        UIImage *img2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str2]];
        [_imgView1 setImage: img1];
        [_imgView2 setImage: img2];
        
        
        //当前城市
        _cityLabel.text = [_subDic objectForKey:@"city"];
        
        //第二天天气
        _content2.text = [_subDic objectForKey:@"weather2"];
        _weather2.text = [_subDic objectForKey:@"temp2"];
        _date2.text = @"明天";
        
        
        //第三天天气
        _content3.text = [_subDic objectForKey:@"weather3"];
        _weather3.text = [_subDic objectForKey:@"temp3"];
        _date3.text = @"后天";
        
        
        //显示刷新时间
        _refreshDate.text =  [self dataFormatter];
        
        
        //*********************************************************************************
        /** 选择视图One **/
        _OcityName.text = [NSString stringWithFormat:@"%@",[_subDic objectForKey:@"city"]];
        _Otemp.text = [NSString stringWithFormat:@"%@℃",[_subDic objectForKey:@"st1"]];
        NSString *week = [_subDic objectForKey:@"week"];
        if ([week isEqualToString:@"星期一"]) {
            week = @"Monday";
        } else if([week isEqualToString:@"星期二"]){
            week = @"Tuesday";

        }else if([week isEqualToString:@"星期三"]){
            week = @"Wednesday";

        }else if([week isEqualToString:@"星期四"]){
            week = @"Thursday";

        }else if([week isEqualToString:@"星期五"]){
            week = @"Friday";

        }else if([week isEqualToString:@"星期六"]){
            week = @"Saturday";

        }else if([week isEqualToString:@"星期天"]){
            week = @"Sunday";
        }
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY/MM/dd"];
        NSString *currentDateStr = [formatter stringFromDate:date];
        NSLog(@" 当前时间 %@",currentDateStr);
        _Odate.text = [NSString stringWithFormat:@"%@    %@",currentDateStr,week];
        [formatter release];

        //获取天气图片
        NSString *Ostr1 = [_subDic valueForKey:@"img1"];
        NSString *Ostr2 = [_subDic valueForKey:@"img2"];
        UIImage *Oimg1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",Ostr1]];
        UIImage *Oimg2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",Ostr2]];
        [_OimgView1 setImage: Oimg1];
        [_OimgView2 setImage: Oimg2];
        
        /** 选择视图Two **/
        //当天
        _Ttemp.text = [NSString stringWithFormat:@"%@℃",[_subDic objectForKey:@"st1"]];
        _Tweather.text = [_subDic objectForKey:@"weather1"];
        _Tcontent.text = [_subDic objectForKey:@"temp1"];
        _Twind.text = [_subDic objectForKey:@"wind1"];
        _Tdate.text = [NSString stringWithFormat:@"%@%@",[_subDic objectForKey:@"date_y"],[_subDic objectForKey:@"week"]];
        _TcityName.text = [_subDic objectForKey:@"city"];
        
        //获取天气图片
        NSString *Tstr1 = [_subDic valueForKey:@"img1"];
        NSString *Tstr2 = [_subDic valueForKey:@"img2"];
        UIImage *Timg1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",Tstr1]];
        UIImage *Timg2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",Tstr2]];
        [_TimgView1 setImage: Timg1];
        [_TimgView2 setImage: Timg2];

        //明天
        _Tdate2.text = @"明天";
        _Tweather2.text = [_subDic objectForKey:@"temp2"];
        //获取天气图片
        NSString *Tstr21 = [_subDic valueForKey:@"img3"];
        NSString *Tstr22 = [_subDic valueForKey:@"img4"];
        UIImage *Timg21 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",Tstr21]];
        UIImage *Timg22 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",Tstr22]];
        [_TimgView21 setImage: Timg21];
        [_TimgView22 setImage: Timg22];
        
        //后天
        _Tdate3.text = @"后天";
        _Tweather3.text = [_subDic objectForKey:@"temp3"];
        //获取天气图片
        NSString *Tstr31 = [_subDic valueForKey:@"img5"];
        NSString *Tstr32 = [_subDic valueForKey:@"img6"];
        UIImage *Timg31 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",Tstr31]];
        UIImage *Timg32 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",Tstr32]];
        [_TimgView31 setImage: Timg31];
        [_TimgView32 setImage: Timg32];
        
        
        /** 选择视图Three **/
        _tHDate.text = [_subDic objectForKey:@"week"];
        //获取天气图片
        NSString *tHstr1 = [_subDic valueForKey:@"img1"];
        NSString *tHstr2 = [_subDic valueForKey:@"img2"];
        UIImage *tHimg1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",tHstr1]];
        UIImage *tHimg2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",tHstr2]];
        [_tHImgView1 setImage: tHimg1];
        [_tHImgView2 setImage: tHimg2];
        _tHArea.text = self.subLocality;

        
        //停止右上角滚动轮
        [self stopAnimating];
        //显示刷新按钮
        [_refreshBtn setHidden:NO];
        //关闭状态栏动画
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        
    }  else {
        
        //数据为空时，停止菊花动画
        [self stopAnimating];
    }

}

#pragma mark - NSURLConnectionDelegate method

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //失败时，停止菊花动画
    [self stopAnimating];
    
    //打印出出错的主要内容
    NSLog(@"download fail ！%@",[error localizedDescription]);
}


#pragma mark - 指示视图方法

- (void)activityIndicatorViewWithFrame:(CGRect)frame
{
    //展示风火轮和文字
    _loading = [[UIView alloc] initWithFrame:frame];

    //设置进度轮
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    //指定进度轮中心点
    [_activityView setCenter:CGPointMake(20, 20)];
    
    [_loading addSubview:_activityView];
    
    [self.view addSubview:_loading];
}
- (void)stopAnimating
{
    if ([_activityView isAnimating]) {
        
        [_activityView stopAnimating];
        [_loading setHidden:YES];
    }
}
- (void)startAnimating
{
    [_activityView startAnimating];
    [_loading setHidden:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

