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
#import "LocationViewController.h"
#import "ShowInfoViewController.h"


@interface HomeViewController ()<AVHelperDelegate>

@property (retain,nonatomic) CameraImageHelper *cameraHelper;

@end

@implementation HomeViewController

- (void)dealloc
{
    [_cityLabel release];
    
    [_temp release];
    [_weather release];
    [_content release];
    [_date release];
    
    [_imgView1 release];
    [_imgView2 release];
    
    
    [_weather2 release];
    [_date2 release];
    
    
    [_weather3 release];
    [_date3 release];
    
    
    [_loading release];
    [_activityView release];
    
    
    [_mData release];
    
    
    [_subDic release];
    
    [_preview release];
    [_liveView release];
    
    [_cameraHelper release];
    
    [_cityid release];
    [_curLocation release];
    
    
    [_cityDic release];
    [_locationManager release];
    
    [_address release];
    [_location release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//方向设置
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - 系统方法
- (void)viewWillDisappear:(BOOL)animated
{
    [self.cameraHelper stopRunning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    //开始实时取景
    [self.cameraHelper startRunning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //当前背景颜色
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //开始定位服务
    [self startUpdates];
    
    //获取城市信息
    NSString *path = [[NSBundle mainBundle]pathForResource:@"CityInfo" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.cityDic = dic;
    
    
    //拍摄视图
    UIView *liveView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 20)];
    self.liveView = liveView;
    [self.view addSubview:liveView];
    [liveView release];
    
    //预览视图
    UIImageView *preview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 20)];
//    preview.contentMode = UIViewContentModeScaleAspectFit; //自适应图片宽高比例
    self.preview = preview;
    [self.view addSubview:preview];
    [preview release];
    
    
    //初始化天气信息label
    [self setBackgroundView:self.view];
    
    
    //初始化相机
    CameraImageHelper *cameraHelper = [[CameraImageHelper alloc]init];
    self.cameraHelper = cameraHelper;
    [cameraHelper release];
    [self.cameraHelper embedPreviewInView:self.liveView];
    
    
    //拍摄按钮
    _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cameraBtn setFrame:CGRectMake(15, HEIGHT - 65, 50, 38)];
    [_cameraBtn setImage:[UIImage imageNamed:@"Dock_Btn_2.png"] forState:UIControlStateNormal];
    [_cameraBtn setImage:[UIImage imageNamed:@"Dock_Btn_2_Activated.png"] forState:UIControlStateHighlighted];
    [_cameraBtn addTarget:self action:@selector(snapPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraBtn];
    
    //信息按钮
    _infoBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [_infoBtn setFrame:CGRectMake(WIDTH - 65, HEIGHT - 65, 50, 38)];
    [_infoBtn addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_infoBtn];
}


#pragma mark - 开启定位服务
//需要优化 ？？？？
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
            _curLocation.text = self.location;
            NSLog(@"%@",self.location);
            
            //开始JSON解析
            [self JSONStartParse:[self.cityDic objectForKey:self.address]];
            
            [_locationManager stopUpdatingLocation];
        }
    }];
    
    [geocoder release];
}

#pragma mark - 获取摄像图片

- (void)getImage
{
    [self.preview setHidden:NO];
    
    if ([self.cameraHelper image]) {
        
        self.preview.image = [self.cameraHelper image];
        
        NSLog(@"getImage height %f, width %f",self.preview.image.size.height,self.preview.image.size.width);
        
        
        [_cameraBtn setHidden:YES];
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setFrame:CGRectMake(15, HEIGHT - 65, 50, 38)];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel_pressed.png"] forState:UIControlStateHighlighted];
        [_cancelBtn addTarget:self action:@selector(cancelPhotos:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelBtn];
        
//        //提示，是否保存图片
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
//        
//        [alertView show];
//        [alertView release];
    }
    
    [self stopAnimating];
}

#pragma mark - 对于特定UIView的截屏

- (UIImage *)captureView: (UIView *)theView
{
    //    CGRect rect = theView.frame;
    
    CGRect rect = CGRectMake(0, 0, WIDTH, HEIGHT - 20);
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
            NSLog(@"取消保存");
            break;
            
        case 1:
        {
            [_cancelBtn setHidden:YES];
            [_infoBtn setHidden:YES];
            
            UIImage *img = [self captureView:self.view];
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
            
            [_cancelBtn setHidden:NO];
            [_infoBtn setHidden:NO];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 按钮点击事件

//拍照
- (void)snapPressed:(id)sender {
    
    [self.cameraHelper CaptureStillImage];
    [self performSelector:@selector(getImage) withObject:nil afterDelay:0.4];
    
    //开启指示视图
    [self activityIndicatorView];
    [self startAnimating];
}

//显示信息
- (void)showInfo
{
    ShowInfoViewController *info = [[ShowInfoViewController alloc]init];
    
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:info];
    
    [na.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBg.png"] forBarMetrics:UIBarMetricsDefault];
    info.providesPresentationContextTransitionStyle = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCity:) name:@"selectedCityNotification" object:nil];
    
    [self presentViewController:na animated:YES completion:nil];
    
    [info release];
    [na release];
}

