//
//  ShowInfoViewController.h
//  TheWeatherReport
//
//  Created by ios on 13-8-30.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowInfoViewControllerDelegate;

@interface ShowInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *_selectCityBtn;
    UIButton *_pressCityBtn;
}

@property (retain,nonatomic) UITableView *tableView;
@property (retain,nonatomic) NSArray *cityArray;
@property (retain,nonatomic) NSDictionary *cityDic;
@property (retain,nonatomic) UILabel *cityLabel;

@property (assign,nonatomic) id <ShowInfoViewControllerDelegate> delegate;

@end


@protocol ShowInfoViewControllerDelegate <NSObject>

@optional

- (void)changeValues:(NSString *)sender;

@end


