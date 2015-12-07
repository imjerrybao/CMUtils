//
//  HQPhotoSelector.h
//  seafishing2
//
//  Created by mac on 14-8-11.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQPhotoSelectorCell.h"
#import "HQPhotoPageVC.h"
#import <AssetsLibrary/ALAssetsGroup.h>
@protocol HQPhotoSelectorDelegate <NSObject>
@required
-(void)photoAlbumDidFinish:(NSMutableArray *)photoArray;
@end

@interface HQPhotoSelector:UIViewController<UITableViewDataSource,UITableViewDelegate,HQPhotoSelectorCellDelegate>

@property (nonatomic,weak) id<HQPhotoSelectorDelegate> delegate;

- (id)initWithPhotos:(NSMutableArray *)photoArray toplimit:(int)toplimit;
- (id)initWithALAssetsGroup:(ALAssetsGroup *)assetsGroup;
@end
