//
//  AboutViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-6.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

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
    
    
    //导航视图
    UIView *navigation = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    [navigation setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:navigation];
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 80, 44)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.showsTouchWhenHighlighted = YES;
    [backBtn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:backBtn];
    
    [navigation release];
    
    //关于我们
    UITextView *txtView = [[UITextView alloc]initWithFrame:CGRectMake(0, 44, WIDTH,HEIGHT - 44)];
    [txtView setEditable:NO];
    [self.view addSubview:txtView];
    
    txtView.text = @"\n本公司是一家集Internet网站建设，信息收集传播,宣传企业文化，软件开发为一体的信息技术开发公司。本公司致力于政府、企业、学校的系列解决方案。并承接各种软件、网站项目的制作和维护。同时也提供专业技术员、技术团队或技术顾问外包服务。\n\n\n服务宗旨：求实、创新、奋进 \n提供服务：网站制作/维护 系统/软件开发 网站优化 网站推广 \n联系人：曾超新 \n联系电话：13910284481 \n商家地址：北京-海淀-上地十街-1号院-4号楼-1715室";
    [txtView setFont:[UIFont systemFontOfSize:14.0f]];
    [txtView release];
    
}


#pragma mark - 按钮响应事件
- (void)backVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
