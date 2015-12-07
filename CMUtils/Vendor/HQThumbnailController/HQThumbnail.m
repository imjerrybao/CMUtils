//
//  BlogImgView.m
//  seafishing2
//
//  Created by mac on 14/12/19.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "HQThumbnail.h"
#import "HQAsset.h"
#import "APIClient.h"
#import "UIImageView+imageId.h"
typedef NS_ENUM(NSInteger, HQThumbnailTag)
{
    kRemoveTag = 200,
};

@implementation HQThumbnail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = YES;
        
        UIButton *removeButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        removeButton.frame           = CGRectMake(self.frame.size.width-30, 0, 30, 30);
        removeButton.hidden          = NO;
        removeButton.backgroundColor = [UIColor clearColor];
        removeButton.tag             = kRemoveTag;
        [removeButton setImage:[UIImage imageNamed:@"write_log_delete"] forState:UIControlStateNormal];
        [removeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 15, 0)];
        [removeButton addTarget:self action:@selector(removeThumbnail) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:removeButton];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOriginal)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

/**
 *  设置资源
 *
 *  @param asset 资源
 */
- (void)setAsset:(id)asset
{
    _asset = asset;
    self.image = nil;
    if([_asset isKindOfClass:[NSString class]])
    {
        //...
        [self setImageWithImageId:asset placeHolder:nil];
    }
    else if([_asset isKindOfClass:[HQAsset class]])
    {
        self.image = [(HQAsset *)_asset thumbnailImage];
    }
    else if ([_asset isKindOfClass:[UIImage class]])
    {
        self.image = asset;
    } else {
        
    }
}

/**
 *  设置删除按钮
 *
 *  @param show 是否显示
 */
- (void)showRemoveButton:(BOOL)show
{
    UIButton *but = (UIButton *)[self viewWithTag:kRemoveTag];
    but.hidden = !show;
}

/**
 *  设置加号的动作
 *
 *  @param target 目标
 *  @param action 动作
 */
- (void)setPlusAction:(id)target action:(SEL)action
{
    self.image = [UIImage imageNamed:@"write_log_addPhoto"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    [self showRemoveButton:NO];
}

/**
 *  显示原图
 */
- (void)showOriginal
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(showOriginal:)])
    {
        [self.delegate showOriginal:self];
    }
    
}

/**
 *  移除缩略图
 */
- (void)removeThumbnail
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(removeThumbnail:)])
    {
        [self.delegate removeThumbnail:self];
    }
}
@end
