//
//  MZGoogleViewController.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 07. 07..
//

#import "MZGoogleViewController.h"


@import GoogleSignIn;

@interface MZGoogleViewController () <GIDSignInUIDelegate>

@end

@implementation MZGoogleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
    
    
    
    
}



@end
