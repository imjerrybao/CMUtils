//
//  PhotoWallView.m
//  CMUtils
//
//  Created by Jerry on 15/6/17.
//  Copyright (c) 2015年 Jerry Inc. All rights reserved.
//

#import "PhotoWallView.h"
#import "Hex62To11.h"
#import "IDMPhotoBrowser.h"
#import "CMUtils.h"
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import <UIKit/UIKit.h>
#import "Masonry.h"
#define PhotoNumMax 9
#define ImageBaseTag 1000
#define SPACING      2

@interface PhotoWallView()
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic) CGFloat width;
@end

@implementation PhotoWallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < PhotoNumMax; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            NSInteger tag = ImageBaseTag + i;
            imageView.tag = tag;
            imageView.userInteractionEnabled = YES;
            [self addSubview:imageView];
            
            __weak typeof(self) wSelf = self;
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
                [wSelf tapImageViewWithTag:i view:sender.view];
            }];
            [imageView addGestureRecognizer:imageTap];
            
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        for (int i = 0; i < PhotoNumMax; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            NSInteger tag = ImageBaseTag + i;
            imageView.tag = tag;
            imageView.userInteractionEnabled = YES;
            [self addSubview:imageView];
            
            __weak typeof(self) wSelf = self;
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
                [wSelf tapImageViewWithTag:i view:sender.view];
            }];
            [imageView addGestureRecognizer:imageTap];
            
        }
    }
    return self;
}

- (void)photoWithArray:(NSArray *)arrayImage width:(CGFloat)width
{
    _width = width;
    CGFloat ONE_PHOTO_WIDTH   =  (width-20);
    CGFloat ONE_PHOTO_HEIGHT   = (width-100);
    CGFloat TWO_PHOTO_WIDTH    = (width-SPACING)/2;
    CGFloat THREE_PHOTO_WIDTH  = (width-SPACING*2)/3;

    NSInteger count = arrayImage.count;
    _imageArr= arrayImage;
    CGPoint pointPhoto;
    for (int index = 0; index < PhotoNumMax; index++) {
        UIImageView *imagePhoto = (UIImageView *)[self viewWithTag:ImageBaseTag + index];
        imagePhoto.hidden = NO;
        
        if (index >= count) {
            imagePhoto.frame = CGRectZero;
            imagePhoto.hidden = YES;
            continue;
        }
        switch (count) {
            case 1: {
                float width = ONE_PHOTO_WIDTH;
                float height = ONE_PHOTO_HEIGHT;
                float scale;
                NSString *urlStr = [arrayImage objectAtIndex:0];
                if ([NSString isBlankString:urlStr])
                {
                    return;
                }
                NSError* error = NULL;
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".+-(.{3,5})\\.(jpg|jpeg|gif|png)" options:NSRegularExpressionCaseInsensitive error:&error];
                NSTextCheckingResult *result = [regex firstMatchInString:urlStr options:0 range:NSMakeRange(0, [urlStr length])];
                if (result != nil)
                {
                    NSRange range = [result rangeAtIndex:1];
                    NSString *str = [urlStr substringWithRange:range];
                    char *cStr = (char *)cStr2Str11([str UTF8String]);
                    
                    NSString *sizeStr = [NSString stringWithUTF8String:cStr];
                    free(cStr);
                    
                    NSArray *sizeArr = [sizeStr componentsSeparatedByString:@"a"];
                    scale = [sizeArr[0] floatValue] / [sizeArr[1] floatValue];
                    if ([sizeArr[0] floatValue] < width && [sizeArr[1] floatValue] < height) {
                        width = [sizeArr[0] floatValue];
                        height = [sizeArr[1] floatValue];
                    } else if ([sizeArr[0] floatValue] < width) {
                        width = ONE_PHOTO_HEIGHT * [sizeArr[0] floatValue] / height;
                        height = ONE_PHOTO_HEIGHT;
                    } else if ([sizeArr[1] floatValue] < height) {
                        height = ONE_PHOTO_WIDTH * [sizeArr[1] floatValue] / width;
                        width = ONE_PHOTO_WIDTH;
                    } else {
                        if(scale <= 1)
                        {
                            width = height*scale;
                        }
                        else if(scale > 1)
                        {
                            height = width*(1/scale);
                        }
                    }
                }
                pointPhoto = CGPointMake(0, 0);
                CGRect rect = CGRectMake(pointPhoto.x, pointPhoto.y, width, height);
                [imagePhoto setFrame:rect];
                [imagePhoto setImageWithImageId:[arrayImage objectAtIndex:0] scaleSize:CGSizeMake(width, height) placeHolder:[UIImage ImageWithColor:[UIColor greenColor]]];
            }
                break;
            case 2:
            case 4: {
                float photoWidth = TWO_PHOTO_WIDTH;
                pointPhoto = CGPointMake(index%2*(photoWidth+SPACING), index/2*(photoWidth+SPACING));
                CGRect rect = CGRectMake(pointPhoto.x, pointPhoto.y, TWO_PHOTO_WIDTH, TWO_PHOTO_WIDTH);
                [imagePhoto setFrame:rect];
                [imagePhoto setImageWithImageId:[arrayImage objectAtIndex:index] scaleSize:CGSizeMake(photoWidth, photoWidth) placeHolder:[UIImage ImageWithColor:[UIColor greenColor]]];
            }
                break;
            default: {
                float photoWidth = THREE_PHOTO_WIDTH;
                pointPhoto = CGPointMake(index%3*(photoWidth+SPACING), index/3*(photoWidth+SPACING));
                CGRect rect = CGRectMake(pointPhoto.x, pointPhoto.y, THREE_PHOTO_WIDTH, THREE_PHOTO_WIDTH);
                [imagePhoto setFrame:rect];
                [imagePhoto setImageWithImageId:[arrayImage objectAtIndex:index] scaleSize:CGSizeMake(photoWidth, photoWidth) placeHolder:[UIImage ImageWithColor:[UIColor greenColor]]];
            }
                break;
        }
        
    }
}

- (void)tapImageViewWithTag:(NSInteger)index view:(UIView *)view
{
    [self imageWithTag:index imageArr:_imageArr fromView:view];
}

- (void)imageWithTag:(NSInteger)tag imageArr:(NSArray *)imageArr fromView:(UIView *)view
{
    UIViewController *currentVC = nil;
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarVC = (UITabBarController *)vc;
        UINavigationController *nav = (UINavigationController *)tabbarVC.viewControllers[tabbarVC.selectedIndex];
        currentVC = nav.visibleViewController;
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithImageIds:imageArr animatedFromView:view];
    [browser setInitialPageIndex:tag];
    [currentVC presentViewController:browser animated:YES completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoHasTapWithIndex:imageArr:)]) {
        [self.delegate photoHasTapWithIndex:tag imageArr:imageArr];
    }
}

- (CGFloat)photoWallHeight
{
    NSInteger count = _imageArr.count;
    CGFloat height = 0;
    
    if (count == 0) {
        height = 0;
    } else if (count == 1) {
        height = _width-100;
    } else if (count == 2) {
        height = (_width-SPACING)/2;
    } else if (count <= 4) {
        height = _width;
    } else if (count <= 6) {
        height = (_width-SPACING*2)/3*2+SPACING;
    } else {
        height = _width;
    }
    
    return height;

}

@end
