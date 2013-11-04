//
//  HTTPDownload.h
//  TheWeatherReport
//
//  Created by iOS on 13-11-1.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPDownload;

@protocol HTTPDownloadDelegate <NSObject>

@optional

- (void)downloadDidFinishLoading:(HTTPDownload *)hd;

- (void)downloadDidFail:(HTTPDownload *)hd;

@end


@interface HTTPDownload : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate,HTTPDownloadDelegate>
{
    NSMutableData *_mData;
    id <HTTPDownloadDelegate>_delegate;
    NSMutableURLRequest *_mRequest;
}

- (void)downloadFromURL:(NSString *)url;  //用get方法，从指定网址下载数据

@property (retain,nonatomic) NSMutableData *mData;
@property (assign,nonatomic) id <HTTPDownloadDelegate>delegate;

@end
