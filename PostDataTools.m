//
//  PostDataTools.m
//  TheWeatherReport
//
//  Created by iOS on 13-11-1.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "PostDataTools.h"


@implementation PostDataTools

+ (NSDictionary *)postDataWithPostArgument:(NSString *)argument andAPI:(NSString *)api

{
    NSString *post = [NSString stringWithFormat:@"%@",argument];
    NSLog(@"post %@",post);
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSLog(@"postLength=%@",postLength);
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:api]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    //定义
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[[NSError alloc] init]autorelease];
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dic %@",dic);
    
    return dic;
}


@end
