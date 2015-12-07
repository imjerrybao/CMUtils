//
//  HQPhotoPageVC.h
//  seafishing2
//
//  Created by mac on 14/11/28.
//  Copyright (c) 2014年 Szfusion. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HQPhotoPageVC : UIPageViewController
- (id)initWithDataSource:(NSMutableArray *)dataSource index:(int)index isPreview:(BOOL)isPreview;
@end
