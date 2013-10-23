//
//  CycleScrollView.h
//  TheWeatherReport
//
//  Created by ios on 13-10-22.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    CycleDirectionPortait,          // 垂直滚动
    CycleDirectionLandscape         // 水平滚动
    
} CycleDirection;

@protocol CycleScrollViewDelegate;

@interface CycleScrollView : UIView <UIScrollViewDelegate>
{
    
    UIScrollView *scrollView;
    UIImageView *curImageView;
    
    int totalPage;  
    int curPage;
    CGRect scrollFrame;
    
    CycleDirection scrollDirection;     // scrollView滚动的方向
    NSArray *imagesArray;               // 存放所有需要滚动的图片 UIImage
    NSMutableArray *curImages;          // 存放当前滚动的三张图片
    
    UIPageControl *pc; //分页控制
    
//    int timerCount;//
//    int scrollDir;//
    
    id <CycleScrollViewDelegate> delegate;
}

@property (nonatomic, assign) id <CycleScrollViewDelegate> delegate;

- (int)validPageValue:(NSInteger)value;
- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray;
- (NSArray *)getDisplayImagesWithCurpage:(int)page;
- (void)refreshScrollView;

//- (void)scrollTimer;

@end

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(int)index;
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(int)index;


@end


