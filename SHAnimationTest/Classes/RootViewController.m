//
//  ViewController.m
//  ChineasyUI
//
//  Created by Simon Heys on 05/12/2013.
//  Copyright (c) 2013 Chineasy Limited. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"
#import "SHAnimation.h"
#import "DragTestView.h"
#import "SHAnimationDampedSpringView.h"

@interface RootViewController () <UIGestureRecognizerDelegate, TransitionValueLayerDelegate>
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *pinchPanGestureRecognizer;
@property (nonatomic, strong) UIRotationGestureRecognizer *pinchRotationGestureRecognizer;
@property (nonatomic) CGFloat transitionValue;
@property (nonatomic) CGFloat originalTransitionValue;
@property (nonatomic) BOOL isTrackingPinch;
@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) UIView *testView2;
@property (nonatomic, strong) UIView *testView3;
@property (nonatomic, strong) UIView *testView4;
@property (nonatomic, strong) UIView *zTestView;
@property (nonatomic, strong) SHAnimationUnitBezier *cardDistanceUnitBezier;
@property (nonatomic, strong) SHAnimationUnitBezier *cardZUnitBezier;
@property (nonatomic, strong) SHAnimationTransitionValueLayer *transitionValueLayer;
@property (nonatomic, strong) SHAnimationTransitionValueLayer *transitionValueLayerA;
@property (nonatomic, strong) SHAnimationTransitionValueLayer *transitionValueLayerB;
@property (nonatomic, strong) SHAnimationDampedSpringView *dampedSpringView;
@end

@implementation RootViewController

//
// tool for visually finding control points
// http://netcetera.org/camtf-playground.html
//

// controls 2d distance from original location to target location
- (SHAnimationUnitBezier *)cardDistanceUnitBezier
{
    if ( nil == _cardDistanceUnitBezier ) {
//        _cardDistanceUnitBezier = [UnitBezier unitBezierWithControlPoints:0.00 :0.40 :0.60 :1.00];
//        _cardDistanceUnitBezier = [UnitBezier unitBezierWithControlPoints:0.60 :1.40 :0.90 :1.10];
        _cardDistanceUnitBezier = [SHAnimationUnitBezier unitBezierWithControlPoints:0.50 :0.50 :0.50 :1.50];
    }
    return _cardDistanceUnitBezier;
}

// controls z from original location to target location
- (SHAnimationUnitBezier *)cardZUnitBezier
{
    if ( nil == _cardZUnitBezier ) {
        _cardZUnitBezier = [SHAnimationUnitBezier unitBezierWithControlPoints:0.30 :-0.30 :0.70 :1.30];
    }
    return _cardZUnitBezier;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
//    self.panGestureRecognizer.delegate = self;
//    [self.view addGestureRecognizer:self.panGestureRecognizer];

    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGestureRecognizer:)];
    self.pinchGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.pinchGestureRecognizer];
    
    self.pinchPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchPanGestureRecognizer:)];
    self.pinchPanGestureRecognizer.delegate = self;
	[self.pinchPanGestureRecognizer setMinimumNumberOfTouches:2];
	[self.pinchPanGestureRecognizer setMaximumNumberOfTouches:2];
    [self.view addGestureRecognizer:self.pinchPanGestureRecognizer];
    
    self.testView3 = [[UIView alloc] initWithFrame:CGRectMake(0,0,256,256)];
    self.testView3.backgroundColor = [UIColor blueColor];
    self.testView3.layer.transform = CATransform3DMakeTranslation(1024/2, 768/2, 0);
    self.testView3.layer.position = CGPointMake(-128,128);
    [self.view addSubview:self.testView3];
    
    
//    CALayer *layer = [self.testView3 layer];
//    [CATransaction begin];
//    [CATransaction setValue:[NSNumber numberWithFloat:1.0f] forKey:kCATransactionAnimationDuration];
//    CAAnimation *animation = [self.cardDistanceUnitBezier animationWithKeyPath:@"transform.translation.x" fromValue:[[layer valueForKeyPath:@"transform.translation.x"] floatValue] toValue:-160.0f];
//    [layer addAnimation:animation forKey:@"transform.translation.x"];
//    [layer setValue:@(-160.0f) forKeyPath:@"transform.translation.x"];
//    CAAnimation *animation2 = [self.cardZUnitBezier animationWithKeyPath:@"transform.translation.z" fromValue:[[layer valueForKeyPath:@"transform.translation.z"] floatValue] toValue:-250.0f];
//    [layer addAnimation:animation2 forKey:@"transform.translation.z"];
//    [layer setValue:@(-250.0f) forKeyPath:@"transform.translation.z"];
//    [CATransaction commit];