//取消拍照
- (void)cancelPhotos:(UIButton *)sender
{
    [_cancelBtn setHidden:YES];
    [_cameraBtn setHidden:NO];
    
    [self.preview setHidden:YES];
}

//
- (void)selectCity:(NSNotification *)noti
{
    NSString *cityName = [noti.userInfo objectForKey:@"cityName"];
    
    _cityid = [self.cityDic objectForKey:cityName];
    
    NSLog(@"%@",_cityid);
    
    //重新解析新数据
    [self JSONStartParse:_cityid];

}


////详细天气情况选择
//- (void)selectDays:(UIButton *)sender
//{
//    NSLog(@"UIButton %d",sender.tag);
//    LocationViewController *location = [[LocationViewController alloc]init];
//    [self presentViewController:location animated:YES completion:nil];
//    location.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    
//    if (_subDic) {
//        
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_subDic,[NSString stringWithFormat:@"%d",sender.tag],nil];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"showInfo" object:nil userInfo:dic];
//    }
//    
//    [location release];
//}


#pragma mark - 定义天气信息UI
- (void)setBackgroundView:(UIView *)view
{
    /**
     当日天气状况
     */
    //当日温度
    _temp = [[UILabel alloc]initWithFrame:CGRectMake(160, 20, 120, 40)];
    _temp.font = [UIFont systemFontOfSize:34.0f];
    _temp.backgroundColor = [UIColor clearColor];
    _temp.textColor = [UIColor whiteColor];
    _temp.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_temp];
    
    //当日天气情况
    _weather = [[UILabel alloc]initWithFrame:CGRectMake(160, 60, 120, 20)];
    _weather.backgroundColor = [UIColor clearColor];
    _weather.textColor = [UIColor whiteColor];
    _weather.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_weather];
    
    //天气内容
    _content = [[UILabel alloc]initWithFrame:CGRectMake(160, 100, 160, 40)];
    _content.backgroundColor = [UIColor clearColor];
    _content.textColor = [UIColor whiteColor];
    _content.numberOfLines = 0;
    [view addSubview:_content];
    
    //日期
    _date = [[UILabel alloc]initWithFrame:CGRectMake(160, 140, 140, 20)];
    _date.backgroundColor = [UIColor clearColor];
    _date.textColor = [UIColor whiteColor];
    _date.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:_date];
    
    //显示天气图片
    _imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 40, 40)];
    [_imgView1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_imgView1];
    
    _imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(60, 20, 40, 40)];
    [_imgView2 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_imgView2];
    
    //城市名字
    _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 80, 100, 40)];
    [_cityLabel setBackgroundColor:[UIColor clearColor]];
    _cityLabel.textColor = [UIColor whiteColor];
    [view addSubview:_cityLabel];
    
//    UIButton *tapBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    tapBtn1.tag = 1;
//    [tapBtn1 setFrame:CGRectMake(160, 20, WIDTH - 160, 120)];
//    [tapBtn1 addTarget:self action:@selector(selectDays:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:tapBtn1];
    
    /**
     第二天天气状况
     */
    //温度
    
    //温度范围
    _weather2 = [[UILabel alloc]initWithFrame:CGRectMake(160, 200, 100, 20)];
    _weather2.backgroundColor = [UIColor clearColor];
    _weather2.textColor = [UIColor whiteColor];
    [view addSubview:_weather2];
    
    //日期
    _date2 = [[UILabel alloc]initWithFrame:CGRectMake(160, 220, 140, 20)];
    _date2.backgroundColor = [UIColor clearColor];
    _date2.textColor = [UIColor whiteColor];
    _date2.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:_date2];
    
//    UIButton *tapBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    tapBtn2.tag = 2;
//    [tapBtn2 setFrame:CGRectMake(160, 200, WIDTH - 160, 40)];
//    [tapBtn2 addTarget:self action:@selector(selectDays:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:tapBtn2];
    
    /**
     第三天天气状况
     */
    //温度
    
    //温度范围
    _weather3 = [[UILabel alloc]initWithFrame:CGRectMake(160, 260, 100, 20)];
    _weather3.backgroundColor = [UIColor clearColor];
    _weather3.textColor = [UIColor whiteColor];
    [view addSubview:_weather3];
    
    //日期
    _date3 = [[UILabel alloc]initWithFrame:CGRectMake(160, 280, 140, 20)];
    _date3.backgroundColor = [UIColor clearColor];
    _date3.textColor = [UIColor whiteColor];
    _date3.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:_date3];
    
//    UIButton *tapBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    tapBtn3.tag = 3;
//    [tapBtn3 setFrame:CGRectMake(160, 260, WIDTH - 160, 120)];
//    [tapBtn3 addTarget:self action:@selector(selectDays:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:tapBtn3];
    

    
    // 向上擦碰，轻扫
    UISwipeGestureRecognizer *oneFingerSwipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeUp:)] autorelease];
    [oneFingerSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [view addGestureRecognizer:oneFingerSwipeUp];
    
    //当前位置
    _curLocation = [[UILabel alloc]initWithFrame:CGRectMake(65, HEIGHT - 60, WIDTH - 70 - 50, 40)];
    _curLocation.numberOfLines = 0;
    _curLocation.backgroundColor = [UIColor clearColor];
    _curLocation.textColor = [UIColor whiteColor];
    [view addSubview:_curLocation];
    
}

