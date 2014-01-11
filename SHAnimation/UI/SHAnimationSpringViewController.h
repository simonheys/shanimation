//
//  SpringViewController.h
//
//  Created by Simon Heys on 11/07/2013.
//  Copyright (c) 2013 Simon Heys Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHAnimationSpringView;
@class SHAnimationSpring;

@interface SHAnimationSpringViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *massLabel;
@property (strong, nonatomic) IBOutlet UILabel *kLabel;
@property (strong, nonatomic) IBOutlet UILabel *cLabel;
@property (strong, nonatomic) IBOutlet UILabel *velocityLabel;
@property (strong, nonatomic) IBOutlet UISlider *massSlider;
@property (strong, nonatomic) IBOutlet UISlider *kSlider;
@property (strong, nonatomic) IBOutlet UISlider *cSlider;
@property (strong, nonatomic) IBOutlet UISlider *velocitySlider;
@property (strong, nonatomic) IBOutlet SHAnimationSpringView *springView;
@property (nonatomic, strong, readonly) SHAnimationSpring *spring;

@property (strong, nonatomic) IBOutlet UISlider *verticalScaleSlider;
@end
