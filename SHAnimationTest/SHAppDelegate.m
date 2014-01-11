//
//  SHAppDelegate.m
//  SHAnimation Example
//
//  Created by Simon Heys on 11/01/2014.
//  Copyright (c) 2014 Simon Heys Limited. All rights reserved.
//

#import "SHAppDelegate.h"
#import "RootViewController.h"

@implementation SHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [RootViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
