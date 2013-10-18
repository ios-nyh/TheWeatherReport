//
//  AboutViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-6.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "AboutViewController.h"
#import "CompanyLocationViewController.h"

////判断系统版本
//#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] 
////判断设备版本
//#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface AboutViewController ()
{
    float height; //适配ios6和ios7屏幕
}

@end

@implementation AboutViewController

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

    
    //判断ios版本，进行屏幕适配
    if (IOS_VERSION >= 7.0) {
        
        height = HEIGHT - 44 - 40;
        
    } else {
        
        height = HEIGHT - 44 - 20;
    }

    
    //重写左边返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"NaviBack.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];

    
    //关于我们
    UITextView *txtView = [[UITextView alloc]initWithFrame:CGRectMake(0, 5, WIDTH,HEIGHT - 44 - 100)];
    [txtView setEditable:NO];
    [txtView setFont:[UIFont systemFontOfSize:16.0f]];
    [self.view addSubview:txtView];
    
    
    //点击拨打电话
    UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [telBtn setTitle:@"联系电话：010-62669813-0" forState:UIControlStateNormal];
    [telBtn setTitleColor:[UIColor colorWithRed:0.004 green:0.671 blue:0.867 alpha:1.0] forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(callTel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telBtn];
    
    
    //地址  用户位置：40.053126 ---- 116.300133
    UILabel *address = [[UILabel alloc]init];
    address.text = @"公司地址：北京-海淀区-上地十街-1号院-4号楼-1715室";
    address.textColor = [UIColor colorWithRed:0.004 green:0.671 blue:0.867 alpha:1.0];
    address.numberOfLines = 0;
    [self.view addSubview:address];
   
    
    UIView *view = [[UIView alloc]init];
    [self.view addSubview:view];
    //给地址加上轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addressMap)];
    [view addGestureRecognizer:tap];
   

    //判断是否是iPhone5
    if (iPhone5) {
        
         txtView.text = @"       北京华信互动数码科技有限公司是一家集Internet网站建设，信息收集传播,宣传企业文化，软件开发为一体的信息技术开发公司。本公司致力于政府、企业、学校的系列解决方案。并承接各种软件、网站项目的制作和维护。同时也提供专业技术员、技术团队或技术顾问外包服务。\n\n\n服务宗旨：求实、创新、奋进 \n\n\n提供服务：网站制作/维护 系统/软件开发 网站优化 网站推广";
        
        [address setFrame:CGRectMake(8, height - 120, WIDTH - 5, 60)];
        [view setFrame:CGRectMake(8, height - 120, WIDTH - 5, 60)];
        [telBtn setFrame:CGRectMake(0, height - 120 - 40, 240, 20)];
        
    } else {
        
         txtView.text = @"       北京华信互动数码科技有限公司是一家集Internet网站建设，信息收集传播,宣传企业文化，软件开发为一体的信息技术开发公司。本公司致力于政府、企业、学校的系列解决方案。并承接各种软件、网站项目的制作和维护。同时也提供专业技术员、技术团队或技术顾问外包服务。\n\n服务宗旨：求实、创新、奋进 \n\n提供服务：网站制作/维护 系统/软件开发 网站优化 网站推广";
        
        [address setFrame:CGRectMake(7, height - 110, WIDTH - 7, 60)];
        [view setFrame:CGRectMake(7, height - 110, WIDTH - 7, 60)];
        [telBtn setFrame:CGRectMake(0, height - 60 - 80, 240, 20)];
    }
    
    [txtView release];
    [address release];
    [view release];
    [tap release];
}

#pragma mark - 拨打电话

- (void)callTel
{
    UIWebView *callWebView = [[UIWebView alloc]init];
    NSURL *telURL = [NSURL URLWithString:@"tel:010-62669813"];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebView];
    [callWebView release];
}

#pragma mark - 公司位置

- (void)addressMap
{
    CompanyLocationViewController *comLoc = [[CompanyLocationViewController alloc]init];
    
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:comLoc];
    
    comLoc.title = @"公司位置";
    
    [self presentViewController:navi animated:YES completion:nil];
    
    [comLoc release];
    [navi release];
}

#pragma mark - 自定义返回按钮
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
