//
//  MZRootViewController.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MZRootViewController.h"
#import "MZFlashCardPackChooser.h"
#import "MZSettingsViewController.h"


@implementation MZRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (IBAction)go
{    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] init];
	newBackButton.title = @"Back";
	self.navigationItem.backBarButtonItem = newBackButton;
	[newBackButton release];
    
    MZFlashCardPackChooser* packChooser = [[MZFlashCardPackChooser alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:packChooser animated:YES];
    [packChooser release];
}

- (IBAction)settingsButtonTouched
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] init];
	newBackButton.title = @"Back";
	self.navigationItem.backBarButtonItem = newBackButton;
	[newBackButton release];
    
    MZSettingsViewController* settingsVC = [[MZSettingsViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:settingsVC animated:YES];
    [settingsVC release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IS_PHONEPOD5)
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_background_image-568h.png"]]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_background_image.png"]]];
    }
    
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        [goButton setBackgroundImage:[[UIImage imageNamed:@"blueButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
        [settingsButton setBackgroundImage:[[UIImage imageNamed:@"blueButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
    }
    else
    {
        [goButton setBackgroundImage:[[UIImage imageNamed:@"blueButton"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [settingsButton setBackgroundImage:[[UIImage imageNamed:@"blueButton"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0] forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [super dealloc];
}

@end
