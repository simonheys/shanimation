//
//  SHAnimationDampedSpring.m
//  ChineasyUI
//
//  Created by Simon Heys on 15/12/2013.
//  Copyright (c) 2013 Chineasy Limited. All rights reserved.
//

#import "SHAnimationDampedSpring.h"
#import "SHAnimation.h"

CGFloat const kSHAnimationDampedSpringDefaultTolerance = 0.001f;

@interface SHAnimationDampedSpring ()
@property (nonatomic) CGFloat angularFrequency;
@property (nonatomic) CGFloat omegaZeta;
@property (nonatomic) CGFloat alpha;
@property (nonatomic) CGFloat expTerm;
@property (nonatomic) CGFloat cosTerm;
@property (nonatomic) CGFloat sinTerm;
@property (nonatomic) CGFloat deltaTime;
@property (nonatomic) CGFloat currentValue;
@property (nonatomic) BOOL needsRecalculation;
@end

@implementation SHAnimationDampedSpring

+ (instancetype)unitSpringWithDampingRatio:(CGFloat)dampingRatio
{
    SHAnimationDampedSpring *spring = [SHAnimationDampedSpring new];
    spring.dampingRatio = dampingRatio;
    spring.frequencyHz = dampingRatio * 0.5f;// 1.0f / spring.dampingRatio;
    spring.toValue = 0.0f;
    spring.fromValue = 1.0f;
    spring.velocity = 0.0f;
    spring.tolerance = kSHAnimationDampedSpringDefaultTolerance;
    return spring;
}

+ (instancetype)unitSpring
{
    return [SHAnimationDampedSpring unitSpringWithDampingRatio:1.0f];
}

- (void)setFromValue:(CGFloat)value
{
    _fromValue = value;
    self.currentValue = value;
    self.needsRecalculation = YES;
}

- (void)setToValue:(CGFloat)restingValue
{
    _toValue = restingValue;
    self.needsRecalculation = YES;
}

- (void)setVelocity:(CGFloat)velocity
{
    _velocity = velocity;
    self.needsRecalculation = YES;
}

- (void)setTolerance:(CGFloat)tolerance
{
    _tolerance = fabs(tolerance);
    if ( 0 == _tolerance ) {
        _tolerance = kSHAnimationDampedSpringDefaultTolerance;
    }
}

- (CAKeyframeAnimation *)animationWithKeyPath:(NSString *)path
{
    return [self animationWithKeyPath:path delay:0];
}

- (CAKeyframeAnimation *)animationWithKeyPath:(NSString *)path delay:(CFTimeInterval)delay
{
    return [self animationWithKeyPath:path delay:0 timingFunctionName:kSHAnimationDefaultTimingFunctionName];
}

- (CAKeyframeAnimation *)animationWithKeyPath:(NSString *)path timingFunctionName:(NSString *)timingFunctionName
{
    return [self animationWithKeyPath:path delay:0 timingFunctionName:timingFunctionName];
}

- (CAKeyframeAnimation *)animationWithKeyPath:(NSString *)path delay:(CFTimeInterval)delay timingFunctionName:(NSString *)timingFunctionName
{
//    CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();
    CGFloat deltaTime = 1.0/60.0f;
    if ( deltaTime != self.deltaTime ) {
        self.deltaTime = deltaTime;
    }
    if ( self.needsRecalculation ) {
        [self computeConstants];
        self.needsRecalculation = NO;
    }
    NSInteger keyFrameCountByEnvelope = 0;
    while ( keyFrameCountByEnvelope < kSHAnimationMaximumKeyframeCount ) {
        CGFloat e = [self envelopeForTime:keyFrameCountByEnvelope * 1.0f / 60.0f];
//        NSLog(@"e:%f",fabs(self.toValue-e));
        if ( fabs(self.toValue-e) < self.tolerance ) {
            NSLog(@"keyFrames by envelope:%d",keyFrameCountByEnvelope);
            break;
        }
        keyFrameCountByEnvelope++;
    }
    
    NSInteger keyFrameCount = 0;
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:keyFrameCountByEnvelope];
    while ( keyFrameCount < delay * 60.0f && keyFrameCount < keyFrameCountByEnvelope ) {
		[values addObject:@(self.currentValue)];
        keyFrameCount++;
    }
    while ( keyFrameCount < keyFrameCountByEnvelope ) {
        stepSpring(deltaTime, &_currentValue, _toValue, &_velocity, _angularFrequency, _dampingRatio, _expTerm, _omegaZeta, _alpha, _cosTerm, _sinTerm);
		[values addObject:@(_currentValue)];
        keyFrameCount++;
    }
    NSLog(@"keyFrames:%d",keyFrameCount);
    
    if ( keyFrameCount >= kSHAnimationMaximumKeyframeCount ) {
        NSLog(@"excessibvley long!");
    }
	
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
    animation.values = values;
    animation.duration = keyFrameCount / 60.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
//    CFTimeInterval endTime = CFAbsoluteTimeGetCurrent();
//    NSLog(@"took %f secs",(endTime-startTime));
	return animation;
}

- (void)setDampingRatio:(CGFloat)dampingRatio
{
    dampingRatio = MAX(0.0f, dampingRatio);
    dampingRatio = MIN(1.0f, dampingRatio);
    _dampingRatio = dampingRatio;
    self.needsRecalculation = YES;
}

