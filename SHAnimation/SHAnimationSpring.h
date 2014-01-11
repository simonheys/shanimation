//
//  Spring.h
//
//  Created by Simon Heys on 10/07/2013.
//  Copyright (c) 2013 Simon Heys Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

/*

http://khanlou.com/2012/01/cakeyframeanimation-make-it-bounce/

k = spring
c = damping
m = mass
A = initial velocity
t = time

*/

@interface SHAnimationSpring : NSObject

@property (nonatomic) double k;
@property (nonatomic) double c;
@property (nonatomic) double mass;
@property (nonatomic) double velocity;
@property (nonatomic) double restingValue;
@property (nonatomic) double value;
@property (nonatomic) double restLength;

@property (nonatomic, readonly) BOOL stopped;

+ (instancetype)unitSpring;
+ (instancetype)unitSpringWithBounce;

- (double)stepTime:(double)dt;
- (id)animationWithKeyPath:(NSString *)path;
@end
