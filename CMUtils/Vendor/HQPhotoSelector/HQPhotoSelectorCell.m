//
//  HQPhotoSelectorCell.m
//  seafishing2
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import "HQPhotoSelectorCell.h"
#import "HQPhotoLibrary.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CMConfig.h"
#import "UIView+size.h"

#define BLOG_THUMBNAIL          CGSizeMake(100, 100)

@interface HQPhotoSelectorCell ()
@end


@implementation HQPhotoSelectorCell
#define PHOTO_SIZE ((SCREEN_WIDTH == 375) ? 88 : 75)

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        float imageSize = SCREEN_WIDTH/LineImageNumber;
        _imageViewArray = [NSMutableArray array];
        for (int i = 0; i < LineImageNumber; i++)
        {
            HQMarkView *image = [[HQMarkView alloc] initWithFrame:CGRectMake(1+ i * imageSize, 1, imageSize-2, imageSize-2)];
            image.tag = 100+i;
            UIButton *mark = (UIButton *)[image viewWithTag:100000];
            [image setUserInteractionEnabled:YES];
            [mark addTarget:self action:@selector(clickCheck:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:image];
            [_imageViewArray addObject:image];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
            [image addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)clickImage:(UITapGestureRecognizer *)sender
{
    [self.delegate clickImage:sender];
}

- (void)clickCheck:(UIButton *)sender
{
    [self.delegate clickCheck:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)loadPhoto:(NSMutableArray *)dataSource indexPath:(NSIndexPath *)indexPath
{
    int assetsIndex = 0;
    for (int i = 0; i < LineImageNumber; i++)
    {
        
        HQMarkView *image = (HQMarkView *)[self.contentView viewWithTag:100+i];
        image.hidden = NO;
        image.indexPath = indexPath;
        assetsIndex = indexPath.row*LineImageNumber + i;
        if(assetsIndex < dataSource.count)
        {
            int index = (indexPath.row*LineImageNumber + i);
            id asset = ((ALAsset *)[dataSource objectAtIndex:index]);
            BOOL isExists = NO;
            if([asset isKindOfClass:[ALAsset class]])
            {
                [image setAsset:asset];
                if([[HQPHOTO_LIBARARY existsHash] objectForKey:[asset valueForProperty:ALAssetPropertyAssetURL]])
                {
                    isExists = YES;
                }
                else
                {
                    isExists = NO;
                }
            }
            else if([asset isKindOfClass:[NSString class]])
            {
                image.image = nil;
//                [image setImageWithImageId:asset size:BLOG_THUMBNAIL placeHolder:nil];
                if([[HQPHOTO_LIBARARY existsHash] objectForKey:asset])
                {
                    isExists = YES;
                }
                else
                {
                    isExists = NO;
                }
            }
            [image switchCheckState:isExists];
        }
        else
        {
            image.hidden = YES;
        }
    }
    

}

@end
#pragma mark -image
@interface HQMarkView()

@end

@implementation HQMarkView
//@synthesize mark = _mark;
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        UIButton  *mark = [[UIButton alloc] init];
        mark.tag = 100000;
        [mark setFrame:CGRectMake(self.width-30, 0, 30, 30)];
        [mark setImage:[UIImage imageNamed:@"noCheck"] forState:UIControlStateNormal];
        [mark setImageEdgeInsets:UIEdgeInsetsMake(2, 8, 8, 2)];
        [self addSubview:mark];
    }
    return self;
}

- (void)setAsset:(ALAsset *)asset
{
    [self setImage:[UIImage imageWithCGImage:asset.thumbnail]];
//    [self setURLString:[asset defaultRepresentation].url.absoluteString];
}

- (void)switchCheckState:(BOOL)isCheck
{
    UIButton *mark = (UIButton *)[self viewWithTag:100000];
    
    [mark setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
    if(isCheck)
    {
        [UIView viewSpring:mark];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5f];
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:mark cache:YES];
//        [mark setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
//        [UIView commitAnimations];
    }
    else
    {
        [mark setImage:[UIImage imageNamed:@"noCheck"] forState:UIControlStateNormal];
    }
}
@end
