//
//  BannerView.m
//  OC图片轮播
//
//  Created by 苗治会 on 2017/6/27.
//  Copyright © 2017年 苗治会. All rights reserved.
//

#define selfW (self.bounds.size.width)
#define selfH (self.bounds.size.height)

#import "BannerView.h"
#import "UIImageView+WebCache.h"

@interface BannerView ()<UIScrollViewDelegate>

/**
 定时器
 */
@property(nonatomic,strong)NSTimer *timer;

/**
 底层滚动视图
 */
@property(nonatomic,strong)UIScrollView *scrollView;

/**
 pageControl
 */
@property(nonatomic,strong)UIPageControl *pageControl;

/**
 左侧图片
 */
@property(nonatomic,strong)UIImageView *leftImageView;

/**
 中间图片
 */
@property(nonatomic,strong)UIImageView *centerImageView;

/**
 右侧图片
 */
@property(nonatomic,strong)UIImageView *rightImageView;

/**
 当前图片索引
 */
@property(nonatomic,assign)NSInteger currntIndex;

@end

@implementation BannerView

#pragma mark - 初始化方法
+ (instancetype)bannerView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.timeInterval = 3;
        [self.scrollView addSubview:self.leftImageView];
        [self.scrollView addSubview:self.centerImageView];
        [self.scrollView addSubview:self.rightImageView];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

#pragma mark - 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(selfW*3, selfH);
    self.scrollView.contentOffset = CGPointMake(selfW, 0);
    self.leftImageView.frame = CGRectMake(0, 0, selfW, selfH);
    self.centerImageView.frame = CGRectMake(selfW, 0, selfW, selfH);
    self.rightImageView.frame = CGRectMake(selfW*2, 0, selfW, selfH);
    [self.pageControl setCenter:CGPointMake(selfW * 0.5f, selfH - 10.f)];
}

#pragma mark - 重写Set方法
- (void)setImageURLArray:(NSArray *)imageURLArray
{
    _imageURLArray = imageURLArray;
    if(_imageURLArray != nil &&_imageURLArray.count>1)
    {
        self.scrollView.scrollEnabled = YES;
        self.currntIndex = 0;
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[_imageURLArray.count-1]] placeholderImage:self.placeHoldImage];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[self.currntIndex]] placeholderImage:self.placeHoldImage];
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[self.currntIndex+1]] placeholderImage:self.placeHoldImage];
        self.pageControl.numberOfPages = _imageURLArray.count;
        [self startAutoPlay];
    }
    else
    {
        self.scrollView.scrollEnabled = NO;
        if (_imageURLArray.count == 1)
        {
            self.currntIndex = 0;
            [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageURLArray[self.currntIndex]] placeholderImage:self.placeHoldImage];
        }
    }
}

- (void)setPlaceHoldImage:(UIImage *)placeHoldImage
{
    _placeHoldImage = placeHoldImage;
    self.centerImageView.image = _placeHoldImage;
}

#pragma mark - 开启/暂停/重新开始/停止 定时器方法
- (void)startAutoPlay
{
    if (self.timer != nil)
    {
        [self stopAutoPlay];
    }
    if (self.imageURLArray.count)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(startLoopScroll) userInfo:nil repeats:YES];
    }
}

- (void)pauseAutoPlay
{
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)replayAutoPlay
{
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.timeInterval];
}

- (void)stopAutoPlay
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - 开始循环滚动
- (void)startLoopScroll
{
    [self.scrollView setContentOffset:CGPointMake(selfW*2, 0) animated:YES];
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:nil afterDelay:0.4];
}

#pragma mark - scrollView代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self pauseAutoPlay];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self replayAutoPlay];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == 0)
    {
        self.currntIndex = (self.currntIndex-1+self.imageURLArray.count)%self.imageURLArray.count;
    }
    else if (self.scrollView.contentOffset.x == selfW*2)
    {
        self.currntIndex = (self.currntIndex+1)%self.imageURLArray.count;
    }
    else
    {
        return;
    }
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLArray[(self.currntIndex-1+self.imageURLArray.count)%self.imageURLArray.count]] placeholderImage:self.placeHoldImage];
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLArray[self.currntIndex]] placeholderImage:self.placeHoldImage];
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLArray[(self.currntIndex+1)%self.imageURLArray.count]] placeholderImage:self.placeHoldImage];
    self.pageControl.currentPage = self.currntIndex;
    self.scrollView.contentOffset = CGPointMake(selfW, 0);
}

#pragma mark - 手势点击回调
- (void)tapClick
{
    if (self.imageURLArray.count)
    {
        self.imageClickCallBack(self.currntIndex);
    }
}

#pragma mark - 懒加载
- (NSTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [[NSTimer alloc] init];
    }
    return _timer;
}

- (UIScrollView *)scrollView
{
    if(_scrollView == nil)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if(_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    }
    return _pageControl;
}

- (UIImageView *)leftImageView
{
    if(_leftImageView == nil)
    {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

- (UIImageView *)centerImageView
{
    if(_centerImageView == nil)
    {
        _centerImageView = [[UIImageView alloc] init];
        _centerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [_centerImageView addGestureRecognizer:tap];
    }
    return _centerImageView;
}

- (UIImageView *)rightImageView
{
    if(_rightImageView == nil)
    {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

@end
