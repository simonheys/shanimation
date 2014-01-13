//
//  UnitBezierView.m
//
//  Created by Simon Heys on 02/07/2013.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import "SHAnimationUnitBezierView.h"
#import "SHAnimationUnitBezier.h"

@implementation SHAnimationUnitBezierView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
//    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:0.00 :1.00 :0.12 :1.00];    
    
    
//    http://netcetera.org/camtf-playground.html
    SHAnimationUnitBezier *bezier = [SHAnimationUnitBezier unitBezierWithControlPoints:0.00 :1.00 :0.12 :1.00];
//    UnitBezier *bezier = [UnitBezier unitBezierWithControlPoints:0.00 :0.00 :1.00 :1.00];

    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddCurveToPoint(context, rect.size.width*bezier.p1x, rect.size.height*bezier.p1y, rect.size.width*bezier.p2x, rect.size.height*bezier.p2y, rect.size.width, rect.size.height);
    CGContextStrokePath(context);

    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextBeginPath(context);
    BOOL first = YES;
    for ( double x = 0; x <= 1; x+=1.0/rect.size.width ) {
        
        // find the t based on x position (we will need to do this to maintain scroll position)
        double t = [bezier solveCurveX:x epsilon:1e-3];
//        double t = [bezier solve:i epsilon:0.000001];
        
//        double x = [bezier sampleCurveX:t];
        double y = [bezier sampleCurveY:t];
        
//        x = i;
//        double v = [bezier sampleCurveDerivativeX:t];
//        double v = [bezier solveCurveX:t epsilon:0.0001];
//        double v = [bezier solve:t epsilon:0.0001];
        if ( first) {
            CGContextMoveToPoint(context, x*rect.size.width, y*rect.size.height);
        }
        else {
            CGContextAddLineToPoint(context, x*rect.size.width, y*rect.size.height);
        }
        first = NO;
//        DLog(@"%f: %f %f",t, t*rect.size.width, v*rect.size.height);
//DLog(@"%f: %f %f %f %f %f",t,[bezier sampleCurveX:t],[bezier sampleCurveY:t],[bezier sampleCurveDerivativeX:t],[bezier solveCurveX:t epsilon:0.0001],[bezier solve:t epsilon:0.0001]);
//        DLog(@"%f: %f",t,[bezier solveCurveX:t epsilon:0.0001]);
    }
//    CGContextClosePath(context);
    CGContextStrokePath(context);

}


@end
