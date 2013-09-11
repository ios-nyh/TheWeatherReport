//
//  ShowInfoViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-8-30.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "ShowInfoViewController.h"

#import "AboutViewController.h"
#import "DisclaimerViewController.h"
#import "VersionViewController.h"


@interface ShowInfoViewController ()

@end

@implementation ShowInfoViewController

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
    [_tableView release];
    [_cityArray release];
    [_cityDic release];
    [_cityLabel release];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showInfo" object:nil];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    NSArray *infoArray = [NSArray arrayWithObjects:@"关于我们",@"免责声明",@"版本信息", nil];
    
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setFrame:CGRectMake(-5, 58*i+(HEIGHT-20-44-4*58)/2, WIDTH+10, 60)];
        [btn setTitle:[NSString stringWithFormat:@"%@",[infoArray objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(chooseOptions:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

    
    //自定义城市表格
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, - (HEIGHT - 44 - 20 - 44), WIDTH, HEIGHT - 44 - 20) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    
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
    
    //城市
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 100)/2, 0, 100, 44)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel = cityLabel;
    [navigation addSubview:cityLabel];
    [cityLabel release];

    //选择城市按钮
    _selectCityBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [_selectCityBtn setFrame:CGRectMake(WIDTH - 80, 0, 80, 44)];
    [_selectCityBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    _selectCityBtn.showsTouchWhenHighlighted = YES;
    [navigation addSubview:_selectCityBtn];
    
    //取消选择城市按钮
    _pressCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pressCityBtn setFrame:CGRectMake(WIDTH - 80, -44, 80, 44)];
    [_pressCityBtn setTitle:@"收起" forState:UIControlStateNormal];
    [_pressCityBtn addTarget:self action:@selector(collectionTableView) forControlEvents:UIControlEventTouchUpInside];
    _pressCityBtn.showsTouchWhenHighlighted = YES;
    [self.view addSubview:_pressCityBtn];
    
    //注册通知，监听城市信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfo:) name:@"showInfo" object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"CityInfo" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.cityDic = dic;
    
    NSArray *array = [[NSArray alloc]init];
    self.cityArray = array;
    [array release];
    self.cityArray = [dic allKeys];
}

#pragma mark -
#pragma mark 按钮响应方法

- (void)backVC
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)selectCity
{
    [_selectCityBtn setHidden:YES];
    [_pressCityBtn setHidden:NO];
    
    [UIView beginAnimations:@"animations" context:nil];
    [UIView setAnimationDuration:0.4f];
    [self.tableView setFrame:CGRectMake(0, 44, WIDTH, HEIGHT - 44 -20)];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"animations" context:nil];
    [UIView setAnimationDuration:0.4f];
    [_pressCityBtn setFrame:CGRectMake(WIDTH - 80, 0, 80, 44)];
    [UIView commitAnimations];

}

- (void)collectionTableView
{
    [UIView beginAnimations:@"animations" context:nil];
    [UIView setAnimationDuration:0.4f];
    [self.tableView setFrame:CGRectMake(0, - (HEIGHT - 44 - 20 - 44), WIDTH, HEIGHT - 44 -20)];
    [UIView commitAnimations];

    
    [UIView beginAnimations:@"animations" context:nil];
    [UIView setAnimationDuration:0.4f];
    [_pressCityBtn setFrame:CGRectMake(WIDTH - 80, -44, 80, 44)];
    [UIView commitAnimations];
    
    [_pressCityBtn setHidden:YES];
    [_selectCityBtn setHidden:NO];
}


//城市
- (void)showInfo:(NSNotification *)noti
{
    NSString *city = [noti.userInfo objectForKey:@"city"];
    
    self.cityLabel.text = city;
}



- (void)chooseOptions:(UIButton *)sender
{
    NSLog(@"选项选择：%d",sender.tag);
    switch (sender.tag) {
        case 0:
        {
            AboutViewController *about = [[AboutViewController alloc]init];
            
//            about.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//            about.providesPresentationContextTransitionStyle = YES;
            
            about.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:about animated:YES completion:nil];
            
            [about release];
            
        }
            break;
            
        case 1:
        {
            DisclaimerViewController *disclaimer = [[DisclaimerViewController alloc]init];
            [self presentViewController:disclaimer animated:YES completion:nil];
            [disclaimer release];
        
        }
            
            break;
            
        case 2:
        {
            VersionViewController *version = [[VersionViewController alloc]init];
            [self presentViewController:version animated:YES completion:nil];
            [version release];
        
        }
            break;

            
        default:
            break;
    }
}


#pragma mark - 
#pragma mark UITableViewDataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    cell.textLabel.text = [self.cityArray objectAtIndex:indexPath.row];
    
    return cell;

}

#pragma mark UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityName = [self.cityArray objectAtIndex:indexPath.row];
    NSLog(@"---- cityName ----%@",cityName);
    
    if ([_delegate respondsToSelector:@selector(changeValues:)]) {
        [_delegate changeValues:[self.cityDic objectForKey:cityName]];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
