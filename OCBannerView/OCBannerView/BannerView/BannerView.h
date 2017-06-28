//
//  BannerView.h
//  OC图片轮播
//
//  Created by 苗治会 on 2017/6/27.
//  Copyright © 2017年 苗治会. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImageClickCallBack)(NSInteger index);

@interface BannerView : UIView

/**
 图片切换间隔
 */
@property(nonatomic,assign)NSTimeInterval timeInterval;

/**
 图片链接地址数据源
 */
@property(nonatomic,strong)NSArray *imageURLArray;

/**
 默认图片
 */
@property(nonatomic,strong)UIImage *placeHoldImage;

/**
 图片点击回调Block
 */
@property(nonatomic,copy)ImageClickCallBack imageClickCallBack;

/**
 开启自动循环
 */
- (void)startAutoPlay;

/**
 停止自动循环
 */
- (void)stopAutoPlay;

/**
 实例化方法
 */
+ (instancetype)bannerView;

@end
