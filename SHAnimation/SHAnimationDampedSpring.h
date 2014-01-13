//
//  SHAnimationDampedSpring.h
//
//  Created by Simon Heys on 15/12/2013.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

extern CGFloat const kSHAnimationDampedSpringDefaultTolerance;

@interface SHAnimationDampedSpring : NSObject

@property (nonatomic) CGFloat frequencyHz;
@property (nonatomic, readonly) CGFloat angularFrequency;
@property (nonatomic) CGFloat dampingRatio;
@property (nonatomic) CGFloat toValue;
@property (nonatomic) CGFloat velocity;
@property (nonatomic) CGFloat fromValue;
@property (nonatomic) CGFloat tolerance;

- (instancetype)init __attribute__((unavailable("init not available")));
+ (instancetype)unitSpring;
+ (instancetype)unitSpringWithDampingRatio:(CGFloat)dampingRatio;
- (CGFloat)stepTime:(CGFloat)dt;
- (CGFloat)envelopeForTime:(CGFloat)t;
- (CAKeyframeAnimation *)animationWithKeyPath:(NSString *)path;
- (CAKeyframeAnimation *)animationWithKeyPath:(NSString *)path delay:(CFTimeInterval)delay;
- (CAKeyframeAnimation *)animationWithKeyPath:(NSString *)path timingFunctionName:(NSString *)timingFunctionName;
- (CAKeyframeAnimation *)animationWithKeyPath:(NSString *)path delay:(CFTimeInterval)delay timingFunctionName:(NSString *)timingFunctionName;
@end
