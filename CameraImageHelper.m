//
//  CameraImageHelper.m
//  TheWeatherReport
//
//  Created by ios on 13-8-29.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "CameraImageHelper.h"
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <ImageIO/ImageIO.h>

@implementation CameraImageHelper

- (void)dealloc
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device removeObserver:self forKeyPath:@"adjustingFocus"];

    [_session release];
    [_image release];
    [_captureOutput release];
    
    [super dealloc];
}

#pragma mark - 初始化
- (void)initialize
{
    //1.创建会话层
    AVCaptureSession *sesson = [[AVCaptureSession alloc] init];
    self.session = sesson;
    [sesson release];
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //设置图像分辨率
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto]; //AVCaptureSessionPresetPhoto iphone4

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //2.创建、配置输入设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    
#if 1
    //监听自动对焦
    int flags = NSKeyValueObservingOptionNew; 
    [device addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
#endif
    
    
	NSError *error = nil;
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!captureInput)
	{
		NSLog(@"Error: %@", error);
		return;
	}
    
    [self.session addInput:captureInput];
    
    
    //3.创建、配置输出
    AVCaptureStillImageOutput *captureOutput = [[AVCaptureStillImageOutput alloc] init];
    self.captureOutput = captureOutput;
    [captureOutput release];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureOutput setOutputSettings:outputSettings];
    
    [outputSettings release];
	[self.session addOutput:self.captureOutput];
}


- (id)init
{
	if (self = [super init]) {
        
        [self initialize];
    }
    
	return self;
}


//对焦回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if( [keyPath isEqualToString:@"adjustingFocus"]) {
        
        BOOL adjustingFocus = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
        
        NSLog(@"Is adjusting focus ? %@", adjustingFocus ? @"YES" : @"NO" );
        NSLog(@"Change dictionary: %@", change);

        if (_delegate) {
            
            [_delegate foucusStatus:adjustingFocus];
        }
    }
}

#pragma mark - 插入预览视图到主视图
- (void)embedPreviewInView:(UIView *)aView
{
    if (!self.session) {
        
        return;
    }
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //设置取景
    self.preview = [[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session]autorelease];
    self.preview.frame = aView.bounds;    
    
    self.preview.videoGravity = AVLayerVideoGravityResize; // AVLayerVideoGravityResize iphone4
    
    [aView.layer addSublayer:self.preview];
    
       
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}


//- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    if (!self.preview) {
//        return;
//    }
//    [CATransaction begin];
//    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        self.g_orientation = UIImageOrientationUp;
//        self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
//        
//    }else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
//        self.g_orientation = UIImageOrientationDown;
//        self.preview.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
//        
//    }else if (interfaceOrientation == UIDeviceOrientationPortrait){
//        self.g_orientation = UIImageOrientationRight;
//        self.preview.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
//        
//    }else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown){
//        self.g_orientation = UIImageOrientationLeft;
//        self.preview.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
//    }
//    [CATransaction commit];
//}


-(void)giveImg2Delegate
{
    [_delegate didFinishedCapture:self.image];
}

-(void)Captureimage
{
    //get connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) { break; }
    }
    
    //get UIImage
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         
         CFDictionaryRef exifAttachments =
         CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         
         if (exifAttachments) {
             
             // Do something with the attachments.
         }
         
         
         // Continue as appropriate.
         if (imageSampleBuffer != nil) {
             
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             UIImage *t_image = [UIImage imageWithData:imageData];
             UIImage *image = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.5f orientation:UIImageOrientationRight];//orientation：图像方向 UIImageOrientationRight
             self.image = image;
             [image release];
             
             [self giveImg2Delegate];
         }
     }];
}

#pragma mark - Class Interface

- (void)startRunning
{
	[[self session] startRunning];
}

- (void)stopRunning
{
	[[self session] stopRunning];
}

-(void)CaptureStillImage
{
    [self Captureimage];
}


@end
