//
//  PullCollectionView.h
//  CMUtils
//
//  Created by Jerry on 15/3/25.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@interface PullCollectionView : UICollectionView
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
@end
