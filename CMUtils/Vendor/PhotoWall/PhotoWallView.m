//
//  PhotoWallView.m
//  CMUtils
//
//  Created by Jerry on 15/6/17.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "PhotoWallView.h"
#import "Hex62To11.h"
#import "IDMPhotoBrowser.h"
#import "BlocksKit+UIKit.h"
#import "CMConfig.h"
#import "NSString+util.h"
#import "UIImageView+imageId.h"
#import "UIColor+hex.h"
#import "UIImage+Color.h"
#define PhotoNumMax 9
#define ImageBaseTag 1000
#define ONE_PHOTO_WIDTH 215*(SCREEN_WIDTH/320)
#define ONE_PHOTO_HEIGHT 150*(SCREEN_WIDTH/320)

@interface PhotoWallView()
@property (nonatomic, strong) NSArray *imageArr;
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
- (id)initWithCoder:(NSCoder *)aDecoder
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

- (void)photoWithArray:(NSArray *)arrayImage
{
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
                [imagePhoto setImageWithImageId:[arrayImage objectAtIndex:0] scaleSize:CGSizeMake(width, height) placeHolder:[UIImage ImageWithColor:[UIColor colorWithHex:0xcdcdcd]]];
            }
                break;
            case 2:
            case 4: {
                float photoWidth = (SCREEN_WIDTH - 95) / 2;
                pointPhoto = CGPointMake(index%2*photoWidth, index/2*photoWidth);
                CGRect rect = CGRectMake(pointPhoto.x, pointPhoto.y, photoWidth-2, photoWidth-2);
                [imagePhoto setFrame:rect];
                [imagePhoto setImageWithImageId:[arrayImage objectAtIndex:index] scaleSize:CGSizeMake(photoWidth - 2, photoWidth - 2) placeHolder:[UIImage ImageWithColor:[UIColor colorWithHex:0xcdcdcd]]];
            }
                break;
            default: {
                float photoWidth = (SCREEN_WIDTH - 95) / 3;
                pointPhoto = CGPointMake(index%3*photoWidth, index/3*photoWidth);
                CGRect rect = CGRectMake(pointPhoto.x, pointPhoto.y, photoWidth - 2, photoWidth - 2);
                [imagePhoto setFrame:rect];
                [imagePhoto setImageWithImageId:[arrayImage objectAtIndex:index] scaleSize:CGSizeMake(photoWidth, photoWidth) placeHolder:[UIImage ImageWithColor:[UIColor colorWithHex:0xcdcdcd]]];
            }
                break;
        }
        
    }
    
    
}
+ (CGSize)PhotoWallHeight:(NSArray *)arrayImage
{
    
    //    NSArray *images = @[@"img/7gKnXHe39CwFlaYaVnDSVo-RrBs.jpg", @"img/3BFdMftBvtOT37mB6tMTKN-RrBs.jpg", @"img/5HPFaA7S8onyajH2UJtw6Q-RrBs.jpg", @"img/24kc5JeYSO8mU6HH2g5Xal-RrBs.jpg",@"img/7gKnXHe39CwFlaYaVnDSVo-RrBs.jpg", @"img/3BFdMftBvtOT37mB6tMTKN-RrBs.jpg", @"img/5HPFaA7S8onyajH2UJtw6Q-RrBs.jpg", @"img/24kc5JeYSO8mU6HH2g5Xal-RrBs.jpg", @"img/5HPFaA7S8onyajH2UJtw6Q-RrBs.jpg"];
    //    arrayImage = [NSArray arrayWithArray:[images subarrayWithRange:NSMakeRange(0, 8)]];
    int count = arrayImage.count;
    switch (arrayImage.count)
    {
        case 0:
        {
            return CGSizeZero;
        }
        case 1:
        {
            float height = ONE_PHOTO_HEIGHT;
            float width = ONE_PHOTO_WIDTH;
            NSString *urlStr = [arrayImage objectAtIndex:0];
            if([urlStr isEqualToString:@"null"])
            {
                return CGSizeMake(0, 0);
            }
            
            float scale;
            {
                
                NSError* error = NULL;
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".+-(.{3,5})\\.(jpg|jpeg|gif|png)" options:NSRegularExpressionCaseInsensitive error:&error];
                NSTextCheckingResult *result = [regex firstMatchInString:urlStr options:0 range:NSMakeRange(0, [urlStr length])];
                if (result == nil) {
                    return CGSizeMake(150*(SCREEN_WIDTH/320), 150*(SCREEN_WIDTH/320));
                }
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
            return CGSizeMake(width, height);
        }
        case 2:case 4:
        {
            float photoWidth = (SCREEN_WIDTH - 95) / 2;
            return CGSizeMake(((count/2)?(photoWidth*2):(photoWidth*(count%2))), photoWidth*(count/2+(count%2?1:0)));
        }
        default:
        {
            float photoWidth = (SCREEN_WIDTH - 95) / 3;
            return CGSizeMake(((count/3)?(photoWidth*3):(photoWidth*(count%3))), photoWidth*(count/3+(count%3?1:0)));
        }
    }
    
    return CGSizeZero;
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

@end
