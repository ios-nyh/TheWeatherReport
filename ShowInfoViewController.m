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
        // Custom initialization
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

//设置竖屏方向
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
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backVC)];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(selectCity)];
    self.navigationItem.rightBarButtonItem = rightBar;

    
    NSArray *infoArray = [NSArray arrayWithObjects:@"关于我们",@"免责声明",@"版本信息", nil];
    self.array = infoArray;
   
    
    //自定义城市表格
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 44 - 20) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    
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
        [self.navigationController pushViewController:about animated:YES];
        [about release];
    } else if (indexPath.row == 1) {
        
        DisclaimerViewController *disclaimer = [[DisclaimerViewController alloc]init];
        [self.navigationController pushViewController:disclaimer animated:YES];
        [disclaimer release];
        
    } else {
        
        VersionViewController *version = [[VersionViewController alloc]init];
        
        [self.navigationController pushViewController:version animated:YES];
        
        [version release];
    
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
