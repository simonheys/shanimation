//
//  SHAnimationSpringView.m
//
//  Created by Simon Heys on 11/07/2013.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import "SHAnimationSpringView.h"
#import "SHAnimationSpring.h"

@implementation SHAnimationSpringView

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.spring.value = 1.0f;
    self.spring.restLength = 0.0f;
    
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
    for ( double x = 0; x <= 1; x+=1.0/120.0 ) {
        
        // find the t based on x position (we will need to do this to maintain scroll position)
        double y = [self.spring stepTime:1.0/60.0];
//        double y = [self.spring stepTimeCritical:1.0/60.0];
        v = 0.5 + y * 0.25 * self.verticalScale;
//        DLog(@"y:%f",y);
        if ( first) {
            CGContextMoveToPoint(context, x*rect.size.width, v*rect.size.height);
        }
        else {
            CGContextAddLineToPoint(context, x*rect.size.width, v*rect.size.height);
        }
        first = NO;
//        DLog(@"%f: %f %f",t, t*rect.size.width, v*rect.size.height);
//DLog(@"%f: %f %f %f %f %f",t,[bezier sampleCurveX:t],[bezier sampleCurveY:t],[bezier sampleCurveDerivativeX:t],[bezier solveCurveX:t epsilon:0.0001],[bezier solve:t epsilon:0.0001]);
//        DLog(@"%f: %f",t,[bezier solveCurveX:t epsilon:0.0001]);
    }
//    CGContextClosePath(context);
    CGContextStrokePath(context);

}

- (void)setVerticalScale:(double)verticalScale
{
    _verticalScale = verticalScale;
    [self setNeedsDisplay];
}


@end
