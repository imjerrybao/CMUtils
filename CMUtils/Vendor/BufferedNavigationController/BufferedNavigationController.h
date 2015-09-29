//
//  BufferedNavigationController.h
//  yyl
//
//  Created by Jerry on 12-11-8.
//  Copyright (c) 2012年 Jerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BufferedNavigationController : UINavigationController<UINavigationControllerDelegate>

- (void) pushCodeBlock:(void (^)())codeBlock;
- (void) runNextBlock;

@property (nonatomic, strong) NSMutableArray* stack;
@property (nonatomic, assign) bool transitioning;

@end
