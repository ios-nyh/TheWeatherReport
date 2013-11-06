//
//  ProductionCell.m
//  TheWeatherReport
//
//  Created by iOS on 13-11-1.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "ProductionCell.h"

@implementation ProductionCell

- (void)dealloc
{
    [_date release];
    [_content release];
    
    [super dealloc];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _content = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 80)];
        _content.textAlignment = NSTextAlignmentRight;
        _content.numberOfLines = 0;
        _content.backgroundColor = [UIColor colorWithRed:0.004 green:0.671 blue:0.867 alpha:1.0];
        [self addSubview:_content];
        
        _date = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, WIDTH - 20, 20)];
        _date.textAlignment = NSTextAlignmentRight;
        _date.textColor = [UIColor lightGrayColor];
        [self addSubview:_date];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
