//
//  AppDelegate.h
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 15..
//

#import <UIKit/UIKit.h>

@import GoogleSignIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

