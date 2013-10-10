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

@interface HomeViewController ()<AVHelperDelegate>
{
    float rHeignt; // 刷新高度
    float vHeight; // 系统高度
    float cHeight; // 截屏高度
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
    
    //指示视图
    [_loading release];
    [_activityView release];
    
    
    [_mData release];
    [_cityDic release];
    [_address release];
    [_location release];
    
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
        
//        if (IOS_VERSION >= 7.0) {
//            
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//            self.extendedLayoutIncludesOpaqueBars = NO;
//            self.modalPresentationCapturesStatusBarAppearance = NO;
//            
//            }
        
    }
    
    return self;
}


#pragma mark - 系统方法，用于拍照
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    //开始实时取景
    [self.cameraHelper startRunning];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.cameraHelper stopRunning];
}


//#pragma mark - 隐藏状态栏
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setNeedsStatusBarAppearanceUpdate];
    
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

    
    //当前背景颜色
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //开始定位服务
    [self startUpdates];

    
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
    [self setBackgroundView:self.view];
    
    
    //初始化相机
    CameraImageHelper *cameraHelper = [[CameraImageHelper alloc]init];
    cameraHelper.delegate = self;
    self.cameraHelper = cameraHelper;
    [cameraHelper release];
    
    
    [self.cameraHelper embedPreviewInView:self.liveView];
    
    
    //刷新按钮
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refreshBtn setFrame:CGRectMake(WIDTH - 50, rHeignt, 50, 38)];
    [_refreshBtn setImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
    [_refreshBtn setImage:[UIImage imageNamed:@"refresh_pressed.png"] forState:UIControlStateHighlighted];
    [_refreshBtn addTarget:self action:@selector(refreshControlMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refreshBtn];
    //给刷新按钮加上阴影效果
    _refreshBtn.layer.shadowOffset = CGSizeMake(0, 0);
    _refreshBtn.layer.shadowOpacity = 0.6;
    _refreshBtn.layer.shadowColor = [UIColor grayColor].CGColor;
    //在刷新按钮位置，加入指示视图
    [self activityIndicatorViewWithFrame:CGRectMake(WIDTH - 50, rHeignt, 20, 20)];

    
    //拍摄按钮
    _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cameraBtn setFrame:CGRectMake(15, vHeight, 50, 38)];
    [_cameraBtn setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    [_cameraBtn setImage:[UIImage imageNamed:@"camera_pressed.png"] forState:UIControlStateHighlighted];
    [_cameraBtn addTarget:self action:@selector(snapPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraBtn];
    
    
    //信息按钮
    _infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_infoBtn setFrame:CGRectMake(WIDTH - 65, vHeight, 50, 38)];
    [_infoBtn setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [_infoBtn setImage:[UIImage imageNamed:@"info_pressed.png"] forState:UIControlStateHighlighted];
    [_infoBtn addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_infoBtn];
    
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
            
            NSLog(@"address dic %@",placemark.addressDictionary);
            NSString *address = [placemark.addressDictionary objectForKey:@"State"];
    

            self.location = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] lastObject];
            
            self.address = address;
                    
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


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            
        case 0:
        {
            [_cameraBtn setHidden:NO];
            [_infoBtn setHidden:NO];
            [_refreshBtn setHidden:NO];
            
            [self.preview setHidden:YES];
            
            _curLocation.text = @"";
            
            _refreshDate.text = [self dataFormatter];
            
        }

            break;
            
        case 1:
        {
            [_refreshBtn setHidden:YES];
            
            UIImage *img = [self captureView:self.view];
            UIImageWriteToSavedPhotosAlbum(img,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
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

                                          cancelButtonTitle:@"OK"

                                          otherButtonTitles:nil];

    [alert show];

    [alert release];
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
    if (_refreshBtn) {
        
        [_refreshBtn setHidden:YES];
        
        //开启转动轮动画
        [self startAnimating];
    }
   
    //判断有无网络
    if ([CheckNetwork isNetworkRunning]) {
        
        //刷新天气数据
        if (_cityid) {
            
            [self JSONStartParse:_cityid];
            
        } else if (self.address) {
            
            [self JSONStartParse:[self.cityDic objectForKey:self.address]];
        }
    }
    
}

#pragma mark - 点击调用相机拍照

- (void)snapPressed:(id)sender
{
    [self.cameraHelper CaptureStillImage];
    
//    [self performSelector:@selector(getImage) withObject:nil afterDelay:0.4];
    
    [self performSelector:@selector(didFinishedCapture:) withObject:nil];
    
    //开启指示视图
    [self activityIndicatorViewWithFrame:CGRectMake(WIDTH/2, HEIGHT/2, 20, 20)];
    [self startAnimating];
}


#pragma mark - 显示天气相机信息

- (void)showInfo
{
    ShowInfoViewController *info = [[ShowInfoViewController alloc]init];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:info];
    

//    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBg_1.png"] forBarMetrics:UIBarMetricsDefault];

    
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

- (void)setBackgroundView:(UIView *)view
{
    /**
     当日天气状况
     */
    //当日温度
    _temp = [[UILabel alloc]init];
    _temp.font = [UIFont systemFontOfSize:34.0f];
    _temp.backgroundColor = [UIColor clearColor];
    _temp.textColor = [UIColor whiteColor];
    _temp.shadowColor = [UIColor grayColor];
    [view addSubview:_temp];
    
    //当日天气情况描述
    _weather = [[UILabel alloc]init];
    _weather.backgroundColor = [UIColor clearColor];
    _weather.textColor = [UIColor whiteColor];
    _weather.shadowColor = [UIColor grayColor];
    [view addSubview:_weather];
    
    //天气内容
    _content = [[UILabel alloc]init];
    _content.backgroundColor = [UIColor clearColor];
    _content.textColor = [UIColor whiteColor];
    _content.shadowColor = [UIColor grayColor];
    [view addSubview:_content];
    
    _wind = [[UILabel alloc]init];
    _wind.backgroundColor = [UIColor clearColor];
    _wind.textColor = [UIColor whiteColor];
    _wind.shadowColor = [UIColor grayColor];
    _wind.font = [UIFont systemFontOfSize:14];
    [view addSubview:_wind];
    
    
    //日期
    _date = [[UILabel alloc]init];
    _date.backgroundColor = [UIColor clearColor];
    _date.textColor = [UIColor whiteColor];
    _date.shadowColor = [UIColor grayColor];
    _date.font = [UIFont systemFontOfSize:14];
    [view addSubview:_date];

    //显示天气图片
    _imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, rHeignt, 80, 80)];
    [_imgView1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_imgView1];
    
    _imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(75, rHeignt, 80, 80)];
    [_imgView2 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_imgView2];
    
    //刷新日期
    _refreshDate = [[UILabel alloc]initWithFrame:CGRectMake(50, rHeignt + 80, 60, 20)];
    _refreshDate.textAlignment = NSTextAlignmentCenter;
    _refreshDate.backgroundColor = [UIColor clearColor];
    _refreshDate.textColor = [UIColor whiteColor];
    _refreshDate.shadowColor = [UIColor grayColor];
    [view addSubview:_refreshDate];

    
    //城市名字
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, rHeignt + 100, 60, 20)];
    _cityLabel.textAlignment = NSTextAlignmentCenter;
    [_cityLabel setBackgroundColor:[UIColor clearColor]];
    _cityLabel.textColor = [UIColor whiteColor];
    _cityLabel.shadowColor = [UIColor grayColor];
    [view addSubview:_cityLabel];
    
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
    [view addSubview:_content2];

    //温度范围
    _weather2 = [[UILabel alloc]init];
    _weather2.backgroundColor = [UIColor clearColor];
    _weather2.textColor = [UIColor whiteColor];
    _weather2.shadowColor = [UIColor grayColor];
    _weather2.font = [UIFont systemFontOfSize:font/2];
    [view addSubview:_weather2];
    
    //日期
    _date2 = [[UILabel alloc]init];
    _date2.backgroundColor = [UIColor clearColor];
    _date2.textColor = [UIColor whiteColor];
    _date.shadowColor = [UIColor grayColor];
    _date2.font = [UIFont systemFontOfSize:font/2];
    [view addSubview:_date2];
    
    
    /**
     第三天天气状况
     */
    //天气描述
    _content3 = [[UILabel alloc]init];
    _content3.backgroundColor = [UIColor clearColor];
    _content3.textColor = [UIColor whiteColor];
    _content3.shadowColor = [UIColor grayColor];
    _content3.font = [UIFont systemFontOfSize:font/2];
    [view addSubview:_content3];

    
    //温度范围
    _weather3 = [[UILabel alloc]init];
    _weather3.backgroundColor = [UIColor clearColor];
    _weather3.textColor = [UIColor whiteColor];
    _weather3.shadowColor = [UIColor grayColor];
    _weather3.font = [UIFont systemFontOfSize:font/2];
    [view addSubview:_weather3];
    
    //日期
    _date3 = [[UILabel alloc]init];
    _date3.backgroundColor = [UIColor clearColor];
    _date3.textColor = [UIColor whiteColor];
    _date3.shadowColor = [UIColor grayColor];
