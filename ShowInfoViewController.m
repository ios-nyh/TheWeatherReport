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

#import "CityViewController.h"


@interface ShowInfoViewController ()

@end

@implementation ShowInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [_tableView release];
    [_array release];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"showInfo" object:nil];
    
    [super dealloc];
}


////设置竖屏方向
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"更多";
    
    //设置导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBg.png"] forBarMetrics:UIBarMetricsDefault];
    
    //重写左边返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 40)];
    leftBtn.showsTouchWhenHighlighted = YES;
    [leftBtn setImage:[UIImage imageNamed:@"CancelBack.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];

    
    //重写右边返回按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    rightBtn.showsTouchWhenHighlighted = YES;
    [rightBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];


    //www.elego.cn
    
    NSArray *infoArray = [NSArray arrayWithObjects:@"关于我们",@"免责声明",@"版本信息", nil];
    self.array = infoArray;
   
    
    //自定义城市表格
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 44 - 20) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView setBouncesZoom:NO];
    [tableView setBounces:NO];

    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    
    
    UIImage *img = [UIImage imageNamed:@"hxhdClear.png"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT - 240, WIDTH, img.size.height)];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.image = img;
    [self.view addSubview:imgView];
    [imgView release];
    
    //注册通知，监听城市信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfo:) name:@"showInfo" object:nil];
}


#pragma mark 按钮响应方法

- (void)backVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectCity
{
    CityViewController *city = [[CityViewController alloc]init];
    [self.navigationController pushViewController:city animated:YES];
    [city release];
    
}


#pragma mark - 
#pragma mark UITableViewDataSource 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    }
    
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    
    return cell;

}

#pragma mark UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        AboutViewController *about = [[AboutViewController alloc]init];
        about.title = @"关于我们";
        [self.navigationController pushViewController:about animated:YES];
        [about release];
        
    } else if (indexPath.row == 1) {
        
        DisclaimerViewController *disclaimer = [[DisclaimerViewController alloc]init];
        disclaimer.title = @"免责声明";
        [self.navigationController pushViewController:disclaimer animated:YES];
        [disclaimer release];
        
    } else {
        
        VersionViewController *version = [[VersionViewController alloc]init];
        version.title = @"版本信息";
        [self.navigationController pushViewController:version animated:YES];
        [version release];
    }
}

#pragma mark - section 之间的距离
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    view.backgroundColor = [UIColor clearColor];
    return [view autorelease];
}
////section底部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 100;
//}
////section底部视图
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    view.backgroundColor = [UIColor clearColor];
//    return [view autorelease];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
