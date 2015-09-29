//
//  PlaceName.h
//  iBoost
//
//  Created by Jerry on 14-6-24.
//  Copyright (c) 2014年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface PlaceName : NSObject

@property (nonatomic, strong)  NSCache *locationCache;
@property (nonatomic, strong) CLGeocoder *geocoder;

+ (PlaceName *)sharedInstance;
- (void) getPlaceNameWithLocation: (CLLocation *)loacation andBlogID: (NSString *)topicID andlabLocation: (UILabel *)labLocation;
- (void) getPlaceNameWithLocation: (CLLocation *)loacation andBlogID: (NSString *)topicID completion:(void(^)(NSString *result))completion;

//isBranch 国家分行显示
- (void)getPlaceNameWithLocation:(CLLocation *)loacation andBlogID:(NSString *)topicID isBranch:(BOOL)isBranch completion:(void(^)(NSString *result))completion;
- (NSString *)getCachedLocationBy:(CLLocation *)location isBranch:(BOOL)isBranch;
@end
