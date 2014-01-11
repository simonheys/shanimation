//
//  TransitionValueLayer.h
//  ChineasyUI
//
//  Created by Simon on 06/12/2013.
//  Copyright (c) 2013 Chineasy Limited. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>

@protocol TransitionValueLayerDelegate;

@interface SHAnimationTransitionValueLayer : CALayer
@property (weak) id<TransitionValueLayerDelegate>delegate;
@property (nonatomic) CGFloat transitionValue;
@end

@protocol TransitionValueLayerDelegate <NSObject>
- (void)transitionValueLayer:(SHAnimationTransitionValueLayer *)transitionValueLayer transitionValueChanged:(CGFloat)transitionValue;
@end
