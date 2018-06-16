//
//  ViewController.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 15..
//

#import "MZRootViewController.h"

@interface MZRootViewController ()

@end

@implementation MZRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)learnButtonPushed:(id)sender
{
    
}

- (IBAction)settingsButtonPushed:(id)sender
{
    
}

@end
