//
//  DisclaimerViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-6.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITextView *txtView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,HEIGHT - 44)];
    [txtView setEditable:NO];
    [self.view addSubview:txtView];
    
    txtView.text = @"版\n权\n所\n有，翻\n版\n必\n究";
    txtView.textAlignment = NSTextAlignmentCenter;
    [txtView setFont:[UIFont systemFontOfSize:44.0f]];
    [txtView release];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
