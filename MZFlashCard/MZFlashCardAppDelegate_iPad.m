//
//  MZFlashCardAppDelegate_iPad.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 9/1/13.
//
//

#import "MZFlashCardAppDelegate_iPad.h"


@implementation MZFlashCardAppDelegate_iPad

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
