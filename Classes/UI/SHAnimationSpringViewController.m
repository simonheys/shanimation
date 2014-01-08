//
//  SpringViewController.m
//
//  Created by Simon Heys on 11/07/2013.
//  Copyright (c) 2013 Simon Heys Limited. All rights reserved.
//

#import "SHAnimationSpringViewController.h"
#import "SHAnimationSpringView.h"
#import "SHAnimationSpring.h"

@interface SHAnimationSpringViewController ()
@property (nonatomic, strong) SHAnimationSpring *spring;
@end

@implementation SHAnimationSpringViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"class:%@",[self.springView class]);
    if ( [self.springView isKindOfClass:[SHAnimationSpringView class]] ) {
        NSLog(@"yup");
    }
    else {
        CGRect f = self.springView.frame;
        [self.springView removeFromSuperview];
        self.springView = [[SHAnimationSpringView alloc] initWithFrame:f];
        [self.view addSubview:self.springView];
        self.springView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    self.spring = [SHAnimationSpring new];
    self.springView.spring = self.spring;
    self.springView.verticalScale = self.verticalScaleSlider.value;
    self.kSlider.value = 101.076;
    self.cSlider.value = 0.811;
    self.massSlider.value = 41.86;
    
    self.kSlider.value = 77.153107;
    self.cSlider.value = 0.734450;
    self.massSlider.value = 37.081341;
    
    // good but very slight too bouncy
    self.kSlider.value = 8.971292;
    self.cSlider.value = 0.547847;
    self.massSlider.value = 1.196172;
    
    // tighter, maybe a bit tense
    self.kSlider.value = 2.586207;
    self.cSlider.value = 0.487069;
    self.massSlider.value = 0.259595;

    // jus right?
    self.kSlider.value = 5.172414;
    self.cSlider.value = 0.551724;
    self.massSlider.value = 0.690586;

    [self update];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)massSliderChanged:(id)sender
{
    [self update];
}

- (IBAction)kSliderChanged:(id)sender
{
    [self update];
}

- (IBAction)cSliderChanged:(id)sender
{
    [self update];
}

- (IBAction)velocitySliderChanged:(id)sender
{
    [self update];
}

- (IBAction)verticalScaleSliderChanged:(id)sender
{
    self.springView.verticalScale = self.verticalScaleSlider.value;
}

- (void)update
{
    self.spring.velocity = self.velocitySlider.value;
    self.spring.mass = self.massSlider.value;
    self.spring.c = self.cSlider.value;
    self.spring.k = self.kSlider.value;
    
    self.velocityLabel.text = [NSString stringWithFormat:@"%f velocity",self.spring.velocity];
    self.massLabel.text = [NSString stringWithFormat:@"%f mass",self.spring.mass];
    self.cLabel.text = [NSString stringWithFormat:@"%f c",self.spring.c];
    self.kLabel.text = [NSString stringWithFormat:@"%f k",self.spring.k];
    
    [self.springView setNeedsDisplay];
}

@end
