//
//  DisclaimerViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-6.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

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
    
    txtView.text = @"版权所有，翻版必究";
    txtView.textAlignment = NSTextAlignmentCenter;
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
