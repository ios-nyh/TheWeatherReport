//
//  CompanyLocationViewController.m
//  TheWeatherReport
//
//  Created by ios on 13-9-18.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "CompanyLocationViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "CustomAnnotation.h"

@interface CompanyLocationViewController ()<MKMapViewDelegate>
{
    MKPinAnnotationView *newAnnotation;
}

@property (retain,nonatomic)MKMapView *mapView;
@property (retain,nonatomic)CustomAnnotation *annotation;


@end

@implementation CompanyLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_mapView release];
    [_annotation release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //修改导航栏标题颜色
    NSMutableDictionary *barAttrs = [NSMutableDictionary dictionary];
    [barAttrs setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [barAttrs setObject:[NSValue valueWithUIOffset:UIOffsetMake(0, 0)] forKey:UITextAttributeTextShadowOffset];
    [self.navigationController.navigationBar setTitleTextAttributes:barAttrs];
    
    //导航栏图片：320x44
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBg.png"] forBarMetrics:UIBarMetricsDefault];
    
    //重写左边返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"NaviBack.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    [leftBar release];
    
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 20 - 44)];
    mapView.delegate = self;
    self.mapView = mapView;
    [self.view addSubview:mapView];
    [mapView release];
    
    [self setMapRegion];
    
}

// 自定义返回按钮
- (void)backLeft
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 添加大头针的方法
-(void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords
{
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinate:coords];

    annotation.title = @"北京华信互动数码科技有限公司";
    annotation.subtitle = @"北京海淀区上地十街1号院4号楼1715室";

    [_mapView addAnnotation:annotation];
    
    [annotation release];
}

// 公司位置：40.053126 ---- 116.300133
- (void)setMapRegion
{
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(40.053126,116.300133);
    
    float zoomLevel = 0.008;
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    
    [self createAnnotationWithCoords:coords];
}

// 设置注解视图
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKPinAnnotationView *mkaview in views)
    {
        // 当前位置 的大头针设为紫色，并且没有右边的附属按钮
        if ([mkaview.annotation.title isEqualToString:@"北京华信互动数码科技有限公司"])
        {
            mkaview.pinColor = MKPinAnnotationColorPurple;
            
            mkaview.rightCalloutAccessoryView = nil;
            
            mkaview.animatesDrop = YES;
            
            continue;
        }
        
        newAnnotation = mkaview;
        
        
//        // 其他位置的大头针设为红色，右边添加附属按钮
//        mkaview.pinColor = MKPinAnnotationColorGreen;
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        mkaview.rightCalloutAccessoryView = button;
        
    }
}

// 自动显示注解视图（Callout）
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // 自动显示 Callout
    
    self.annotation = annotation;
    
    [self performSelector:@selector(showCallout) withObject:self afterDelay:0.1];
    
    return newAnnotation;
}

- (void)showCallout
{
    [self.mapView selectAnnotation:self.annotation animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
