//
//  HQPhotoPageVC.m
//  seafishing2
//
//  Created by mac on 14/11/28.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "HQPhotoPageVC.h"
#import "HQPhotoPageOne.h"
#import "UIView+animated.h"
#import "HQPhotoLibrary.h"
#import "HQDotView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "HQPhotoAlbumNaView.h"
#import "CMConfig.h"
typedef NS_ENUM(NSInteger, HQPhotoPageVCTag)
{
    kTitleTag = 1000,
    kConfirmTag,
    kHQDotViewTag,
};
@interface HQPhotoPageVC ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *pageDataSource;
@property (nonatomic,strong) UIButton *selBut;
@property (nonatomic,strong) NSMutableArray *netPhoto;
@property (nonatomic,assign) int index;
@property (nonatomic,assign) BOOL isPreview;//只是图片预览没有选择按钮,和工具栏
@end

@implementation HQPhotoPageVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        {
            // iOS 7
            [self prefersStatusBarHidden];
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
            self.hidesBottomBarWhenPushed = YES;
        }
    }
    return self;
}

- (id)initWithDataSource:(NSMutableArray *)dataSource index:(int)index isPreview:(BOOL)isPreview
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    {
        _isPreview = isPreview;
        _index = index;
        self.dataSource               = self;
        self.pageDataSource           = [NSMutableArray arrayWithArray:dataSource];
        HQPhotoPageOne *onePage = [HQPhotoPageOne HQPhotoPageVCWithAsset:[dataSource objectAtIndex:_index] index:_index placeHolder:nil];
        onePage.delegate = self;
        [self setViewControllers:@[onePage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

- (void)loadTitle
{
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44+20)];
    viewBg.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    [self.view addSubview:viewBg];
    
//    BackIcon@2x
    UIButton *cancel        = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"BackIcon1"] forState:UIControlStateNormal];
    cancel.frame = CGRectMake(0, 0, 64, 64);
    cancel.backgroundColor = [UIColor clearColor];
    [cancel addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [viewBg addSubview:cancel];
    
    UIFont *font           = [UIFont systemFontOfSize:15];
    UILabel *title        = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)*0.5, (44+20 - font.lineHeight)*0.5, 100, font.lineHeight)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor       = [UIColor whiteColor];
    title.textAlignment   = NSTextAlignmentCenter;
    title.tag             = kTitleTag;
    title.text = [NSString stringWithFormat:@"%d/%d",_index+1,_pageDataSource.count];
    [viewBg addSubview:title];
    if(!_isPreview)
    {
        _selBut       = [UIButton buttonWithType:UIButtonTypeCustom];
        _selBut.frame = CGRectMake(SCREEN_WIDTH-64, 0, 64, 64);
        [_selBut addTarget:self action:@selector(selected) forControlEvents:UIControlEventTouchUpInside];
        HQPhotoPageOne *pageOne = [self.viewControllers lastObject];
        _index = pageOne.index;
        
        [self changeRightButton:[HQPHOTO_LIBARARY assetExistsWithAsset:_pageDataSource[_index] assetHandle:NO]];
        [viewBg addSubview:_selBut];
    }
    
}

- (void)selected
{
    ALAsset *asset = _pageDataSource[_index];
    BOOL isExists = [HQPHOTO_LIBARARY assetExistsWithAsset:asset assetHandle:YES];
    [self changeRightButton:isExists];
    [self blueDot];
    
    if([HQPHOTO_LIBARARY limitExceeded])
    {
        DLOG(@"啊哦,到上限了");
//        [MBProgressManager textHudInView:self.view text:@"啊哦,到上限了" isCover:NO delay:1];
    }
    
}



- (void)changeRightButton:(BOOL)isCheck
{
    if(isCheck)
    {
        [_selBut setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
        [UIView viewSpring:_selBut];
    }
    else
    {
        [_selBut setImage:[UIImage imageNamed:@"noCheck"] forState:UIControlStateNormal];
    }
}

- (void)loadToolBar
{
    UIView *toolView = nil;
    if(IsIOS7)
    {
        toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40)];
    }
    else
    {
        toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40-20, SCREEN_WIDTH, 40)];
    }
    
    
    toolView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    [toolView setUserInteractionEnabled:YES];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirm.tag = kConfirmTag;
    if (IsIOS7)
    {
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
//    [confirm setTitle:Locale(@"HQPhotoSelector.confirm") forState:UIControlStateNormal];
//    [confirm setTitle:Locale(@"HQPhotoSelector.confirm") forState:UIControlStateSelected];
    [confirm setTitle:Locale(@"sm.general.ok") forState:UIControlStateNormal];
    [confirm setTitle:Locale(@"sm.general.ok") forState:UIControlStateSelected];

    [confirm setSelected:YES];
    [confirm setFrame:CGRectMake(SCREEN_WIDTH-60, 5, 50, 30)];
    [confirm addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    //[_confirmButton setSelected:YES];
    
    [toolView addSubview:confirm];
    
    
    HQDotView *dotView = [[HQDotView alloc] initWithFrame:CGRectMake(10, 10, 20, 20) withColor:[UIColor colorWithHex:0x1DA4FC]];
    dotView.hidden       = YES;
    dotView.tag          = kHQDotViewTag;

    [toolView addSubview:dotView];
    [self.view addSubview:toolView];
    
}

- (void)cancle
{
//    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    [super loadView];
    [self loadTitle];
    if(!_isPreview)
    {
        [self loadToolBar];
    }
    self.view.backgroundColor = [UIColor blackColor];
    
}

- (void)blueDot
{
    HQDotView *dotView = (HQDotView *)[self.view viewWithTag:kHQDotViewTag];
    int number = [HQPHOTO_LIBARARY selectedCount];
    if(number == 0)
    {
        dotView.hidden = YES;
    }
    else
    {
        dotView.hidden = NO;
        dotView.number = number;
        [UIView viewSpring:dotView];
    }
}

- (void)finish
{
    if([HQPHOTO_LIBARARY selectedCount] == 0)
    {
        [self selected];
    }
    HQPhotoAlbumNaView *nva = (HQPhotoAlbumNaView *)self.navigationController;
    [nva dismissAlbum:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self blueDot];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HQPhotoPageOneDelegate
- (void)HQPhotoPageOneAppear:(int)index
{
    UILabel *title = (UILabel *)[self.view viewWithTag:kTitleTag];
    title.text = [NSString stringWithFormat:@"%d/%d",index+1,_pageDataSource.count];
    if (_isPreview)
    {
        return;
    }
    _index = index;
    ALAsset *asset = [_pageDataSource objectAtIndex:index];
    BOOL isExists = [HQPHOTO_LIBARARY assetExistsWithAsset:asset assetHandle:NO];
    [self changeRightButton:isExists];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(HQPhotoPageOne *)onePage
{
    int index = onePage.index;
    if (index == 0)
    {
        return nil;
    }
    index--;
    HQPhotoPageOne *newOnePage = [HQPhotoPageOne HQPhotoPageVCWithAsset:_pageDataSource[index] index:index placeHolder:nil];
    newOnePage.delegate = self;
    return newOnePage;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(HQPhotoPageOne *)onePage
{
    int index = onePage.index;
    if (index >= _pageDataSource.count - 1)
    {
        return nil;
    }
    index++;
    HQPhotoPageOne *newOnePage = [HQPhotoPageOne HQPhotoPageVCWithAsset:_pageDataSource[index] index:index placeHolder:nil];
    newOnePage.delegate = self;
    return newOnePage;
}

@end
