//
//  SHValueInterpolation.h
//  SHAnimationTest
//
//  Created by Simon Heys on 15/02/2014.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef id (^SHValueInterpolation)(CGFloat fraction);

extern SHValueInterpolation SHValueInterpolate(NSValue *from, NSValue *to);
