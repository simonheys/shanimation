//
//  DragTestView.m
//  ChineasyUI
//
//  Created by Simon Heys on 05/01/2014.
//  Copyright (c) 2014 Chineasy Limited. All rights reserved.
//

#import "DragTestView.h"
#import "SHAnimation.h"

@interface DragTestView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIView *dragView;
@property (nonatomic) BOOL tracking;
@property (nonatomic) CGPoint trackingLocationInDragView;
@end

@implementation DragTestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dragView = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        self.dragView.backgroundColor = [UIColor redColor];
        [self addSubview:self.dragView];
        
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
        self.panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:self.panGestureRecognizer];
        
        self.backgroundColor = [UIColor cyanColor];
    }
    return self;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    CGPoint p = [gestureRecognizer locationInView:self.dragView];
//    CGRect f = self.dragView.frame;
//    return CGRectContainsPoint(f, p);
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [self.panGestureRecognizer isEqual:gestureRecognizer] ) {
        CGPoint p = [gestureRecognizer locationInView:self.dragView];
        CGRect f = self.dragView.bounds;
        return CGRectContainsPoint(f, p);
    }
    return YES;
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if ( panGestureRecognizer.state == UIGestureRecognizerStateBegan ) {
        self.tracking = YES;
        self.trackingLocationInDragView = [panGestureRecognizer locationInView:self.dragView];
        [self.dragView.layer removeAnimationForKey:@"springAnimation"];
    }
    else if ( panGestureRecognizer.state == UIGestureRecognizerStateChanged ) {
        if ( self.tracking ) {
            CGPoint p = [panGestureRecognizer locationInView:self];
            CGRect f = self.dragView.frame;
            f.origin = CGPointMake(
                p.x - self.trackingLocationInDragView.x,
                p.y - self.trackingLocationInDragView.y
            );
            self.dragView.frame = f;
        }
    }
    else if ( panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled || panGestureRecognizer.state == UIGestureRecognizerStateFailed ) {
        self.tracking = NO;
        CGPoint v = [panGestureRecognizer velocityInView:self];
        CGPoint pFrom = self.dragView.layer.position;
        CGPoint pTo = CGPointMake(
            50.0f + (v.x > 0 ? self.bounds.size.width - 100 : 0),
            50.0f + 0.5f * (self.bounds.size.height - 100)
        );
        
        SHAnimationDampedSpring *dampedSpring = [SHAnimationDampedSpring unitSpringWithDampingRatio:1.0f];
        dampedSpring.frequencyHz = 3.0f;
        dampedSpring.dampingRatio = 0.7f;

        dampedSpring.fromValue = pFrom.x;
        dampedSpring.toValue = pTo.x;
        dampedSpring.velocity = v.x;
        dampedSpring.tolerance = 0.1f;
        CAAnimation *xAnimation = [dampedSpring animationWithKeyPath:@"position.x"];
        
        dampedSpring.fromValue = pFrom.y;
        dampedSpring.toValue = pTo.y;
        dampedSpring.velocity = v.y;
        dampedSpring.tolerance = 0.1f;
        CAAnimation *yAnimation = [dampedSpring animationWithKeyPath:@"position.y"];
        
//        self.dragView.frame = CGRectMake(0,0,100,100);

        NSArray *animations = @[xAnimation, yAnimation];
        CFTimeInterval maxDuration = [[animations valueForKeyPath:@"@max.duration"] floatValue];

        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = animations;
        animationGroup.delegate = self;
        animationGroup.duration = maxDuration;
//        [animationGroup setValue:kCNAnimateToTargetPositionAnimationName forKey:kCNAnimationNameKey];
        [self.dragView.layer addAnimation:animationGroup forKey:@"springAnimation"];
        
        self.dragView.layer.position = pTo;
    }
}

@end
