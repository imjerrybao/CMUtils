//
//  HQTextField.h
//  CMUtils
//
//  Created by Jerry on 15/4/21.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *使用 HQTextField 替换 UITextField
 *方面功能移植,替换
 */

@interface HQTextField : UITextField
@property (nonatomic) NSInteger maxAsciiLen;//可输入最大Ascii长度
@end

