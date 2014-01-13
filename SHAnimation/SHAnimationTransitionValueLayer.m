//
//  TransitionValueLayer.m
//  ChineasyUI
//
//  Created by Simon on 06/12/2013.
//  Copyright (c) 2013 Chineasy Limited. All rights reserved.
//

#import "SHAnimationTransitionValueLayer.h"

@implementation SHAnimationTransitionValueLayer

@dynamic transitionValue;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    return [key isEqualToString:@"transitionValue"] || [super needsDisplayForKey:key];
}

//- (id)actionForKey:(NSString *) aKey
//{
//    if ([aKey isEqualToString:@"transitionValue"]) {
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:aKey];
//        animation.fromValue = [self.presentationLayer valueForKey:aKey];
//        return animation;
//    }
//    return [super actionForKey:aKey];
//}

//- (id)init
//{
//    if (self = [super init]) {
//        self.transitionValue = 0.0f;
//    }
//    return self;
//}

- (void)drawInContext:(CGContextRef)context
{
    NSLog(@"drawInContext transitionValue:%f delegate:%@",self.transitionValue,self.delegate);
    if ( nil != self.delegate ) {
        [self.delegate transitionValueLayer:self transitionValueChanged:self.transitionValue];
    }
    [super drawInContext:context];
}
@end
