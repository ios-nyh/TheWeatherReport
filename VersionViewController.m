//
//  VersionViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-6.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()

@end

@implementation VersionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImage *iconImg = [UIImage imageNamed:@"Icon.png"];

    UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 40, iconImg.size.width, iconImg.size.height)];
    iconImgView.image = iconImg;
    [self.view addSubview:iconImgView];
    
    [iconImgView release];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(80+iconImg.size.width, 40, 100, 40)];
    title.text = @"天气相机";
    title.font = [UIFont systemFontOfSize:24.0f];
    [self.view addSubview:title];
    [title release];
    
    
    UILabel *version = [[UILabel alloc]initWithFrame:CGRectMake(80+iconImg.size.width, 80, 100, 20)];
    version.text = @"V1.0 测试版";
    [self.view addSubview:version];
    [version release];
    
    
    UIButton *urlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [urlBtn setFrame:CGRectMake(60, 120, 100+iconImg.size.width+40, 20)];
    [urlBtn setTitle:@"http://www.apple.com" forState:UIControlStateNormal];
    [urlBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [urlBtn addTarget:self action:@selector(openURLMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:urlBtn];
    
    
    UILabel *aboutWeather = [[UILabel alloc]initWithFrame:CGRectMake(40, 160, 100+iconImg.size.width+100, 20)];
    aboutWeather.text = @"天气数据由北京市专业气象台提供";
    [self.view addSubview:aboutWeather];
    [aboutWeather release];

}


- (void)openURLMethod
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apple.com"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
