//
//  HQPhotoPageVC.m
//  seafishing2
//
//  Created by mac on 14/11/28.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "HQPhotoPageOne.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "CMConfig.h"
@interface HQPhotoPageOne ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSString *netImage;
@end

@implementation HQPhotoPageOne

+ (HQPhotoPageOne *)HQPhotoPageVCWithAsset:(id)asset index:(int)index placeHolder:(UIImage *)placeHolder
{
    HQPhotoPageOne *page = [[HQPhotoPageOne alloc] init];
    page.index = index;
    if([asset isKindOfClass:[ALAsset class]])
    {
//        UIImageOrientation orientation = UIImageOrientationUp;
//        CGImageRef imageRef = [asset defaultRepresentation].fullScreenImage;//获取原始图片
//        
//        //获取图片方向
//        NSNumber* orientationValue = [asset valueForProperty:ALAssetPropertyOrientation];
//        if (orientationValue != nil) {
//            orientation = [orientationValue intValue];
//        }
        
        //设置图片方向
//        UIImage* image = [UIImage imageWithCGImage:imageRef scale:1 orientation:orientation];
//        
//        //调整图片方向
//        image = [image fixOrientation];
//        
//        page.image = image;
        
        page.image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
    }
    else
    {
        page.netImage = asset;
        page.image    = placeHolder;
    }
    return page;
}

- (void)loadView
{
    [super loadView];
    if(IsIOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bouncesZoom = YES;
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.view addSubview:scrollView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.tag = 100;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if(_netImage)
    {
//        MBProgressHUD *hud = [MBProgressManager showWIthLabelAnnularDeterminate:imageView text:nil];
//        hud.taskInProgress = YES;
//        [hud show:YES];
//        imageView.image= _image;
//        __weak UIImageView *weakView = imageView;
//        __weak UIScrollView *weakScroll = scrollView;
//        [imageView setImageWithImageId:_netImage
//                                  size:CGSizeZero
//                           placeHolder:nil
//                         progressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//                             hud.progress = totalBytesRead * 1.0 / totalBytesExpectedToRead;
//                         }
//                            beforeHook:nil
//                             afterHook:^(UIImage *img) {
//                                 hud.taskInProgress = NO;
//                                 [hud hide:NO];
//                                 
//                                 weakView.contentMode = UIViewContentModeScaleAspectFit;
//                                 float height = _image.size.height;
//                                 float outerHeight = weakView.bounds.size.height;
//                                 float hzoom = height / outerHeight;
//                                 if (hzoom < 2) {
//                                     hzoom = 2;
//                                 }
//                                 weakScroll.minimumZoomScale = 1.0;
//                                 weakScroll.maximumZoomScale = hzoom;
//                             }];
    }
    else
    {
        imageView.image = _image;
        float height = _image.size.height;
        float outerHeight = imageView.bounds.size.height;
        float hzoom = height / outerHeight;
        if (hzoom < 2) {
            hzoom = 2;
        }
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = hzoom;
    }
    
    [scrollView addSubview:imageView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.delegate && [self.delegate respondsToSelector:@selector(HQPhotoPageOneAppear:)])
    {
        [self.delegate HQPhotoPageOneAppear:_index];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:100];
    return imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    //当捏或移动时，需要对center重新定义以达到正确显示未知
    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    //双击放大时，图片不能越界，否则会出现空白。因此需要对边界值进行限制。
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:100];
    [imageView setCenter:CGPointMake(xcenter, ycenter)];
}

@end
