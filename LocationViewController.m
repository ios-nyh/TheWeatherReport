//
//  LocationViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-8-28.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_locationManager release];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showInfo" object:nil];
    [_addressLabel release];
    [_str release];
    [_weather release];
    [_temp release];
    [_imgView1 release];
    [_imgView2 release];
    [_date release];
    [_bgImgView release];
    
    [super dealloc];

}
//
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self startUpdates];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    if (!_bgImgView.image) {
//        
//        [self pickImageFromAlbum];
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *navigation = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    [navigation setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:navigation];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 80, 40)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.showsTouchWhenHighlighted = YES;
    [backBtn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:backBtn];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setFrame:CGRectMake(WIDTH - 80, 0, 80, 40)];
    [selectBtn setTitle:@"选择图片" forState:UIControlStateNormal];
    selectBtn.showsTouchWhenHighlighted = YES;
    [selectBtn addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:selectBtn];
    [navigation release];
    
    _bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, WIDTH, HEIGHT - 20 - 44 - 49)];
    [self.view addSubview:_bgImgView];
    
    //天气展示
    [self setBackgroundView:self.view];
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT - 69, WIDTH, 49)];
    [_addressLabel setBackgroundColor:[UIColor blackColor]];
    [_addressLabel setAlpha:0.8];
    [_addressLabel setTextColor:[UIColor whiteColor]];
    _addressLabel.numberOfLines = 0;
    [self.view addSubview:_addressLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showInfo:) name:@"showInfo" object:nil];
}

#pragma mark-
#pragma mark -- 从用户相册获取活动图片

- (void)pickImageFromAlbum
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:imagePicker animated:YES completion:nil];
    [imagePicker release];
}

#pragma mark - 
#pragma mark - UIImagePickerControllerDelegate 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    _bgImgView.image = image;
        
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先选择图片" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert show];
    [alert release];

}

#pragma mark - 
#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    } 

}
#pragma mark -
#pragma mark - 按钮选择方法
- (void)backVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectImage
{
    [self pickImageFromAlbum];
}


#pragma mark - 
- (void)showInfo:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    
    NSArray *keys = [noti.userInfo allKeys];
    if (keys != nil) {
        NSString *strKey = [keys objectAtIndex:0];
        NSLog(@"tag %d",[strKey integerValue]);
        NSDictionary *subDic = [dic objectForKey:strKey];
        switch ([strKey integerValue]) {
            case 1:
            {
                NSString *strImg1 = [NSString stringWithFormat:@"http://m.weather.com.cn/img/b%@.gif",[subDic valueForKey:@"img1"]];
                NSString *strImg2 = [NSString stringWithFormat:@"http://m.weather.com.cn/img/b%@.gif",[subDic valueForKey:@"img2"]];
                NSURL *urlImg1 = [NSURL URLWithString:strImg1];
                NSURL *urlImg2 = [NSURL URLWithString:strImg2];
                NSData *data1 = [NSData dataWithContentsOfURL:urlImg1];
                NSData *data2 = [NSData dataWithContentsOfURL:urlImg2];
                UIImage *imgPic1 = [[[UIImage alloc] initWithData:data1] autorelease];
                UIImage *imgPic2 = [[[UIImage alloc] initWithData:data2] autorelease];
                [_imgView1 setImage: imgPic1];
                [_imgView2 setImage: imgPic2];
                
                _str.text = [NSString stringWithFormat:@"%@℃",[subDic objectForKey:@"st1"]];
                _weather.text = [subDic objectForKey:@"weather1"];
                _temp.text = [subDic objectForKey:@"temp1"];
                _wind.text = [NSString stringWithFormat:@"%@ %@",[subDic objectForKey:@"wind1"],[subDic objectForKey:@"fl1"]];
                _date.text = [NSString stringWithFormat:@"%@ %@",[subDic objectForKey:@"date_y"],[subDic objectForKey:@"week"]];
            }
                break;
                
            case 2:
            {
                NSString *strImg1 = [NSString stringWithFormat:@"http://m.weather.com.cn/img/b%@.gif",[subDic valueForKey:@"img3"]];
                NSString *strImg2 = [NSString stringWithFormat:@"http://m.weather.com.cn/img/b%@.gif",[subDic valueForKey:@"img4"]];
                NSURL *urlImg1 = [NSURL URLWithString:strImg1];
                NSURL *urlImg2 = [NSURL URLWithString:strImg2];
                NSData *data1 = [NSData dataWithContentsOfURL:urlImg1];
                NSData *data2 = [NSData dataWithContentsOfURL:urlImg2];
                UIImage *imgPic1 = [[[UIImage alloc] initWithData:data1] autorelease];
                UIImage *imgPic2 = [[[UIImage alloc] initWithData:data2] autorelease];
                [_imgView1 setImage: imgPic1];
                [_imgView2 setImage: imgPic2];
                
                _str.text = [NSString stringWithFormat:@"%@℃",[subDic objectForKey:@"st2"]];
                _weather.text = [subDic objectForKey:@"weather2"];
                _temp.text = [subDic objectForKey:@"temp2"];
                _wind.text = [NSString stringWithFormat:@"%@ %@",[subDic objectForKey:@"wind2"],[subDic objectForKey:@"fl2"]];
//                _date.text = [NSString stringWithFormat:@"%@ %@",[subDic objectForKey:@"date_y"],[subDic objectForKey:@"week"]];
            }

                break;
                
            case 3:
            {
                NSString *strImg1 = [NSString stringWithFormat:@"http://m.weather.com.cn/img/b%@.gif",[subDic valueForKey:@"img5"]];
                NSString *strImg2 = [NSString stringWithFormat:@"http://m.weather.com.cn/img/b%@.gif",[subDic valueForKey:@"img6"]];
                NSURL *urlImg1 = [NSURL URLWithString:strImg1];
                NSURL *urlImg2 = [NSURL URLWithString:strImg2];
                NSData *data1 = [NSData dataWithContentsOfURL:urlImg1];
                NSData *data2 = [NSData dataWithContentsOfURL:urlImg2];
                UIImage *imgPic1 = [[[UIImage alloc] initWithData:data1] autorelease];
                UIImage *imgPic2 = [[[UIImage alloc] initWithData:data2] autorelease];
                [_imgView1 setImage: imgPic1];
                [_imgView2 setImage: imgPic2];
                
                _str.text = [NSString stringWithFormat:@"%@℃",[subDic objectForKey:@"st3"]];
                _weather.text = [subDic objectForKey:@"weather3"];
                _temp.text = [subDic objectForKey:@"temp3"];
                _wind.text = [NSString stringWithFormat:@"%@ %@",[subDic objectForKey:@"wind3"],[subDic objectForKey:@"fl3"]];
//                _date.text = [NSString stringWithFormat:@"%@ %@",[subDic objectForKey:@"date_y"],[subDic objectForKey:@"week"]];
            }

                break;

            default:
                break;
        }
    }
    
}

