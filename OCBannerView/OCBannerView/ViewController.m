//
//  ViewController.m
//  OCBannerView
//
//  Created by 苗治会 on 2017/6/27.
//  Copyright © 2017年 苗治会. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"

@interface ViewController ()

@property (nonatomic, strong) BannerView * bannerView;

@property (nonatomic, strong) NSArray * imageURLArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 实例化
    self.bannerView = [BannerView bannerView];
    self.bannerView.placeHoldImage = [UIImage imageNamed:@"idex_banner"];
    self.bannerView.timeInterval = 5;
    __weak typeof(self) weakSelf = self;
    self.bannerView.imageClickCallBack = ^(NSInteger index) {
        NSString *imageURL = weakSelf.imageURLArray[index];
        NSLog(@"点击的元素 %@",imageURL);
    };
    [self.view addSubview:self.bannerView];
    // 设置约束
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bannerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:188]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.imageURLArray = @[@"http://www.etongdai.com/u/cms/www/201706/131623104i3o.jpg",
                               @"http://www.etongdai.com/u/cms/www/201706/21185312usgf.jpg",
                               @"http://www.etongdai.com/u/cms/www/201706/131408515zux.jpg",
                               @"http://www.etongdai.com/u/cms/www/201706/131740071w4m.jpg"];
        
        self.bannerView.imageURLArray = self.imageURLArray;
    });
}

@end
