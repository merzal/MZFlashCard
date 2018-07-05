//
//  MZFlashCardViewController.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 07. 05..
//

#import "MZFlashCardViewController.h"

@interface MZFlashCardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *challengeLabel;
@property (weak, nonatomic) IBOutlet UILabel *solutionLabel;

@end

@implementation MZFlashCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.title = self.cardPack.title;
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (IBAction)okButtonTouched:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)dontOkButtonTouched:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
