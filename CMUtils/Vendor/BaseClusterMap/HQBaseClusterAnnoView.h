//
//  HQBaseClusterAnnoView.h
//  iBoost
//
//  Created by Jerry on 15/5/12.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "HQBaseAnnoView.h"
@interface HQBaseClusterAnnoView : HQBaseAnnoView

/**
 *  通过annotation初始化一个HQBaseClusterAnnoView
 *
 *  @param annotation MKAnnotation
 *  @param identifier identifier
 *
 *  @return HQBaseClusterAnnoView实例
 */
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)identifier;

/**
 *  设置角标的文字
 *
 *  @param text 文字
 */
- (void)setBadgeText:(NSString *)text;
@end
