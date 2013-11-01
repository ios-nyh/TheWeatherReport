//
//  ProductionViewController.h
//  TheWeatherReport
//
//  Created by ios on 13-10-18.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (retain,nonatomic) UIView *bgView;

@property (retain,nonatomic) UITextField *txt;

@property (retain,nonatomic) UITableView *customTV;

@property (retain,nonatomic) NSMutableArray *contentArray;
@property (retain,nonatomic) NSMutableArray *dateArray;

@end