- (void)setFrequencyHz:(CGFloat)frequencyHz
{
    _frequencyHz = frequencyHz;
    self.angularFrequency = 2.0f * M_PI * _frequencyHz;
}

- (void)setAngularFrequency:(CGFloat)angularFrequency
{
    _angularFrequency = angularFrequency;
    self.needsRecalculation = YES;
}

- (void)setDeltaTime:(CGFloat)deltaTime
{
    _deltaTime = deltaTime;
    self.needsRecalculation = YES;
}

// calculate constants based on motion parameters
- (void)computeConstants
{
    // if critically damped
    if ( 1.0f == self.dampingRatio ) {
        self.expTerm = expf( -self.angularFrequency * self.deltaTime );
    }
    else {
        self.omegaZeta = self.angularFrequency * self.dampingRatio;
        self.alpha = self.angularFrequency * sqrtf(1.0f - self.dampingRatio * self.dampingRatio);
        self.expTerm = expf( -self.omegaZeta * self.deltaTime );
        self.cosTerm = cosf( self.alpha * self.deltaTime );
        self.sinTerm = sinf( self.alpha * self.deltaTime );
    }
    self.needsRecalculation = NO;
}

// stepTime is based on http://www.ryanjuckett.com/programming/17-physics/34-damped-springs?start=9

/******************************************************************************
  Copyright (c) 2008-2012 Ryan Juckett
  http://www.ryanjuckett.com/
 
  This software is provided 'as-is', without any express or implied
  warranty. In no event will the authors be held liable for any damages
  arising from the use of this software.
 
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
 
  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
 
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
 
  3. This notice may not be removed or altered from any source
     distribution.
******************************************************************************/

static __inline__ void stepSpring(CGFloat deltaTime, CGFloat *currentValue, CGFloat toValue, CGFloat *velocity, CGFloat angularFrequency, CGFloat dampingRatio, CGFloat expTerm, CGFloat omegaZeta, CGFloat alpha, CGFloat cosTerm, CGFloat sinTerm) {
    // if there is no angular frequency, the spring will not move
    if ( 0.0f == angularFrequency ) {
        return;
    }
 
    // calculate initial state in equilibrium relative space
    CGFloat initialPos = *currentValue - toValue;
    CGFloat initialVel = *velocity;
 
    // if critically damped
    if ( 1.0f == dampingRatio ) {
        // update motion
        CGFloat c1 = initialVel + angularFrequency * initialPos;
        CGFloat c2 = initialPos;
        CGFloat c3 = ( c1 * deltaTime + c2 ) * expTerm;
        *currentValue = toValue + c3;
        *velocity = ( c1 * expTerm ) - ( c3 * angularFrequency );
    }
    else {
        // else under-damped
        // update motion
        CGFloat c1 = initialPos;
        CGFloat c2 = (initialVel + omegaZeta * initialPos) / alpha;
        *currentValue = toValue + expTerm * ( c1 * cosTerm + c2 * sinTerm );
        *velocity = -expTerm * ( ( c1 * omegaZeta - c2 * alpha ) * cosTerm + ( c1 * alpha + c2 * omegaZeta ) * sinTerm );
    }
}

- (CGFloat)envelopeForTime:(CGFloat)t
{
    if ( self.needsRecalculation ) {
        [self computeConstants];
    }
    CGFloat envelope = expf(-self.omegaZeta * t);
    // TODO: log here is reversing the expf calculation in computeConstants
    // so that we can convert to absolute time rather than delta
    envelope = expf(log(self.expTerm) * t / self.deltaTime);
    if ( 0 == self.velocity ) {
        return self.toValue + (self.fromValue - self.toValue) * envelope;
    }
    else {
        return self.toValue + ((self.fromValue - self.toValue) + self.velocity/self.alpha) * envelope;
    }
}

- (CGFloat)stepTime:(CGFloat)t
{
    // if there is no angular frequency, the spring will not move
    if ( 0.0f == self.angularFrequency ) {
        return self.currentValue;
    }
    if ( t != self.deltaTime ) {
        self.deltaTime = t;
    }
    if ( self.needsRecalculation ) {
        [self computeConstants];
    }
 
    // calculate initial state in equilibrium relative space
    CGFloat initialPos = self.currentValue - self.toValue;
    CGFloat initialVel = self.velocity;
 
    // if critically damped
    if ( 1.0f == self.dampingRatio ) {
        // update motion
        CGFloat c1 = initialVel + self.angularFrequency * initialPos;
        CGFloat c2 = initialPos;
        CGFloat c3 = ( c1 * t + c2 ) * self.expTerm;
        self.currentValue = self.toValue + c3;
        self.velocity = ( c1 * self.expTerm ) - ( c3 * self.angularFrequency );
    }
    else {
        // else under-damped
        // update motion
        CGFloat c1 = initialPos;
        CGFloat c2 = (initialVel + self.omegaZeta*initialPos) / self.alpha;
        self.currentValue = self.toValue + self.expTerm * ( c1 * self.cosTerm + c2 * self.sinTerm );
        self.velocity = -self.expTerm * ( ( c1 * self.omegaZeta - c2 * self.alpha ) * self.cosTerm + ( c1 * self.alpha + c2 * self.omegaZeta ) * self.sinTerm );
    }
    
    return self.currentValue;
}

@end
