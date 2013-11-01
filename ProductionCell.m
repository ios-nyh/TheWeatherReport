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
        [self addSubview:_content];
        
        _date = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, WIDTH - 10, 20)];
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
