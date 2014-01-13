//
//  UnitBezier.m
//
//  Created by Simon Heys on 02/07/2013.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import "SHAnimationUnitBezier.h"
#import "CGFloatMap.h"
#import "SHAnimation.h"

@implementation SHAnimationUnitBezier

+ (SHAnimationUnitBezier *)unitBezierWithControlPoints:(double)p1x :(double)p1y :(double)p2x :(double)p2y
{
    return [[SHAnimationUnitBezier alloc] initWithControlPoints:p1x :p1y :p2x :p2y];
}

- (id)initWithControlPoints:(double)p1x :(double)p1y :(double)p2x :(double)p2y
{
    self = [super init];
    if (self) {
        self.p1x = p1x;
        self.p1y = p1y;
        self.p2x = p2x;
        self.p2y = p2y;
        
        // Calculate the polynomial coefficients, implicit first and last control points are (0,0) and (1,1).
        cx = 3.0 * self.p1x;
        bx = 3.0 * (self.p2x - self.p1x) - cx;
        ax = 1.0 - cx -bx;
         
        cy = 3.0 * self.p1y;
        by = 3.0 * (self.p2y - self.p1y) - cy;
        ay = 1.0 - cy - by;
    }
    return self;
}

- (double)sampleCurveX:(double)t
{
    // `ax t^3 + bx t^2 + cx t' expanded using Horner's rule.
    return ((ax * t + bx) * t + cx) * t;
}

- (double)sampleCurveY:(double)t
{
    return ((ay * t + by) * t + cy) * t;
}

- (double)sampleCurveDerivativeX:(double)t
{
    return (3.0 * ax * t + 2.0 * bx) * t + cx;
}

// Given an x value, find a parametric value it came from.
- (double)solveCurveX:(double)x epsilon:(double)epsilon
{
    double t0;
    double t1;
    double t2;
    double x2;
//    double d2;
//    int i;

    // First try a few iterations of Newton's method -- normally very fast.
//    for (t2 = x, i = 0; i < 8; i++) {
//        x2 = [self sampleCurveX:(t2) - x];
//        if (fabs (x2) < epsilon)
//            return t2;
//        d2 = [self sampleCurveDerivativeX:t2];
//        if (fabs(d2) < 1e-6)
//            break;
//        t2 = t2 - x2 / d2;
//    }

    // Fall back to the bisection method for reliability.
    t0 = 0.0;
    t1 = 1.0;
    t2 = x;

    // Allow overshoot for bounce
    // Just extends the end of the curve with linear
    // and then a bit of friction
    if (t2 < t0)
        return t2 * [self sampleCurveX:t0] * 0.1f;
    if (t2 > t1)
        return t1+(t2-t1) * [self sampleCurveX:t1] * 0.1f;

//    if (t2 < t0)
//        return t0;
//    if (t2 > t1)
//        return t1;

    while (t0 < t1) {
        x2 = [self sampleCurveX:t2];
        if (fabs(x2 - x) < epsilon)
            return t2;
        if (x > x2)
            t0 = t2;
        else
            t1 = t2;
        t2 = (t1 - t0) * .5 + t0;
    }

    // Failure.
    return t2;
}

- (double)solve:(double)x epsilon:(double)epsilon
{
    return [self sampleCurveY:[self solveCurveX:x epsilon:epsilon]];
}

- (id)animationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue keyframeCount:(NSInteger)keyframeCount
{
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:keyframeCount];
	for ( NSInteger frame = 0; frame < keyframeCount; frame++ ) {
        double t = (double)frame / (keyframeCount - 1);
        CGFloat y = [self solve:t epsilon:1e-3];
		CGFloat value = CGFloatMapTransition(y, 0, 1, fromValue, toValue);
		[values addObject:@(value)];
	}
	
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
	[animation setValues:values];
	return animation;
}

- (id)animationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue
{
    return [self animationWithKeyPath:path fromValue:fromValue toValue:toValue keyframeCount:kSHAnimationDefaultKeyframeCount];
}

@end
