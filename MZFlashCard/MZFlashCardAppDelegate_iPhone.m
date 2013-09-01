//
//  MZFlashCardAppDelegate.m
//  MZFlashCard
//
//  Created by Mahmood1 on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MZFlashCardAppDelegate_iPhone.h"

@implementation MZFlashCardAppDelegate_iPhone

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
