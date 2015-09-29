//
//  HQBaseClusterAnnoView.m
//  iBoost
//
//  Created by Jerry on 15/5/12.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "HQBaseClusterAnnoView.h"
#import "BadgeView.h"

@interface HQBaseClusterAnnoView()
@property (nonatomic,weak) BadgeView *badgeView;
@end

@implementation HQBaseClusterAnnoView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)identifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:identifier])
    {
        BadgeView *badgeView              = [[BadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentTopRight];
        badgeView.badgePositionAdjustment = CGPointMake(0, 0);
        badgeView.badgeOverlayColor       = [UIColor clearColor];
        badgeView.badgeTextColor          = [UIColor whiteColor];
        self.badgeView                    = badgeView;
    }
    return self;
}

- (void)setBadgeText:(NSString *)text
{
    self.badgeView.badgeText = text;
}
@end
