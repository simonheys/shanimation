//
//  CGFloatMap.h
//
//  Created by Simon Heys on 20/08/2013.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#ifndef CGFloatMap_h
#define CGFloatMap_h

static inline CGFloat CGFloatMapTransition(CGFloat input, CGFloat inputLow, CGFloat inputHigh, CGFloat outputLow, CGFloat outputHigh)
{
    CGFloat outputRange = outputHigh - outputLow;
    CGFloat inputRange = inputHigh - inputLow;
    CGFloat inputFraction = (input - inputLow) / inputRange;
    CGFloat output = outputLow + inputFraction * outputRange;
    return output;
}

static inline CGFloat CGFloatUnitMapTransition(CGFloat input, CGFloat outputLow, CGFloat outputHigh)
{
    return CGFloatMapTransition(input, 0.0f, 1.0f, outputLow, outputHigh);
}


#endif