#pragma mark - 轻扫手势响应方法
- (void)oneFingerSwipeUp:(UISwipeGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:[self view]];
    NSLog(@"Swipe up - start location: %f,%f", point.x, point.y);
    
    _temp.text = @"";
    _weather.text = @"";
    _content.text = @"";
    _date.text = @"";
    _imgView1.image = [UIImage imageNamed:@""];
    _imgView2.image = [UIImage imageNamed:@""];
    
    
    _cityLabel.text = @"";
    
    
    _date2.text = @"";
    _weather2.text = @"";
    
    
    _date3.text = @"";
    _weather3.text = @"";
    
    
    if (_cityid) {
        
        NSLog(@"不空");
        [self JSONStartParse:_cityid];
        
    } else {
        
        NSLog(@"空");
        [self JSONStartParse:[self.cityDic objectForKey:self.address]];
    }
}

#pragma mark - 解析
#pragma mark - JSON 解析
- (void)JSONStartParse:(NSString *)cityid
{
    NSString *URLStr = [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",cityid];
    NSURL *url = [NSURL URLWithString:URLStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
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
    //    NSError *error;
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.mData options:NSJSONReadingMutableContainers error:nil];
    
    //    if (error) {
    //
    //        NSLog(@" parse error %@",error);
    //
    //    } else {
    
    //        NSLog(@"解析结果%@",dic);
    
    
    _subDic = [[dic objectForKey:@"weatherinfo"] retain];
    _temp.text = [NSString stringWithFormat:@"%@℃",[_subDic objectForKey:@"st1"]];
    _weather.text = [_subDic objectForKey:@"weather1"];
    _content.text = [NSString stringWithFormat:@"%@\n%@%@",[_subDic objectForKey:@"temp1"],[_subDic objectForKey:@"wind1"],[_subDic objectForKey:@"fl1"]];
    _date.text = [NSString stringWithFormat:@"%@%@",[_subDic objectForKey:@"date_y"],[_subDic objectForKey:@"week"]];
    
    NSString *strImg1 = [NSString stringWithFormat:@"http://m.weather.com.cn/img/b%@.gif",[_subDic valueForKey:@"img1"]];
    NSString *strImg2 = [NSString stringWithFormat:@"http://m.weather.com.cn/img/b%@.gif",[_subDic valueForKey:@"img2"]];
    NSURL *urlImg1 = [NSURL URLWithString:strImg1];
    NSURL *urlImg2 = [NSURL URLWithString:strImg2];
    NSData *data1 = [NSData dataWithContentsOfURL:urlImg1];
    NSData *data2 = [NSData dataWithContentsOfURL:urlImg2];
    UIImage *imgPic1 = [[[UIImage alloc] initWithData:data1] autorelease];
    UIImage *imgPic2 = [[[UIImage alloc] initWithData:data2] autorelease];
    [_imgView1 setImage: imgPic1];
    [_imgView2 setImage: imgPic2];
    
    _cityLabel.text = [_subDic objectForKey:@"city"];
    
    
    _weather2.text = [_subDic objectForKey:@"temp2"];
    _date2.text = @"明天";
    //        _date2.text = [NSString stringWithFormat:@"%@%@",[_subDic objectForKey:@"date_y"],[_subDic objectForKey:@"week"]];
    
    
    _weather3.text = [_subDic objectForKey:@"temp3"];
    _date3.text = @"后天";
    //        _date3.text = [NSString stringWithFormat:@"%@%@",[_subDic objectForKey:@"date_y"],[_subDic objectForKey:@"week"]];
    
    //    }
    
    
    //关闭状态栏动画
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}
#pragma mark - NSURLConnectionDelegate method
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"download fail %@",error);
}


#pragma mark - 指示视图方法
- (void)activityIndicatorView
{
    //展示风火轮和文字
    _loading = [[UIView alloc] initWithFrame:CGRectMake(110, 120, 100, 100)];
    _loading.backgroundColor = [UIColor blackColor];
    _loading.layer.cornerRadius = 20;
    
    //    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, 100, 20)];
    //    [label setBackgroundColor:[UIColor clearColor]];
    //    [label setText:@"loading..."];
    //    [label setTextColor:[UIColor whiteColor]];
    //    [label setTextAlignment:NSTextAlignmentCenter];
    //    [_loading addSubview:label];
    //    [label release];
    
    //设置进度轮
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_activityView setCenter:CGPointMake(50, 50)];//指定进度轮中心点
    [_loading addSubview:_activityView];
    
    [self.view addSubview:_loading];
}
- (void)stopAnimating
{
    [_activityView stopAnimating];
    [_loading setHidden:YES];
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

