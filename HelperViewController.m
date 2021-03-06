//
//  HelperViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-6.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "HelperViewController.h"
#import "HomeViewController.h"

//#import "ShowInfoViewController.h"
//#import "MMDrawerController.h"

@interface HelperViewController ()

@end

@implementation HelperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIScrollView *aScrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    aScrollView.contentSize = CGSizeMake(WIDTH * 2, HEIGHT);
    aScrollView.pagingEnabled = YES;
    aScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:aScrollView];
    
    for (int i = 0; i < 2; i++)
    {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        [imgView setBackgroundColor:[UIColor whiteColor]];
        
        if (i == 0) {
            
            [imgView setImage:[UIImage imageNamed:@"helper1.png"]];
            
        } else if(i == 1) {
            
            [imgView setImage:[UIImage imageNamed:@"helper2.png"]];
        }
        
        [aScrollView addSubview:imgView];
        [imgView release];
    }
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(400, HEIGHT - 20 - 49 - 140, 160, 60)];

    [aScrollView addSubview:btn];
    [btn addTarget:self action:@selector(removeHelper) forControlEvents:UIControlEventTouchUpInside];
    [btn release];
    [aScrollView release];
    
}

- (void)removeHelper
{
    HomeViewController *home = [[HomeViewController alloc]init];
    [self presentViewController:home animated:YES completion:nil];
    [home release];
    
    
//    ShowInfoViewController *rightDrawer = [[[ShowInfoViewController alloc]init]autorelease];
//    UINavigationController *naRight = [[[UINavigationController alloc]initWithRootViewController:rightDrawer]autorelease];
//    
//    HomeViewController *home = [[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil]autorelease];
//    UINavigationController *naHome = [[[UINavigationController alloc]initWithRootViewController:home]autorelease];
//    
//    MMDrawerController *drawer = [[MMDrawerController alloc]initWithCenterViewController:naHome rightDrawerViewController:naRight];
//    
//    [drawer setMaximumRightDrawerWidth:280.0f];
//    [drawer setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    [drawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    
//    [self presentViewController:drawer animated:YES completion:nil];
//    
//    [drawer release];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
