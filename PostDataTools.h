//
//  PostDataTools.h
//  TheWeatherReport
//
//  Created by iOS on 13-11-1.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostDataTools : NSObject

+ (NSString *)postDataWithPostArgument:(NSString *)argument andAPI:(NSString *)apiURL;

@end
