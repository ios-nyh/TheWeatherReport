//
//  CityViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-12.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "CityViewController.h"
#import "ChineseToPinyin.h"
#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "CheckNetwork.h"

@interface CityViewController () <MBProgressHUDDelegate>
{
    BOOL compareResult;
}

@property (retain,nonatomic) MBProgressHUD *progressHUD;

@end

@implementation CityViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
            
    }
    
    return self; 
}
- (void)dealloc
{
    [_cityArray release];
    [_cityDic release];
    [_cityKeys release];
    [_cityList release];
    
    [_searchBar release];
    [_mData release];
    
    
    [_searchResult release];
    [_mDic release];
    [_nameArray release];
    [_sortArray release];
    
    [super dealloc];
}


//指示视图方法
- (void)MBProgressHUDView
{
    //显示加载等待框
    
    MBProgressHUD *progressHUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    
    self.progressHUD = progressHUD;
    
//    self.progressHUD.mode = MBProgressHUDModeDeterminate;
    
    [self.view addSubview:self.progressHUD];
    
    [self.view bringSubviewToFront:self.progressHUD];
    
    self.progressHUD.delegate = self;
    
    self.progressHUD.labelText = @"加载中...";
    
    [self.progressHUD show:YES];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    NSLog(@"Hud: %@", hud);
    
    // Remove HUD from screen when the HUD was hidded
    
    [self.progressHUD removeFromSuperview];
    
    [_progressHUD release];
    
    _progressHUD = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self MBProgressHUDView];
}

//加载plist文件中的数据
- (void)loadPlistData
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"CityInfo" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.cityDic = dic;
    
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[dic allKeys]];
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
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"热门城市";
    
    //重写左边返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"NaviBack.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];

    
    //解析城市数据
    [self JSONParse];
    
    //加入搜索框
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, WIDTH, 44)];
    searchBar.placeholder = @"搜索城市（中文）";
    
    if (IOS_VERSION >= 7.0) {
        
        searchBar.searchBarStyle = UISearchBarStyleProminent;
        [searchBar setBackgroundImage:[UIImage imageNamed:@"NavigationBg.png"]];
        
    } else {
        
        [searchBar setBackgroundImage:[UIImage imageNamed:@"NavigationBg.png"]];
    }
    
    searchBar.delegate = self;
    self.searchBar = searchBar;
    [self.tableView setTableHeaderView:searchBar];
    [searchBar release];
}

#pragma mark - JSON解析城市数据
- (void)JSONParse
{
    //http://192.168.11.10/josn.php              //测试
    //http://www.coolelife.com/weather/josn.php  //接口
    
    NSString *strURL = [NSString stringWithFormat:CITY_DATA];
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate 异步下载代理方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.mData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.mData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    if (self.mData) {
        
        self.infoArray = [NSJSONSerialization JSONObjectWithData:self.mData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"解析数据：%@",self.infoArray);
    }
    
    NSMutableDictionary *mDictionary = [[NSMutableDictionary alloc]init];
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    
    
    for (NSDictionary *dic in self.infoArray) {
        
        NSString *name = [dic objectForKey:@"name"];
        NSString *codeid = [dic objectForKey:@"codeid"];
        
        [mDictionary setObject:codeid forKey:name];
        [nameArray addObject:name];
    }
    
    self.mDic = mDictionary;
    self.nameArray = nameArray;
    
    [mDictionary release];
    [nameArray release];
    
    if ([CheckNetwork isNetworkRunning]) {
        
        [self hudWasHidden:self.progressHUD];
        
        [self loadPlistData];
        
        [self.tableView reloadData];
    }
}

#pragma - NSURLConnectionDelegate Method
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error ->%@",[error localizedDescription]);
}


#pragma mark - 键盘回收

#pragma mark UIScrollViewDelegate Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}



#pragma mark - UISearchBarDelegate Method

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@ ",searchText];
    
    self.sortArray = [self.nameArray filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}


-  (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    
    if (searchBar.text) {
        
        NSLog(@"搜索城市：%@",searchBar.text);
        
        for (NSDictionary *dic in self.infoArray) {
            
            NSString *name = [dic objectForKey:@"name"];
            NSString *codeid = [dic objectForKey:@"codeid"];
            
           
            if ([searchBar.text isEqualToString:name] ) {
                
                compareResult = YES;
                
                NSDictionary *subDic = [NSDictionary dictionaryWithObjectsAndKeys:codeid,@"codeid", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedCityCodeidNotification" object:nil userInfo:subDic];
                
                NSLog(@"---->%@",codeid);
                
            }
        }
    }
    
    if (compareResult) {
        
         [self dismissViewControllerAnimated:YES completion:nil];
        
    } else {
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"没有此城市，请仔细检查" delegate:self cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        
        [alert release];
    }
   
}

#pragma mark - UIAlertViewDelegate Method 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if ([self.searchBar canBecomeFirstResponder]) {
            
             [self.searchBar becomeFirstResponder];
        }
    }
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
    if (self.sortArray.count > 0) {
        
        return 1;
        
    } else {
        
        return [self.cityKeys count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sortArray.count > 0) {
        
        
        return [self.sortArray count];
        
    } else {
        
        return [[self.cityList objectForKey:[self.cityKeys objectAtIndex:section]] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier]autorelease];
    }
    
    if (self.sortArray.count > 0) {
        
        NSString  *cityName = [self.sortArray objectAtIndex:indexPath.row];
        cell.textLabel.text = cityName;
        
    } else {
        
        NSString  *cityName = [[self.cityList objectForKey:[self.cityKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        cell.textLabel.text = cityName;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.sortArray.count > 0) {
        
        NSString *cityName = [self.sortArray objectAtIndex:indexPath.row];
        
        NSString *codeid = [self.mDic objectForKey:[self.sortArray objectAtIndex:indexPath.row]];
        
        
        NSDictionary *subDic = [NSDictionary dictionaryWithObjectsAndKeys:codeid,@"codeid", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedCityCodeidNotification" object:nil userInfo:subDic];
        
        
        NSLog(@"信息： %@ ** %@",codeid,cityName);
        
    } else {
        
        NSString *cityName = [[self.cityList objectForKey:[self.cityKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cityName,@"cityName", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedCityNotification" object:nil userInfo:dic];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//设置每部分标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.sortArray.count > 0) {
        
        return 0;
        
    } else {
        
        return [self.cityKeys objectAtIndex:section];
    }
}

//添加右侧索引
-  (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.sortArray.count > 0) {
        
        return 0;
        
    } else {
        
        return [self.cityKeys array];
    }
}



@end
