//
//  PhotoLibrary.m
//  seafishing2
//
//  Created by mac on 14/12/17.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "HQPhotoLibrary.h"
@interface HQPhotoLibrary()
@property (nonatomic,assign) int photoToplimit;//照片上限
@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;

@end
@implementation HQPhotoLibrary
+ (HQPhotoLibrary *)sharedInstance
{
    static dispatch_once_t onceToken;
    static HQPhotoLibrary *photoLibrary = nil;
    dispatch_once(&onceToken, ^{
        photoLibrary = [[HQPhotoLibrary alloc] init];
    });
    return photoLibrary;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        _selectedPhoto = [NSMutableArray array];
        _netPhoto      = [NSMutableArray array];
        _existsHash    = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)assetExistsWithAsset:(id)asset assetHandle:(BOOL)assetHandle
{
    for (id selected in HQPHOTO_LIBARARY.selectedPhoto)
    {
        //先这么判断.应该可以用更好的方法代替
        if(
           ([selected isKindOfClass:[ALAsset class]] && [asset isKindOfClass:[ALAsset class]]) ||
           ([selected isKindOfClass:[NSString class]] && [asset isKindOfClass:[NSString class]])
           )
        {
            if([selected isKindOfClass:[ALAsset class]])
            {
                ALAsset *selectedALAsset = selected;
                if([[selectedALAsset valueForProperty:ALAssetPropertyAssetURL] isEqual:[asset valueForProperty:ALAssetPropertyAssetURL]])
                {
                    if(assetHandle)
                    {
                        [HQPHOTO_LIBARARY.selectedPhoto removeObject:selectedALAsset];
                        [_existsHash removeObjectForKey:[selectedALAsset valueForProperty:ALAssetPropertyAssetURL]];
                        return NO;//如果处理asset 返回的结果应该是反的
                    }
                    return YES;
                }
            }
            else if([selected isKindOfClass:[NSString class]])
            {
                NSString *selectedALAsset = selected;
                if([selectedALAsset isEqualToString:asset])
                {
                    if(assetHandle)
                    {
                        [HQPHOTO_LIBARARY.selectedPhoto removeObject:selectedALAsset];
                        [_existsHash removeObjectForKey:selectedALAsset];
                        return NO;//如果处理asset 返回的结果应该是反的
                    }
                    return YES;
                }
            }
        }
    }
    if(assetHandle && ![HQPHOTO_LIBARARY limitExceeded])
    {
        [HQPHOTO_LIBARARY.selectedPhoto addObject:asset];
        if([asset isKindOfClass:[ALAsset class]])
        {
            [_existsHash setObject:@(0) forKey:[asset valueForProperty:ALAssetPropertyAssetURL]];
        }
        else
        {
            [_existsHash setObject:@(0) forKey:asset];
        }
        
        return YES;
    }
    return NO;
}

- (BOOL)limitExceeded
{
    if([self selectedCount] < HQPHOTO_LIBARARY.photoToplimit )
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)cleanData
{
    _photoToplimit = 0;
    [_selectedPhoto removeAllObjects];
    [_existsHash removeAllObjects];
    [_netPhoto removeAllObjects];
}

- (int)selectedCount
{
    return self.existsHash.allKeys.count;
}
@end
