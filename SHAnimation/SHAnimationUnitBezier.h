//
//  UnitBezier.h
//
//  Created by Simon Heys on 02/07/2013.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHAnimationUnitBezier : NSObject {
double ax;
double bx;
double cx;

double ay;
double by;
double cy;
}

@property (nonatomic) double p1x;
@property (nonatomic) double p1y;
@property (nonatomic) double p2x;
@property (nonatomic) double p2y;

+ (SHAnimationUnitBezier *)unitBezierWithControlPoints:(double)p1x :(double)p1y :(double)p2x :(double)p2y;
- (id)initWithControlPoints:(double)p1x :(double)p1y :(double)p2x :(double)p2y;
- (double)sampleCurveX:(double)t;
- (double)sampleCurveY:(double)t;
- (double)sampleCurveDerivativeX:(double)t;
- (double)solveCurveX:(double)x epsilon:(double)epsilon;
- (double)solve:(double)x epsilon:(double)epsilon;
- (id)animationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue keyframeCount:(NSInteger)keyframeCount;
- (id)animationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;
@end
