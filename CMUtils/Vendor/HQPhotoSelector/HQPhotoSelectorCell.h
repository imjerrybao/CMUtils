//
//  HQPhotoSelectorCell.h
//  seafishing2
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+animated.h"
#import <AssetsLibrary/ALAsset.h>
#define ImageTag 100
#define LineImageNumber ((SCREEN_WIDTH >= 414) ? 4 : 3)
@protocol HQPhotoSelectorCellDelegate <NSObject>
- (void)clickImage:(id)sender;
- (void)clickCheck:(id)sender;

@end

@interface HQPhotoSelectorCell : UITableViewCell
@property (nonatomic,assign) id<HQPhotoSelectorCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

- (void)loadPhoto:(NSMutableArray *)dataSource indexPath:(NSIndexPath *)indexPath;
@end

#pragma mark - image
@interface HQMarkView : UIImageView
@property (nonatomic,strong) NSString *URLString;
@property (nonatomic,strong) NSIndexPath *indexPath;
- (void)setAsset:(ALAsset *)asset;
- (void)switchCheckState:(BOOL)isCheck;
@end