//
- (void)setBackgroundView:(UIView *)view
{
    //当日温度
    _str = [[UILabel alloc]initWithFrame:CGRectMake(160, 60, 120, 40)];
    _str.font = [UIFont systemFontOfSize:34.0f];
    _str.backgroundColor = [UIColor clearColor];
    _str.textColor = [UIColor whiteColor];
    _str.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_str];
    
    //当日天气描述
    _weather = [[UILabel alloc]initWithFrame:CGRectMake(160, 120, 120, 20)];
    _weather.backgroundColor = [UIColor clearColor];
    _weather.textColor = [UIColor whiteColor];
    _weather.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_weather];
    
    //温度范围
    _temp = [[UILabel alloc]initWithFrame:CGRectMake(160, 160, 140, 20)];
    _temp.backgroundColor = [UIColor clearColor];
    _temp.textColor = [UIColor whiteColor];
    [view addSubview:_temp];
    
    //风速描述
    _wind = [[UILabel alloc]initWithFrame:CGRectMake(160, 180, 160, 20)];
    _wind.backgroundColor = [UIColor clearColor];
    _wind.textColor = [UIColor whiteColor];
    [view addSubview:_wind];

    //日期
    _date = [[UILabel alloc]initWithFrame:CGRectMake(160, 200, 140, 20)];
    _date.backgroundColor = [UIColor clearColor];
    _date.textColor = [UIColor whiteColor];
    _date.font = [UIFont systemFontOfSize:14.0f];
    [view addSubview:_date];
    
    //显示天气图片
    _imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 60, 40, 40)];
    [_imgView1 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_imgView1];
    
    _imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(60, 60, 40, 40)];
    [_imgView2 setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_imgView2];
}


#pragma mark - 更新用户位置

- (void)startUpdates
{
    if (_locationManager == nil) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
        [_locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate method 

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coor = location.coordinate;
    _latitude = coor.latitude;
    _longitude = coor.longitude;
    
    NSLog(@"%f----%f",_latitude,_longitude);
    
    [self getCurrentLocation:location];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
}

//
- (void)getCurrentLocation:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark *placemark in placemarks) {
            
            NSLog(@"address dic %@",placemark.addressDictionary);
            NSString *address = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] lastObject];
            NSLog(@"%@",address);
            NSMutableString *mAddress = [NSMutableString stringWithFormat:@"当前位置："];
            [mAddress appendFormat:@"%@",address];
            _addressLabel.text = mAddress;
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        }
    }];
    
    [geocoder release];
    
    [_locationManager stopUpdatingLocation];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
