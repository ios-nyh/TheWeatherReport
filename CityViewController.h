//
//  CityViewController.h
//  TheWeatherReport
//
//  Created by ios on 13-9-12.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CityViewController : UITableViewController<UISearchBarDelegate,UIScrollViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>



@property (retain,nonatomic) NSMutableArray *cityArray;
@property (retain,nonatomic) NSDictionary *cityDic;

@property (retain,nonatomic) NSMutableOrderedSet *cityKeys;
@property (retain,nonatomic) NSMutableDictionary *cityList;

@property (retain,nonatomic) NSMutableData *mData;

@property (retain,nonatomic) UISearchBar *searchBar;


@property (retain,nonatomic) NSArray *tempArray;

@property (retain,nonatomic) NSMutableArray *searchResult;


@end

