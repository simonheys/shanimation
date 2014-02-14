//
//  SHSpringAnimation.m
//  SHAnimationTest
//
//  Created by Simon Heys on 14/02/2014.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import "SHAnimation.h"
#import "SHSpringAnimation.h"

CGFloat const kSHSpringAnimationFromValue = 0.0f;
CGFloat const kSHSpringAnimationToValue = 1.0f;
CGFloat const kSHSpringAnimationDeltaTime = 1.0f / 60.0f;

@interface SHSpringAnimation ()
//@property (nonatomic) CGFloat angularFrequency;
//@property (nonatomic) CGFloat omegaZeta;
//@property (nonatomic) CGFloat alpha;
//@property (nonatomic) CGFloat expTerm;
//@property (nonatomic) CGFloat cosTerm;
//@property (nonatomic) CGFloat sinTerm;
//@property (nonatomic) CGFloat deltaTime;
//@property (nonatomic) CGFloat tolerance;
//@property (nonatomic) CGFloat currentValue;
@end

@implementation SHSpringAnimation

- (void)computeConstants
{
    CGFloat omegaZeta;
    CGFloat alpha;
    CGFloat expTerm;
    CGFloat cosTerm;
    CGFloat sinTerm;
    CGFloat angularFrequency = 2.0f * M_PI * _frequencyHz;
    CGFloat tolerance = fabs(kSHSpringAnimationFromValue-kSHSpringAnimationToValue) * 0.00125f;
    
    if ( 0 != self.unitVelocity ) {
        tolerance = MIN(tolerance, fabs(self.unitVelocity) * 0.00125f);
    }
    tolerance = MAX(tolerance, 0.00125f);
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
    
    CGFloat timeToReachTolerance, e, envelope;
    timeToReachTolerance = 0;
    envelope = CGFLOAT_MAX;
    while ( (timeToReachTolerance < (kSHAnimationMaximumKeyframeCount * kSHSpringAnimationDeltaTime)) && fabs(envelope) > tolerance ) {
        e = expf( -angularFrequency * self.dampingRatio * timeToReachTolerance );
        if ( 0 == self.unitVelocity ) {
            envelope = kSHSpringAnimationToValue + (kSHSpringAnimationFromValue - kSHSpringAnimationToValue) * e;
        }
        else {
            envelope = kSHSpringAnimationToValue + ((kSHSpringAnimationFromValue - kSHSpringAnimationToValue) + self.unitVelocity / alpha) * e;
        }
        timeToReachTolerance += kSHSpringAnimationDeltaTime;
    }
    
    CGFloat t = 0;
    CGFloat velocity = self.unitVelocity;
    CGFloat currentValue = kSHSpringAnimationFromValue;
    
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
    }
}



- (NSArray *)values
{
    
}

@end
