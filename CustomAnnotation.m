//
//  CustomAnnotation.m
//  CustomerOrder
//
//  Created by ios on 13-8-5.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (void)dealloc
{
    [_title release];
    [_subtitle release];
    
    [super dealloc];
}


- (id)initWithCoordinate:(CLLocationCoordinate2D)coords
{
    
    if (self = [super init]) {
        
        _coordinate = coords;
        
    }

    return self;
}


@end
