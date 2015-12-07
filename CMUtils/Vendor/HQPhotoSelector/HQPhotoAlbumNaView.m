//
//  PhotoAlbumNaView.m
//  seafishing2
//
//  Created by mac on 14/12/17.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "HQPhotoAlbumNaView.h"
#import "HQPhotoAlbumListView.h"
#import "HQPhotoLibrary.h"
#import "HQAsset.h"
#import "CMConfig.h"
@interface HQPhotoAlbumNaView()
@property (nonatomic,strong) UIColor *itemColor;
@end

@implementation HQPhotoAlbumNaView

- (id)initWithToplimit:(int)toplimit checkedPhoto:(NSArray *)checkedPhoto delegate:(id<HQPhotoAlbumNaViewDelegate>)delegate
{
    self = [super initWithRootViewController:[[HQPhotoAlbumListView alloc] init]];
    if (self)
    {
        for (id image in checkedPhoto)
        {
            id obj;
            if([image isKindOfClass:[HQAsset class]])
            {
                HQAsset *assetImage = (HQAsset *)image;
                obj = assetImage.asset;
                [[HQPHOTO_LIBARARY existsHash] setObject:@(0) forKey:[assetImage.asset valueForProperty:ALAssetPropertyAssetURL]];
            }
            else if([image isKindOfClass:[NSString class]])
            {
                NSString *netImage = (NSString *)image;
                obj = netImage;
                [[HQPHOTO_LIBARARY netPhoto] addObject:netImage];
                [[HQPHOTO_LIBARARY existsHash] setObject:@(0) forKey:netImage];
            }
            [[HQPHOTO_LIBARARY selectedPhoto] addObject:obj];
        }
        [HQPHOTO_LIBARARY setPhotoToplimit:toplimit];
        self.albumdelegate = delegate;
        [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithHex:0x007aff]];
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex:0x007aff]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)presentModalViewControllerAnimated:(BOOL)animated
{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window.rootViewController presentViewController:self animated:YES completion:nil];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithHex:0xffffff]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex:0xffffff]];
    [super dismissViewControllerAnimated:animated completion:nil];
}

- (void)dismissAlbum:(BOOL)animated
{
    NSMutableArray *photoArray = [NSMutableArray arrayWithCapacity:[HQPHOTO_LIBARARY selectedPhoto].count];
    for (id asset in [HQPHOTO_LIBARARY selectedPhoto])
    {
        if([asset isKindOfClass:[ALAsset class]])
        {
            HQAsset *ua = [HQAsset HQAssetWithAsset:asset];
            [photoArray addObject:ua];
        }
        else
        {
            [photoArray addObject:asset];
        }
        
        
    }
    if(self.albumdelegate && [self.albumdelegate respondsToSelector:@selector(photoAlbum:didFinish:)])
    {
        [self.albumdelegate photoAlbum:self didFinish:photoArray];
    }
}

- (void)dealloc
{
    [HQPHOTO_LIBARARY cleanData];
    
}
@end
