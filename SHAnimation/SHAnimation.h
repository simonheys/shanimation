//
//  SHAnimation.h
//
//  Created by Simon Heys on 07/12/2013.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGFloatMap.h"
#import "SHAnimationUnitBezier.h"
#import "SHAnimationSpring.h"
#import "SHAnimationDampedSpring.h"
#import "SHAnimationTransitionValueLayer.h"

#define kSHAnimationDefaultKeyframeCount 60
#define kSHAnimationMaximumKeyframeCount 60*60
#define kSHAnimationDefaultTimingFunctionName kCAMediaTimingFunctionLinear

// gravity
// 1 inch = 72 pixels (72dpi)
// 9.83m/s^2
// 387.008inch/s^2
// 27864.576px/s^2

#define kSHAnimationGravityAcceleration 27864.576/20

@interface SHAnimation : NSObject
+ (CAAnimation *)accelerationAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue velocity:(CGFloat)velocity acceleration:(CGFloat)acceleration keyframeCount:(NSInteger)keyframeCount;
+ (CAAnimation *)accelerationAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue velocity:(CGFloat)velocity acceleration:(CGFloat)acceleration;
+ (CAAnimation *)accelerationAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue velocity:(CGFloat)velocity acceleration:(CGFloat)acceleration duration:(CGFloat *)duration;
+ (CAAnimation *)gravityAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue velocity:(CGFloat)velocity keyframeCount:(NSInteger)keyframeCount;
+ (CAAnimation *)gravityAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue velocity:(CGFloat)velocity;
+ (CAAnimation *)gravityAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue velocity:(CGFloat)velocity duration:(CGFloat *)duration;

@end
