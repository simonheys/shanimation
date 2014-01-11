//
//  SHAnimationDampedSpringView.h
//  ChineasyUI
//
//  Created by Simon Heys on 15/12/2013.
//  Copyright (c) 2013 Chineasy Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHAnimationDampedSpring;

@interface SHAnimationDampedSpringView : UIView
@property (nonatomic, strong) SHAnimationDampedSpring *spring;
@property (nonatomic) double verticalScale;
@end