//RBBSpringAnimation *spring = [RBBSpringAnimation animationWithKeyPath:@"transform.translation.z"];
//
//spring.fromValue = @(0);
//spring.toValue = @(-250.0f);
//spring.velocity = 0;
//spring.mass = 1;
//spring.damping = 10;
//spring.stiffness = 100;
//
//spring.additive = YES;
//spring.duration = [spring durationForEpsilon:0.01];
//    
//CALayer *layer = [self.testView3 layer];
//[CATransaction begin];
//[layer addAnimation:spring forKey:@"transform.translation.z"];
//[layer setValue:@(-250.0f) forKeyPath:@"transform.translation.z"];
//[CATransaction commit];
//

//    SHAnimationSpring *spring = [SHAnimationSpring unitSpringWithBounce];
    SHAnimationDampedSpring *spring = [SHAnimationDampedSpring unitSpring];
    spring.toValue = 250.0f;
//    spring.restingValue = 250.0f;
    
    CALayer *layer = [self.testView3 layer];
    [CATransaction begin];
    CGFloat duration;
    CAAnimation *animation = [spring animationWithKeyPath:@"transform.translation.z"];
//    [CATransaction setValue:@(duration) forKey:kCATransactionAnimationDuration];
    [layer addAnimation:animation forKey:@"transform.translation.z"];
    [layer setValue:@(250.0f) forKeyPath:@"transform.translation.z"];
    [CATransaction commit];

    SHAnimationDampedSpring *springRotate = [SHAnimationDampedSpring unitSpringWithDampingRatio:0.2f];
    springRotate.toValue = M_PI;
    [CATransaction begin];
    animation = [springRotate animationWithKeyPath:@"transform.rotation.z"];
    duration = 5.0f;
//    [CATransaction setValue:@(duration) forKey:kCATransactionAnimationDuration];
    animation.duration = 5.0f;
    [layer addAnimation:animation forKey:@"rotation.z"];
    [layer setValue:@(springRotate.toValue) forKeyPath:@"transform.rotation.z"];
    [CATransaction commit];
    
//    [CATransaction begin];
//    CAAnimation *gravity = [SHAnimation gravityAnimationWithKeyPath:@"transform.translation.y" fromValue:768/2 velocity:-500.0f keyframeCount:3*60];
//    [CATransaction setValue:@(3.0f) forKey:kCATransactionAnimationDuration];
//    [layer addAnimation:gravity forKey:@"transform.translation.y"];
//    [CATransaction commit];
    
    [CATransaction begin];
    CAAnimation *gravity = [SHAnimation gravityAnimationWithKeyPath:@"transform.translation.y" fromValue:768/2 toValue:768+512/2 velocity:-kSHAnimationGravityAcceleration/2 duration:&duration];
    [CATransaction setValue:@(duration) forKey:kCATransactionAnimationDuration];
    [layer addAnimation:gravity forKey:@"transform.translation.y"];
    [layer setValue:@(768+512/2) forKeyPath:@"transform.translation.y"];
    [CATransaction commit];
    
    self.transitionValueLayer = [SHAnimationTransitionValueLayer layer];
    self.transitionValueLayer.frame = CGRectMake(0,0,100,100);
    self.transitionValueLayer.backgroundColor = [UIColor redColor].CGColor;
    self.transitionValueLayer.hidden = YES;
    self.transitionValueLayer.delegate = self;
    [self.view.layer addSublayer:self.transitionValueLayer];
    
//    [self.transitionValueLayer addObserver:self forKeyPath:@"transitionValue" options:NSKeyValueObservingOptionOld context:NULL];
    
    self.testView2 = [[UIView alloc] initWithFrame:CGRectMake(256+256+32,256,256,256)];
    self.testView2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.testView2];
    
