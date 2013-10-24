//
//  CycleScrollView.m
//  TheWeatherReport
//
//  Created by ios on 13-10-22.
//  Copyright (c) 2013年 hxhd. All rights reserved.
//

#import "CycleScrollView.h"

@implementation CycleScrollView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray
{
    self = [super initWithFrame:frame];
    if(self)
    {
        scrollFrame = frame;
        scrollDirection = direction;
        totalPage = pictureArray.count;
        curPage = 1;                                    // 显示的是图片数组里的第一张图片
        curImages = [[NSMutableArray alloc] init];
        imagesArray = [[NSArray alloc] initWithArray:pictureArray];
        
        scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
               
        // 在水平方向滚动
        if(scrollDirection == CycleDirectionLandscape)
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                scrollView.frame.size.height);
        }
        
        // 在垂直方向滚动 
        if(scrollDirection == CycleDirectionPortait)
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                scrollView.frame.size.height * 3);
        }
        
//        [self addSubview:scrollView];
        
        float vHeight;
        //判断ios系统版本
        if (IOS_VERSION >= 7.0) {
            vHeight = HEIGHT - 45;
        } else {
            vHeight = HEIGHT - 65;
        }
        
        //加入分页控制指示标记
        pc = [[UIPageControl alloc]initWithFrame:CGRectMake(0, vHeight - 20, 320, 20)];
        [pc addTarget:self action:@selector(updateCurrentPageDisplayM:) forControlEvents:UIControlEventTouchUpInside];
        pc.numberOfPages = 4;
        [self addSubview:pc];
        
        [self refreshScrollView];
        
//        //加入计时器，使图片无缝隙循环滚动
//        timerCount = 0;
//        scrollDir = 1;//从左往右滚动
//        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    }
    
    return self;
}


////图片循环滚动响应方法
//-(void)scrollTimer
//{
//    timerCount++;
//    
//    if (timerCount == 3) {
//        timerCount = 0;
//        
//        if (scrollDirection == CycleDirectionLandscape) {
//            
//            [scrollView setContentOffset:CGPointMake(scrollFrame.size.width + scrollFrame.size.width * scrollDir, 0) animated:YES];
//        }
//        
//        if (scrollDirection == CycleDirectionPortait) {
//            
//            [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height + scrollFrame.size.height * scrollDir) animated:YES];
//        }
//    }
//}


//
- (void)updateCurrentPageDisplayM:(UIPageControl *)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width,0, viewSize.width, viewSize.height);
    [scrollView scrollRectToVisible:rect animated:YES];
}

//刷新滚动视图
- (void)refreshScrollView {
    
    NSArray *subViews = [scrollView subviews];
    if([subViews count] != 0)
    {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++) {
        
        UIView *view = [[UIView alloc]initWithFrame:scrollFrame];
        view.userInteractionEnabled = YES;
        [view setBackgroundColor:[UIColor clearColor]];
        [view addSubview:[curImages objectAtIndex:i]];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [view addGestureRecognizer:singleTap];
        [singleTap release];
        
        // 水平滚动
        if(scrollDirection == CycleDirectionLandscape) {
            view.frame = CGRectOffset(view.frame, scrollFrame.size.width * i, 0);
        }
        // 垂直滚动
        if(scrollDirection == CycleDirectionPortait) {
            view.frame = CGRectOffset(view.frame, 0, scrollFrame.size.height * i);
        }
        
        [scrollView addSubview:view];
        
        [view release];

        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollFrame];
//        imageView.userInteractionEnabled = YES;
//        imageView.image = [curImages objectAtIndex:i];
//        
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [imageView addGestureRecognizer:singleTap];
//        [singleTap release];
//        
//        // 水平滚动
//        if(scrollDirection == CycleDirectionLandscape) {
//            imageView.frame = CGRectOffset(imageView.frame, scrollFrame.size.width * i, 0);
//        }
//        // 垂直滚动
//        if(scrollDirection == CycleDirectionPortait) {
//            imageView.frame = CGRectOffset(imageView.frame, 0, scrollFrame.size.height * i);
//        }
//        
//        [scrollView addSubview:imageView];
//        [imageView release];

    }
    
    
    if (scrollDirection == CycleDirectionLandscape) {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height)];
    }
}

- (NSArray *)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:curPage-1];
    int last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    
    [curImages addObject:[imagesArray objectAtIndex:pre-1]];
    [curImages addObject:[imagesArray objectAtIndex:curPage-1]];
    [curImages addObject:[imagesArray objectAtIndex:last-1]];
    
    return curImages;
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == 0) value = totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return value;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
//    NSLog(@"did  x=%d  y=%d", x, y);
    
    pc.currentPage = curPage - 1;
    
    // 水平滚动
    if(scrollDirection == CycleDirectionLandscape) {
        // 往下翻一张
        if(x >= (2*scrollFrame.size.width)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(x <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    // 垂直滚动
    if(scrollDirection == CycleDirectionPortait) {
        // 往下翻一张
        if(y >= 2 * (scrollFrame.size.height)) { 
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(y <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]) {
        [delegate cycleScrollViewDelegate:self didScrollImageView:curPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
        
    if (scrollDirection == CycleDirectionLandscape) {
            [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height) animated:YES];
    }
}


- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        [delegate cycleScrollViewDelegate:self didSelectImageView:curPage];
    }
}


- (void)dealloc
{
    [imagesArray release];
    [curImages release];
    [pc release];
    [super dealloc];
}


@end
