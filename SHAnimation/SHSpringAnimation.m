//
//  SHSpringAnimation.m
//  SHAnimationTest
//
//  Created by Simon Heys on 14/02/2014.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import "SHAnimation.h"
#import "SHSpringAnimation.h"
#import "SHValueInterpolation.h"

CGFloat const kSHSpringAnimationFromValue = 0.0f;
CGFloat const kSHSpringAnimationToValue = 1.0f;
CGFloat const kSHSpringAnimationDeltaTime = 1.0f / 60.0f;
CGFloat const kSHSpringAnimationTolerance = 0.0001f;

@interface SHSpringAnimation ()
@property (nonatomic, readonly) NSTimeInterval timeToReachTolerance;
@end

@implementation SHSpringAnimation

- (NSTimeInterval)duration
{
    if ( 0 == [super duration] ) {
        return self.timeToReachTolerance;
    }
    return [super duration];
}

- (NSTimeInterval)timeToReachTolerance
{
    CGFloat angularFrequency = 2.0f * M_PI * _frequencyHz;
    CGFloat timeToReachTolerance, e;
    CGFloat envelope = CGFLOAT_MAX;
    CGFloat alpha = angularFrequency * sqrtf(1.0f - self.dampingRatio * self.dampingRatio);
    timeToReachTolerance = 0;
    while ( (timeToReachTolerance < (kSHAnimationMaximumKeyframeCount * kSHSpringAnimationDeltaTime)) && fabs(envelope-kSHSpringAnimationToValue) > kSHSpringAnimationTolerance ) {
        e = expf( -angularFrequency * self.dampingRatio * timeToReachTolerance );
//        NSLog(@"e:%f",e);
        if ( 0 == self.unitVelocity ) {
            envelope = kSHSpringAnimationToValue + (kSHSpringAnimationFromValue - kSHSpringAnimationToValue) * e;
        }
        else {
            envelope = kSHSpringAnimationToValue + ((kSHSpringAnimationFromValue - kSHSpringAnimationToValue) + self.unitVelocity / alpha) * e;
        }
        timeToReachTolerance += kSHSpringAnimationDeltaTime;
//        NSLog(@"envelope:%f",envelope);
    }
    return timeToReachTolerance;
}

- (NSArray *)values
{
    CGFloat omegaZeta;
    CGFloat alpha;
    CGFloat expTerm;
    CGFloat cosTerm;
    CGFloat sinTerm;
    CGFloat angularFrequency = 2.0f * M_PI * _frequencyHz;
    NSTimeInterval timeToReachTolerance = self.timeToReachTolerance;
//    CGFloat tolerance = fabs(kSHSpringAnimationFromValue-kSHSpringAnimationToValue) * 0.0001;
//    
//    if ( 0 != self.unitVelocity ) {
//        tolerance = MIN(tolerance, fabs(self.unitVelocity) * 0.0001);
//    }
//    tolerance = MAX(tolerance, 0.0001);
    // if critically damped
    if ( 1.0f == self.dampingRatio ) {
        expTerm = expf( -angularFrequency * kSHSpringAnimationDeltaTime );
    }
    else {
        omegaZeta = angularFrequency * self.dampingRatio;
        alpha = angularFrequency * sqrtf(1.0f - self.dampingRatio * self.dampingRatio);
        expTerm = expf( -omegaZeta * kSHSpringAnimationDeltaTime );
        cosTerm = cosf( alpha * kSHSpringAnimationDeltaTime );
        sinTerm = sinf( alpha * kSHSpringAnimationDeltaTime );
    }
    
//    CGFloat timeToReachTolerance, e, envelope;
//    timeToReachTolerance = 0;
//    envelope = CGFLOAT_MAX;
//    while ( (timeToReachTolerance < (kSHAnimationMaximumKeyframeCount * kSHSpringAnimationDeltaTime)) && fabs(envelope-kSHSpringAnimationToValue) > tolerance ) {
//        e = expf( -angularFrequency * self.dampingRatio * timeToReachTolerance );
//        if ( 0 == self.unitVelocity ) {
//            envelope = kSHSpringAnimationToValue + (kSHSpringAnimationFromValue - kSHSpringAnimationToValue) * e;
//        }
//        else {
//            envelope = kSHSpringAnimationToValue + ((kSHSpringAnimationFromValue - kSHSpringAnimationToValue) + self.unitVelocity / alpha) * e;
//        }
//        timeToReachTolerance += kSHSpringAnimationDeltaTime;
//    }
    NSInteger numberOfKeyframes = timeToReachTolerance / kSHSpringAnimationDeltaTime;
    NSMutableArray *keyframes = [NSMutableArray arrayWithCapacity:numberOfKeyframes];
//    self.duration = timeToReachTolerance;
    
    CGFloat t = 0;
    CGFloat velocity = self.unitVelocity;
    CGFloat currentValue = kSHSpringAnimationFromValue;
    
    SHValueInterpolation valueInterpolate = SHValueInterpolate(self.fromValue, self.toValue);
    
    for ( t = 0; t < timeToReachTolerance; t+= kSHSpringAnimationDeltaTime ) {
        // calculate initial state in equilibrium relative space
        CGFloat initialPos = currentValue - kSHSpringAnimationToValue;
        CGFloat initialVel = velocity;
     
        // if critically damped
        if ( 1.0f == self.dampingRatio ) {
            // update motion
            CGFloat c1 = initialVel + angularFrequency * initialPos;
            CGFloat c2 = initialPos;
            CGFloat c3 = ( c1 * kSHSpringAnimationDeltaTime + c2 ) * expTerm;
            currentValue = kSHSpringAnimationToValue + c3;
            velocity = ( c1 * expTerm ) - ( c3 * angularFrequency );
        }
        else {
            // else under-damped
            // update motion
            CGFloat c1 = initialPos;
            CGFloat c2 = (initialVel + omegaZeta * initialPos) / alpha;
            currentValue = kSHSpringAnimationToValue + expTerm * ( c1 * cosTerm + c2 * sinTerm );
            velocity = -expTerm * ( ( c1 * omegaZeta - c2 * alpha ) * cosTerm + ( c1 * alpha + c2 * omegaZeta ) * sinTerm );
        }
        
        NSValue *value = valueInterpolate(currentValue);
        [keyframes addObject:value];
//        NSLog(@"fraction:%f value:%@",currentValue,value);
    }
    return keyframes;
}

#pragma mark - NSObject

- (id)copyWithZone:(NSZone *)zone
{
    SHSpringAnimation *copy = [super copyWithZone:zone];
    if (copy == nil) return nil;
    copy->_frequencyHz = _frequencyHz;
    copy->_dampingRatio = _dampingRatio;
    copy->_unitVelocity = _unitVelocity;
    copy->_fromValue = _fromValue;
    copy->_toValue = _toValue;
    return copy;
}

@end
