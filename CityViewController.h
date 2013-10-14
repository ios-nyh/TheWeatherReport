//
//  CityViewController.h
//  TheWeatherReport
//
//  Created by ios on 13-9-12.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CityViewController : UITableViewController<UISearchBarDelegate,UIScrollViewDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIAlertViewDelegate>



@property (retain,nonatomic) NSMutableArray *cityArray;
@property (retain,nonatomic) NSDictionary *cityDic;

@property (retain,nonatomic) NSMutableOrderedSet *cityKeys;
@property (retain,nonatomic) NSMutableDictionary *cityList;

@property (retain,nonatomic) NSMutableData *mData;

@property (retain,nonatomic) UISearchBar *searchBar;


@property (retain,nonatomic) NSMutableArray *searchResult;
@property (retain,nonatomic) NSMutableDictionary *mDic;
@property (retain,nonatomic) NSMutableArray *nameArray;
@property (retain,nonatomic) NSArray *sortArray;


@property (retain,nonatomic) NSMutableArray *infoArray;


@end

