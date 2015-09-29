//
//  PullCollectionView.m
//  CMUtils
//
//  Created by Jerry on 15/3/25.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "PullCollectionView.h"
#import "CMUtils.h"

@implementation PullCollectionView
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = UNIFY_BG_COlOR;
    }
    return self;
}
- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler
{
    [super addInfiniteScrollingWithActionHandler:actionHandler];
}
@end
