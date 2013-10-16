//
//  ShowInfoViewController.h
//  TheWeatherReport
//
//  Created by ios on 13-8-30.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>



@property (retain,nonatomic) UITableView *tableView;

@property (retain,nonatomic) NSArray *array;

@property (retain,nonatomic) NSArray *imgArray;





@end



