//
//  HQTextField.m
//  CMUtils
//
//  Created by Jerry on 15/4/21.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "HQTextField.h"
#import "NSString+util.h"

@interface HQTextField()

@end

@implementation HQTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)textFieldChanged:(HQTextField *)textField
{
    
    if( textField.markedTextRange != nil || _maxAsciiLen == 0 )
    {
        return;
    }
    self.text = [NSString substringWithAsciiLen:textField.text maxLength:_maxAsciiLen];    
}

@end
