//
//  SHAnimation.m
//
//  Created by Simon Heys on 07/12/2013.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import "SHAnimation.h"

@implementation SHAnimation

// TODO
// make this so we set a final value and get back a duration

+ (CAAnimation *)accelerationAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue velocity:(CGFloat)velocity acceleration:(CGFloat)acceleration keyframeCount:(NSInteger)keyframeCount
{
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:keyframeCount];
    CGFloat value = fromValue;
    CGFloat dt = 1.0f/60.0f;
	for ( NSInteger frame = 0; frame < keyframeCount; frame++ ) {
        value += velocity * dt;
        velocity += acceleration * dt;
//        DDLogVerbose(@"value:%f velocity:%f",value,velocity);
		[values addObject:@(value)];
    }
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
	[animation setValues:values];
	return animation;
}

+ (CAAnimation *)accelerationAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue velocity:(CGFloat)velocity acceleration:(CGFloat)acceleration duration:(CGFloat *)duration
{
	NSMutableArray *values = [NSMutableArray new];
    CGFloat value = fromValue;
    CGFloat dt = 1.0f/60.0f;
    NSInteger keyFrameCount = 0;
    while ( keyFrameCount < kSHAnimationMaximumKeyframeCount && (( fromValue < toValue && value < toValue ) || ( fromValue > toValue && value > toValue ))) {
        value += velocity * dt;
        velocity += acceleration * dt;
//        DDLogVerbose(@"value:%f velocity:%f",value,velocity);
		[values addObject:@(value)];
        keyFrameCount++;
    }
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
	[animation setValues:values];
    *duration = keyFrameCount / 60.0f;
	return animation;
}

+ (CAAnimation *)accelerationAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue velocity:(CGFloat)velocity acceleration:(CGFloat)acceleration
{
    return [SHAnimation accelerationAnimationWithKeyPath:path fromValue:fromValue velocity:velocity acceleration:acceleration keyframeCount:kSHAnimationDefaultKeyframeCount];
}

+ (CAAnimation *)gravityAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue velocity:(CGFloat)velocity keyframeCount:(NSInteger)keyframeCount
{
    return [SHAnimation accelerationAnimationWithKeyPath:path fromValue:fromValue velocity:velocity acceleration:kSHAnimationGravityAcceleration keyframeCount:keyframeCount];
}

+ (CAAnimation *)gravityAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue velocity:(CGFloat)velocity
{
    return [SHAnimation accelerationAnimationWithKeyPath:path fromValue:fromValue velocity:velocity acceleration:kSHAnimationGravityAcceleration];
}

+ (CAAnimation *)gravityAnimationWithKeyPath:(NSString *)path fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue velocity:(CGFloat)velocity duration:(CGFloat *)duration
{
    return [SHAnimation accelerationAnimationWithKeyPath:path fromValue:fromValue toValue:toValue velocity:velocity acceleration:kSHAnimationGravityAcceleration duration:duration];
}
@end
