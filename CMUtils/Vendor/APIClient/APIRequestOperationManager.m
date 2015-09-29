//
//  APIRequestOperationManager.m
//  CMUtils
//
//  Created by Jerry on 15/4/22.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//

#import "APIRequestOperationManager.h"

@implementation APIRequestOperationManager

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

@end
