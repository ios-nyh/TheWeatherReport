//
//  CameraImageHelper.h
//  TheWeatherReport
//
//  Created by ios on 13-8-29.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@protocol AVHelperDelegate;

@interface CameraImageHelper : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>


@property (retain,nonatomic) AVCaptureSession *session;                 //捕获会话
@property (retain,nonatomic) AVCaptureStillImageOutput *captureOutput;  //捕获输出
@property (retain,nonatomic) UIImage *image;                            //图片
@property (assign,nonatomic) AVCaptureVideoPreviewLayer *preview;       //预览视图
@property (assign,nonatomic) id<AVHelperDelegate> delegate;


- (void) startRunning;
- (void) stopRunning;

- (void)setDelegate:(id<AVHelperDelegate>) _delegate;
- (void)CaptureStillImage;                                               //获取静止的图片
- (void)embedPreviewInView:(UIView *)aView;                              //插入预览视图到主视图中


@end

@protocol AVHelperDelegate <NSObject>

@optional

-(void)didFinishedCapture:(UIImage*)_img;
-(void)foucusStatus:(BOOL)isadjusting;


@end