//    _date3.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _date3.font = [UIFont systemFontOfSize:font/2];
    [view addSubview:_date3];
    
    
    //当前位置
    _curLocation = [[UILabel alloc]initWithFrame:CGRectMake(0, vHeight, WIDTH, 40)];
    _curLocation.textAlignment = NSTextAlignmentCenter;
    _curLocation.backgroundColor = [UIColor clearColor];
    _curLocation.textColor = [UIColor whiteColor];
    _curLocation.shadowColor = [UIColor grayColor];
    _curLocation.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:_curLocation];
    
    
    //设计UI界面Frame
    [_temp setFrame:CGRectMake(150, vHeight - 210, 120, 40)];
    [_weather setFrame:CGRectMake(150, vHeight - 170, 120, 20)];
    [_content setFrame:CGRectMake(150, vHeight - 150, 160, 20)];
    [_wind setFrame:CGRectMake(150, vHeight - 130, 170, 20)];
    _wind.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [_date setFrame:CGRectMake(150, vHeight - 108, 170, 20)];
    
    
    [_content2 setFrame:CGRectMake(150, vHeight - 80, 80, 20)];
    [_weather2 setFrame:CGRectMake(150, vHeight - 60, 80, 20)];
    [_date2  setFrame:CGRectMake(150, vHeight - 40, 80, 20)];
    
    
    [_content3  setFrame:CGRectMake(240, vHeight - 80, 80, 20)];
    [_weather3  setFrame:CGRectMake(240, vHeight - 60, 80, 20)];
    [_date3  setFrame:CGRectMake(240, vHeight - 40, 80, 20)];
}


#pragma mark
#pragma mark - JSON 解析

- (void)JSONStartParse:(NSString *)cityid
{
    NSString *URLStr = [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",cityid];
    NSURL *url = [NSURL URLWithString:URLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
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

