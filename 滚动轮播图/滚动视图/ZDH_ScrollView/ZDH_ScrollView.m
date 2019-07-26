//
//  ZDH_ScrollView.m
//  滚动视图
//
//  Created by ZDH on 2019/7/26.
//  Copyright © 2019 ZDH. All rights reserved.
//

#import "ZDH_ScrollView.h"
#define SCROLL_WIDTH CGRectGetWidth(_scrollView.frame)
#define SCROLL_HEIGHT CGRectGetHeight(_scrollView.frame)

#pragma mark - interface
@interface ZDH_ScrollView()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;  //-->分页
    NSInteger imageNum;           //-->图片数量
    NSTimer *_timer;              //-->定时器
    NSInteger _currentPage;       //-->当前显示的页数
    NSTimeInterval _timeInterval;//-->时间间隔
}

@end

@implementation ZDH_ScrollView

#pragma mark - 初始化自定义方法
-(instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWithImageNames:imageNames];
        [self commonInitPageControl];
        
        // 剪裁超出范围的视图
        self.clipsToBounds = YES;
        
    }
    return self;
    
}

#pragma mark - 定时器
//根据指定的时间间隔触发定时器实现自动循环滚动
-(void)scrollWithTimeInterval:(NSTimeInterval)timeInterval{
    _timeInterval = timeInterval;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
}

//重新设定定时器的激活时间
-(void)resetTimerFireDate{
    
    NSDate *nDate= [NSDate dateWithTimeIntervalSinceNow:_timeInterval];
    _timer.fireDate = nDate;
    
}

#pragma mark - 系列初始化方法都在这里
//初始化 ImageView 并添加到主视图上
-(void)commonInitWithImageNames:(NSArray *)imageNames{
    
    //获取图片的个数
    imageNum = imageNames.count;
    
    //初始化 滚动视图
    [self commonInitScrollView];
    
    //添加 UIimageView
    for (int i=0; i<imageNum +2 ; i++) {
        
        //最左侧的视图显示最后一张图片
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
        //图片添加规律为,最左侧视图上显示最后一张图,最右侧视图显示第一张图
        imageV.image = [UIImage imageNamed:imageNames[i==0?(imageNum - 1):(i == (imageNum + 1)?0:(i-1))]];
        
        [_scrollView addSubview:imageV];
        
    }
    
    //默认显示第二个视图
    [self showScrollViewWithPage:1];
    
    
}

// 初始化 UIScrollView 对象
- (void)commonInitScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    [self addSubview:_scrollView];
    
    _scrollView.delegate = self;
    
    // 设置UIScrollView 翻页效果
    _scrollView.pagingEnabled = YES;
    
    // 设置内容宽度 contentSize
    // 为让scrollView循环滚动，在最左侧添加一个视图矩形，在最右侧添加一个视图矩形，所以imageNum+2
    _scrollView.contentSize = CGSizeMake((imageNum+2)*CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    // 设置水平、垂直滑动滚动条不显示
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
}


// 初始化 UIPageControl
- (void)commonInitPageControl
{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-50, CGRectGetWidth(self.frame), 20)];
    
    // 设置 UIPageControl 指示点的颜色
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    // 设置 UIPageControl 指示点的高亮颜色（当前页的颜色）
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    // 设置总页数
    _pageControl.numberOfPages = imageNum;
    
    // 设置当前默认显示的页数
    _pageControl.currentPage = 0;
    
    // 添加目标方法
    [_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:_pageControl];
    
}

#pragma mark - 有关滚动的一些设置在这里

// 根据 UIPageControl 指定页 显示 UIScrollView 的视图
- (void)pageControlValueChanged:(UIPageControl*)pageC
{
    [self showScrollViewWithPage:pageC.currentPage+1];
}

// 自定方法，用于根据当前页数显示指定的 UIScrollView 页面
- (void)showScrollViewWithPage:(NSUInteger)page
{
    _currentPage = page;
    
    // 预防超出总页数
    if (page >= imageNum+1) {
        return;
    }
    
    // 根据当前给定的 page 获取相对应的矩形区域(将要显示的区域)
    CGRect visibleRect = CGRectMake(page*SCROLL_WIDTH, 0, SCROLL_WIDTH, SCROLL_HEIGHT);
    
    // 让 scrollView 滑动到指定要显示的区域
    [_scrollView scrollRectToVisible:visibleRect animated:YES];
    
}
// 自动滚动
- (void)autoScroll
{
    
    // 通过设定 UIView 的动画效果实现 offset移动效果
    [UIView animateWithDuration:.5 animations:^{
        [_scrollView setContentOffset:CGPointMake(++_currentPage*SCROLL_WIDTH, _scrollView.contentOffset.y)];
    }];
    
    [self scrollViewDidEndDecelerating:_scrollView];
    
    // 判断当前页计算量大于理论总页数时，重新赋值
    if (_currentPage > imageNum) {
        _currentPage=1;
    }
    
}

#pragma mark - UIScrollViewDelegate
// 当 UIScrollView 滚动后激发该方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 手动滚动视图后需要重新为定时器设定激活时间
    [self resetTimerFireDate];
    
    // 根据内容 offset 的 x 值计算当前视图的页数
    NSUInteger page = scrollView.contentOffset.x/CGRectGetWidth(self.frame);
    
    // 如果是最左侧视图（显示最后一张图片），scrollView 滚动到倒数第二个视图上（理论中的最后一张图）
    if (page==0) {
        CGRect newRect = CGRectMake(imageNum*CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
        // 让scrollView 滚动到指定的区域
        [_scrollView scrollRectToVisible:newRect animated:NO];
        
        // 设置 UIPageControl 当前页
        _pageControl.currentPage = imageNum - 1;
        _currentPage = _pageControl.currentPage+1;
        return;
    }
    
    // 如果是最右侧视图（显示第一张图片），scrollView 滚动到第二个视图上（理论中的第一张图）
    else if(page==imageNum+1){
        CGRect newRect = CGRectMake(CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [_scrollView scrollRectToVisible:newRect animated:NO];
        // 设置 UIPageControl 当前页
        _pageControl.currentPage = 0;
        _currentPage = _pageControl.currentPage+1;
        return;
    }
    
    // 设置 UIPageControl 当前页
    _pageControl.currentPage = page - 1;
    _currentPage = _pageControl.currentPage+1;
    
}



@end

