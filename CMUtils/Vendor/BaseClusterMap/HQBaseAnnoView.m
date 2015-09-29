//
//  HQBaseAnnoView.m
//  iBoost
//
//  Created by Jerry on 15/5/12.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "HQBaseAnnoView.h"
#import "CMUtils.h"
#import <Masonry/Masonry.h>

@interface HQBaseAnnoView()
@end

@implementation HQBaseAnnoView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)identifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:identifier])
    {
        UIImageView *imageView           = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        self.imageView                   = imageView;
        [self addSubview:imageView];
        
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 45)];
        [leftBtn setBackgroundImage:[UIImage ImageWithColor:[UIColor colorWithHex:0x48cfae]] forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[UIImage ImageWithColor:[UIColor colorWithHex:0x2a8770]] forState:UIControlStateHighlighted];
        UILabel *leftLbl = [[UILabel alloc] init];
        leftLbl.text = Locale(@"导航");
        leftLbl.textColor = [UIColor whiteColor];
        leftLbl.font = [UIFont boldSystemFontOfSize:15];
        [leftBtn addSubview:leftLbl];
        [leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftBtn);
        }];
        self.leftCalloutAccessoryView = leftBtn;
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 45)];
        [rightBtn setBackgroundImage:[UIImage ImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_icon"]];
        [rightBtn addSubview:rightImageView];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(rightBtn);
            make.width.equalTo(@7);
            make.height.equalTo(@13);
        }];
        self.rightCalloutAccessoryView = rightBtn;
    }
    return self;
}


@end
