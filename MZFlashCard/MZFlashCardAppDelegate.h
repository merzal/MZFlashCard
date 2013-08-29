//
//  MZFlashCardAppDelegate.h
//  MZFlashCard
//
//  Created by Mahmood1 on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class MZFlashCardViewController;

@interface MZFlashCardAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

//@property (nonatomic, retain) IBOutlet MZFlashCardViewController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