//    self.testView = [[UIView alloc] initWithFrame:CGRectMake(256,256,256,256)];
//    self.testView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.testView];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500.0;
    self.view.layer.sublayerTransform = transform;
    
//    SHAnimationDampedSpring *dampedSpring = [SHAnimationDampedSpring unitSpringWithDampingRatio:0.7f];
//    dampedSpring.fromValue = 0.0f;
//    dampedSpring.toValue = 500.0f;
//    dampedSpring.frequencyHz = 0.35f;

    SHAnimationDampedSpring *dampedSpring = [SHAnimationDampedSpring unitSpringWithDampingRatio:1.0f];
    dampedSpring.fromValue = 0.0f;
    dampedSpring.toValue = 500.0f;
    dampedSpring.frequencyHz = 0.5f;
    dampedSpring.dampingRatio = 0.5f;

    CAKeyframeAnimation *a = [dampedSpring animationWithKeyPath:@"transform.translation.x"];
    // "paced" better for tracking interaction?
    a.calculationMode = @"paced";
    NSLog(@"a.duration:%f",a.duration);
//    a.duration = 3.0f;
//    a.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    
    self.testView4 = [[UIView alloc] initWithFrame:CGRectMake(0,150,200,200)];
    self.testView4.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.testView4];
    
    [CATransaction begin];
    [self.testView4.layer addAnimation:a forKey:@"dampedSpringAnimation"];
    [self.testView4.layer setValue:@(dampedSpring.toValue) forKeyPath:@"transform.translation.x"];
    [CATransaction commit];

    
    UIView *testViewA = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    testViewA.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:testViewA];
    [UIView animateWithDuration:a.duration*0.85f delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        testViewA.frame = CGRectMake(500,0,200,200);
    } completion:^(BOOL finished) {
        NSLog(@"testViewA done");
    }];
    
    CAAnimation *sa = [testViewA.layer animationForKey:@"position"];
//    NSLog(@"sa:%@",sa);
    CGFloat damping = [[sa valueForKey:@"damping"] floatValue];
    CGFloat stiffness = [[sa valueForKey:@"stiffness"] floatValue];
    CGFloat mass = [[sa valueForKey:@"mass"] floatValue];
    NSLog(@"damping:%f",damping);
    NSLog(@"stiffness:%f",stiffness);
    NSLog(@"mass:%f",mass);

//    RBBSpringAnimation *saa = [RBBSpringAnimation animationWithKeyPath:@"transform.translation.x"];
//    saa.mass = mass;
//    saa.damping = damping;
//    saa.stiffness = stiffness;
//    saa.fromValue = @(0.0f);
//    saa.toValue = @(500.0f);
//    saa.velocity = 0.0f;
//    saa.duration = 5.0f;
//    saa.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [CATransaction begin];
//    [testViewB.layer addAnimation:saa forKey:@"a"];
//    [testViewB.layer setValue:saa.toValue forKeyPath:@"transform.translation.x"];
//    [CATransaction commit];

    // next; compare z change to just scale change with an image
    
    self.testView4.layer.speed = 0.0f;
    self.testView4.layer.timeOffset = 0.0f;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0,0,384,44)];
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    self.dampedSpringView = [[SHAnimationDampedSpringView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,300)];
    self.dampedSpringView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.dampedSpringView];
    
    DragTestView *dragTestView = [[DragTestView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-200,self.view.bounds.size.width,200)];
    [self.view addSubview:dragTestView];
    
    self.zTestView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.zTestView.center = self.view.center;
    self.zTestView.backgroundColor = [UIColor magentaColor];
//    [self.zTestView.layer setValue:@(384) forKey:@"transform.translation.x"];
//    [self.zTestView.layer setValue:@(1024/2) forKey:@"transform.translation.y"];
    [self.view addSubview:self.zTestView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zTestViewTapped:)];
    [self.zTestView addGestureRecognizer:tapGestureRecognizer];
}

- (void)sliderChanged:(UISlider *)slider
{
//    NSLog(@"slider:%f",slider.value);
    CAKeyframeAnimation *dampedSpringAnimation = (CAKeyframeAnimation *)[self.testView4.layer animationForKey:@"dampedSpringAnimation"];
    self.testView4.layer.timeOffset = slider.value * dampedSpringAnimation.duration;
}

