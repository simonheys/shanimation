//
//  SHAnimationDampedSpringView.m
//  ChineasyUI
//
//  Created by Simon Heys on 15/12/2013.
//  Copyright (c) 2013 Chineasy Limited. All rights reserved.
//

#import "SHAnimationDampedSpringView.h"
#import "SHAnimationDampedSpring.h"

@implementation SHAnimationDampedSpringView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.verticalScale = 1.0f;
        self.spring = [SHAnimationDampedSpring unitSpring];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.verticalScale = 1.0f;
        self.spring = [SHAnimationDampedSpring unitSpring];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    self.spring.value = 1.0f;
//    self.spring.equilibriumValue = 0.0f;
//    self.spring.dampingRatio = 1.0f;

//    self.spring.angularFrequencyHz = 1.0f;
//    self.spring.dampingRatio = 0.5f;
    
    self.spring = [SHAnimationDampedSpring unitSpringWithDampingRatio:0.2f];
    self.spring.fromValue = 1.0f;
    self.spring.toValue = 0.0f;
    self.spring.frequencyHz = 1.0f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat v;
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);

    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.5f + roundf(0.5f * rect.size.width), 0);
    CGContextAddLineToPoint(context, 0.5f +  roundf(0.5f * rect.size.width), rect.size.height);
    CGContextMoveToPoint(context, 0, 0.5f + roundf(0.5f * rect.size.height));
    CGContextAddLineToPoint(context, rect.size.width, 0.5f + roundf(0.5f * rect.size.height));
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextBeginPath(context);
    BOOL first = YES;
    
//    CGFloat envelope;
    

    for ( double x = 0; x <= 1; x+=1.0/rect.size.width ) {
        double y = [self.spring stepTime:1.0/60.0];
        v = 0.5 + y * 0.25 * self.verticalScale;
        if ( first) {
            CGContextMoveToPoint(context, x*rect.size.width, v*rect.size.height);
        }
        else {
            CGContextAddLineToPoint(context, x*rect.size.width, v*rect.size.height);
        }
        first = NO;
    }
    CGContextStrokePath(context);

    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextBeginPath(context);
    first = YES;
    double t = 0;
    for ( double x = 0; x <= 1; x+=1.0/rect.size.width ) {
        double y = [self.spring envelopeForTime:t];
        t += 1/60.0f;
        v = 0.5 + y * 0.25 * self.verticalScale;
        if ( first) {
            CGContextMoveToPoint(context, x*rect.size.width, v*rect.size.height);
        }
        else {
            CGContextAddLineToPoint(context, x*rect.size.width, v*rect.size.height);
        }
        first = NO;
    }
    CGContextStrokePath(context);
}


@end
