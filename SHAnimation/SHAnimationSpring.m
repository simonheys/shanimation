//
//  Spring.m
//
//  Created by Simon Heys on 10/07/2013.
//  Copyright (c) 2013 Simon Heys Limited. All rights reserved.
//


#import "SHAnimationSpring.h"
#import "SHAnimation.h"

@implementation SHAnimationSpring

+ (instancetype)unitSpring
{
    SHAnimationSpring *spring = [SHAnimationSpring new];
    spring.k = 5.172414;
    spring.c = 0.551724;
    spring.mass = 0.690586;
    spring.restingValue = 1.0f;
    spring.restLength = 0.0f;
    spring.value = 0.0f;
    return spring;
}

// good but very slight too bouncy

+ (instancetype)unitSpringWithBounce
{
    SHAnimationSpring *spring = [SHAnimationSpring new];
    spring.k = 8.971292;
    spring.c = 0.547847;
    spring.mass = 1.196172;
    spring.restingValue = 1.0f;
    spring.restLength = 0.0f;
    spring.value = 0.0f;

    spring.mass = 2.0;
    spring.k = 8.6f;
    spring.c = 0.8f;


    return spring;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.velocity = 0.0;
        self.restingValue = 0.0;
        self.value = 0.0;
        self.k = 2.71;
        self.c = 0.09;
        self.mass = 0.08;
    }
    return self;
}

- (double)stepTime:(double)dt
{
    double force = -self.k * ((self.value - self.restingValue) - self.restLength);          // f=-ky
    double acceleration = force / self.mass;                            // Set the acceleration, f=ma == a=f/m
    self.velocity = self.c * (self.velocity + acceleration);            // Set the velocity
    self.value += self.velocity * dt;                                    // Updated position
    return self.value;
}

- (BOOL)stopped
{
    if ( fabs(self.velocity) < 1.0f && fabs(self.value - self.restingValue) < 1.0f ) {
        return YES;
    }
    return NO;
}

- (id)animationWithKeyPath:(NSString *)path
{
	NSMutableArray *values = [NSMutableArray new];
    NSInteger keyFrameCount = 0;
    while ( !self.stopped && keyFrameCount < kSHAnimationMaximumKeyframeCount ) {
		CGFloat value = [self stepTime:1.0f/60.0f];
        NSLog(@"value:%f",value);
		[values addObject:@(value)];
        keyFrameCount++;
    }
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
	[animation setValues:values];
    animation.duration = keyFrameCount / 60.0f;
	return animation;
}

@end
