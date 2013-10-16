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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //修改导航栏标题颜色
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [barAttrs setObject:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)] forKey:UITextAttributeTextShadowOffset];
    [self.navigationController.navigationBar setTitleTextAttributes:barAttrs];

    
    //重写左边返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"NaviBack.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];

    
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
    [urlBtn setTitle:@"http://www.elego.cn" forState:UIControlStateNormal];
    [urlBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [urlBtn addTarget:self action:@selector(openURLMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:urlBtn];
    
    
    UILabel *aboutWeather = [[UILabel alloc]initWithFrame:CGRectMake(40, 160, 100+iconImg.size.width+100, 20)];
    aboutWeather.text = @"天气数据由北京市专业气象台提供";
    [self.view addSubview:aboutWeather];
    [aboutWeather release];
    
    
    UILabel *rights = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT - 20 - 44 - 140 - 20, WIDTH, 140)];
    rights.text = @"Copyright © 2013 HXHD Corporation, All Rights Reserved \n\n 华信互动公司 版权所有";
    rights.numberOfLines = 0;
    rights.font = [UIFont systemFontOfSize:20.0f];
    rights.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:rights];
    [rights release];

}


- (void)openURLMethod
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.elego.cn"]];
}

//自定义返回按钮
- (void)backLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
