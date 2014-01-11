//
//  SHAnimationSpringView.h
//
//  Created by Simon Heys on 11/07/2013.
//  Copyright (c) 2013 Simon Heys Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHAnimationSpring;

@interface SHAnimationSpringView : UIView
@property (nonatomic, strong) SHAnimationSpring *spring;
@property (nonatomic) double verticalScale;
@end
