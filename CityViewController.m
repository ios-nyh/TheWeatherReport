//
//  CityViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-12.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "CityViewController.h"
#import "ChineseToPinyin.h"

@interface CityViewController ()

@end

@implementation CityViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
//        [self.tableView initWithFrame:CGRectMake(0, 44, WIDTH, HEIGHT - 44) style:UITableViewStylePlain];
        
//        [self.tableView initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        
    }
    
    return self; 
}
- (void)dealloc
{
    [_seachBar release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //重写左边返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"NaviBack.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];

    self.title = @"热门城市";

    NSString *path = [[NSBundle mainBundle]pathForResource:@"CityInfo" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.cityDic = dic;
    
   
    NSMutableArray *array = [NSMutableArray arrayWithArray:[dic allKeys]];
    
//    // 对数组排序
//    NSArray *sortArray = [array sortedArrayUsingSelector:@selector(compare:)];
    
    self.cityArray = [NSMutableArray array];
    self.cityArray = array;
    
    //
    for (int i = 0; i < self.cityArray.count; i++) {
        int min = i;
        for (int j = i + 1; j < self.cityArray.count; j++) {
            NSString *minCityName = [self.cityArray objectAtIndex:min];
            NSString *minCityPinYin = [ChineseToPinyin pinyinFromChiniseString:minCityName];
            NSString *minFirstWord = [minCityPinYin substringToIndex:1];
            
            NSString *cityName = [self.cityArray objectAtIndex:j];
            NSString *cityPinYin = [ChineseToPinyin pinyinFromChiniseString:cityName];
            NSString *firstWord = [cityPinYin substringToIndex:1];
            
            NSComparisonResult result = [minFirstWord compare:firstWord];
            if (result == NSOrderedDescending){
                min = j;
            }
        }
        
        if (min != i) {
            NSString *minCity = [self.cityArray objectAtIndex:min];
            [self.cityArray replaceObjectAtIndex:min withObject:[self.cityArray objectAtIndex:i]];
            [self.cityArray replaceObjectAtIndex:i withObject:minCity];
        }
    }
    
    
    //初始化索引集合和cityList字典
    self.cityKeys = [NSMutableOrderedSet orderedSet];
    self.cityList = [NSMutableDictionary dictionary];

    
    //获取城市列表数据
    for (int i = 0; i < self.cityArray.count; i++) {
        NSString *cityName = [self.cityArray objectAtIndex:i];
        NSString *cityPinYin = [ChineseToPinyin pinyinFromChiniseString:cityName];
        NSString *firstWord = [cityPinYin substringToIndex:1];
        [self.cityKeys addObject:firstWord];
        
        NSMutableArray *cityNames = [self.cityList objectForKey:firstWord];
        if (!cityNames) {
            
            cityNames = [NSMutableArray array];
            [self.cityList setObject:cityNames forKey:firstWord];
        }
        [cityNames addObject:cityName];
    }
    
    
    UISearchBar *seachBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, WIDTH, 44)];
    seachBar.placeholder = @"搜索城市（中文）";
    if (IOS_VERSION >= 7.0) {
        
        seachBar.searchBarStyle = UISearchBarStyleProminent;
        
    } else {
        
        [seachBar setBackgroundImage:[UIImage imageNamed:@"NavigationBg_1.png"]];
    
    }
    
    seachBar.delegate = self;
    self.seachBar = seachBar;
    [self.tableView setTableHeaderView:seachBar];
    [seachBar release];
}

////降序排列
//- (NSComparisonResult)caseInsensitiveCompare:(NSString *)aString
//{
//    return NSOrderedDescending;
//}

#pragma mark - 键盘回收

#pragma mark UIScrollViewDelegate Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.seachBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate Method

-  (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"搜索");
    
    [self.seachBar resignFirstResponder];
}

#pragma mark - 返回按钮

- (void)backLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return [self.cityKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.cityList objectForKey:[self.cityKeys objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier]autorelease];
    }
    
    

    NSString  *cityName = [[self.cityList objectForKey:[self.cityKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cityName;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityName = [[self.cityList objectForKey:[self.cityKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];;
   
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cityName,@"cityName", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedCityNotification" object:nil userInfo:dic];
        
    [self dismissViewControllerAnimated:YES completion:nil];
}


//设置每部分标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.cityKeys objectAtIndex:section];
}

//添加右侧索引
-  (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.cityKeys array];
}



@end
