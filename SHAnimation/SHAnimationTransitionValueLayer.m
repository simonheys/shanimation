//
//  TransitionValueLayer.m
//
//  Created by Simon on 06/12/2013.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import "SHAnimationTransitionValueLayer.h"

@interface SHAnimationTransitionValueLayer ()
@property (nonatomic) BOOL delegateHasTransitionValueChanged;
@end

@implementation SHAnimationTransitionValueLayer

@dynamic transitionValue;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    return [key isEqualToString:@"transitionValue"] || [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)context
{
    if ( [self.delegate respondsToSelector:@selector(transitionValueLayer:transitionValueChanged:)]) {
        [self.delegate transitionValueLayer:self transitionValueChanged:self.transitionValue];
    }
    [super drawInContext:context];
}
@end
