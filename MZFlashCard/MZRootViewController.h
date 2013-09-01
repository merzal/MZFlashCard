//
//  MZRootViewController.h
//  MZFlashCard
//
//  Created by Zalan Mergl on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface MZRootViewController : UIViewController 
{
    IBOutlet UIButton* goButton;
    IBOutlet UIButton* settingsButton;
}

- (IBAction)go;
- (IBAction)settingsButtonTouched;
@end