- (void)zTestViewTapped:(id)sender
{
    [self.zTestView.layer removeAnimationForKey:@"springAnimation"];
    self.zTestView.backgroundColor = [UIColor magentaColor];
    SHAnimationDampedSpring *spring = [SHAnimationDampedSpring unitSpringWithDampingRatio:0.7f];
    spring.frequencyHz = 2.0f;
    spring.fromValue = -10.0f;
    spring.toValue = 0.0f;
    spring.velocity = -1500.0f;
    spring.tolerance = 0.5f;
    CAKeyframeAnimation *springAnimation = [spring animationWithKeyPath:@"transform.translation.z" delay:0 timingFunctionName:kCAMediaTimingFunctionLinear];
    [springAnimation setValue:@"zTestViewSpringAnimation" forKey:@"animationName"];
    springAnimation.delegate = self;
    [self.zTestView.layer addAnimation:springAnimation forKey:@"springAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString *animationName = [anim valueForKey:@"animationName"];
    if ( [animationName isEqualToString:@"zTestViewSpringAnimation"]) {
        if ( flag ) {
            self.zTestView.backgroundColor = [UIColor redColor];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ____________________________________________________________________________________________________ pinch

#pragma mark - pinch

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePinchGestureRecognizer:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if ( [self.pinchGestureRecognizer isEqual:pinchGestureRecognizer] ) {
        if ( self.pinchGestureRecognizer.state == UIGestureRecognizerStateBegan ) {
            [self.transitionValueLayer removeAllAnimations];
            self.isTrackingPinch = YES;
            self.originalTransitionValue = self.transitionValue;
        }
        else if ( self.pinchGestureRecognizer.state == UIGestureRecognizerStateChanged ) {
            [self continueTrackingPinch];
        }
        else if ( self.pinchGestureRecognizer.state == UIGestureRecognizerStateEnded || self.pinchGestureRecognizer.state == UIGestureRecognizerStateCancelled ) {
            [self endTrackingPinch];
        }
    }
}

- (void)handlePinchPanGestureRecognizer:(UIPanGestureRecognizer *)pinchPanGestureRecognizer
{
    if ( [self.pinchPanGestureRecognizer isEqual:pinchPanGestureRecognizer] ) {
        [self updatePinchView];
    }
}

- (void)handlePinchRotationGestureRecognizer:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    if ( [self.pinchRotationGestureRecognizer isEqual:rotationGestureRecognizer] ) {
        [self updatePinchView];
    }
}

/*
- (void)beginTrackingPinchWithCellAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self modelAtIndexPath:indexPath];
    NSLog(@"model:%@",model);
    
    CardCollectionViewLayout *cardCollectionViewLayout = (CardCollectionViewLayout *)self.cardCollectionView.collectionViewLayout;
    cardCollectionViewLayout.hiddenIndexPath = indexPath;

    CGRect frame = [self frameForCellAtIndexPath:indexPath];
    
    self.pinchCardCollectionViewCell = [[CardCollectionViewCell alloc] initWithFrame:frame];
    self.pinchCardCollectionViewCell.model = model;
    self.pinchCardCollectionViewCell.frame = frame;
    
    [self.view addSubview:self.pinchCardCollectionViewCell];
    
    self.isTrackingPinch = YES;
    self.cardCollectionView.scrollEnabled = NO;
}
*/

- (void)continueTrackingPinch
{
    [self updatePinchView];
}

- (void)endTrackingPinch
{
    __weak typeof(self) blockSelf = self;
    self.isTrackingPinch = NO;
    
    SHAnimationSpring *spring = [SHAnimationSpring unitSpring];
    CGFloat velocity = self.pinchGestureRecognizer.velocity;
    NSLog(@"velocity:%f",velocity);
    CGFloat targetTransitionValue = self.transitionValue + (velocity/10.0f) > 0.5f ? 1.0f : 0.0f;
    spring.value = self.transitionValue;
    spring.restingValue = targetTransitionValue;
    spring.velocity = velocity / 60.0f;
    
    [self.transitionValueLayer removeAllAnimations];
    [CATransaction begin];
//    CGFloat duration;
    CAAnimation *animation = [spring animationWithKeyPath:@"transitionValue"];
//    [CATransaction setValue:@(duration) forKey:kCATransactionAnimationDuration];
    [self.transitionValueLayer addAnimation:animation forKey:@"transitionValue"];
    [self.transitionValueLayer setValue:@(targetTransitionValue) forKeyPath:@"transitionValue"];
    [CATransaction commit];
    
//    self.cardCollectionView.scrollEnabled = YES;
//    if ( self.pinchGestureRecognizer.scale >= kPinchMinimumScaleRequiredToArticle ) {
//        if ( [self.delegate respondsToSelector:@selector(cardViewController:didSelectCell:)] ) {
//            [self.delegate cardViewController:self didSelectCell:self.pinchCardCollectionViewCell];
//        }
//        [self.pinchCardCollectionViewCell removeFromSuperview];
//        self.pinchCardCollectionViewCell = nil;
//    }
//    else {
//        [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.0f options:0 animations:^{
//            blockSelf.pinchCardCollectionViewCell.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//            [blockSelf.pinchCardCollectionViewCell removeFromSuperview];
//            blockSelf.pinchCardCollectionViewCell = nil;
//            CardCollectionViewLayout *cardCollectionViewLayout = (CardCollectionViewLayout *)blockSelf.cardCollectionView.collectionViewLayout;
//            cardCollectionViewLayout.hiddenIndexPath = nil;
//        }];
//    }
}

- (void)updatePinchView
{
    if ( !self.isTrackingPinch ) {
        return;
    }
    CGFloat scale = self.pinchGestureRecognizer.scale;
    if ( self.originalTransitionValue < 0.5f ) {
        self.transitionValue = CGFloatMapTransition(scale, 1, 3, 0, 1);
    }
    else {
        self.transitionValue = 1.0f * scale;
    }
    
//    CGPoint translate = [self.pinchPanGestureRecognizer translationInView:self.view];
//    CGFloat rotation = self.pinchRotationGestureRecognizer.rotation;
//    CGAffineTransform t = CGAffineTransformMakeTranslation(translate.x, translate.y);
//    t = CGAffineTransformScale(t, scale, scale);
    
//    self.testView.transform = t;
    
//    t = CGAffineTransformRotate(t, rotation);
//    self.pinchCardCollectionViewCell.transform = t;
    NSLog(@"scale:%f",scale);
    
//    self.transitionValue = CGFloatMapTransition(scale, 1, 3, 0, 1);
}

- (void)setTransitionValue:(CGFloat)transitionValue
{
    NSLog(@"setTransitionValue:%f",transitionValue);
    double x, y, z, r;
    double m;
    CATransform3D t;
    transitionValue = MIN(1.2f,transitionValue);
    transitionValue = MAX(-1.0f,transitionValue);
    // TODO map < 0 and > 1 onto friction curves
    _transitionValue = transitionValue;
    m = [self.cardDistanceUnitBezier solve:transitionValue epsilon:1e-3];
    x = CGFloatMapTransition(m, 0, 1, 0, 64);
    m = [self.cardZUnitBezier solve:transitionValue epsilon:1e-3];
    z = CGFloatMapTransition(m, 0, 1, 0, 250);
    y = 0;
    if ( m < 0.5 ) {
        r = CGFloatMapTransition(m, 0, 0.5, 0, -M_PI/6);
    }
    else {
        r = CGFloatMapTransition(m, 0.5, 1, -M_PI/6, 0);
    }
    
//    CGAffineTransform t = CGAffineTransformMakeTranslation(a, 0);
//    self.testView2.transform = t;
    t = CATransform3DMakeTranslation(x, y, z);
    t = CATransform3DRotate(t, r, 0.3, 1, 0);
    self.testView2.layer.transform = t;
}

- (void)transitionValueLayer:(SHAnimationTransitionValueLayer *)transitionValueLayer transitionValueChanged:(CGFloat)transitionValue
{
    if ( [transitionValueLayer isEqual:self.transitionValueLayer] ) {
        self.transitionValue = transitionValue;
    }
}

@end
