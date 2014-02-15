//
//  SHSpringAnimation.h
//  SHAnimationTest
//
//  Created by Simon Heys on 14/02/2014.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SHSpringAnimation : CAKeyframeAnimation
@property (nonatomic) CGFloat frequencyHz;
@property (nonatomic) CGFloat dampingRatio;
@property (nonatomic) CGFloat unitVelocity;
@property (nonatomic, copy) NSValue *fromValue;
@property (nonatomic, copy) NSValue *toValue;
@end
