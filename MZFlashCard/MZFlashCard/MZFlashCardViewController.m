//
//  MZFlashCardViewController.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 07. 05..
//

#import "MZFlashCardViewController.h"

#define PERCENT_OF_WEAKEST_CARDS_LIMIT 10.0f //the next card will be chosen from the x percent of the cards sorted by the goodness index; card with lower goodness index is at the beginning; maximum value of this value is 100.0

@interface MZFlashCardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *challengeLabel;
@property (weak, nonatomic) IBOutlet UILabel *solutionLabel;

@property (nonatomic, strong) MZFlashCardItem* currentFlashCardItem;
@property (nonatomic, assign, getter=isChallengeAbove) BOOL challengeAbove;

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
    
    self.challengeAbove = YES; //[[NSUserDefaults standardUserDefaults] boolForKey:@"isChallengeAbove"];
    
    self.currentFlashCardItem = [self getRandomFlashCardItem];
    
    self.challengeLabel.text = [self getCurrentFlashCardChallengeText];
    
    self.solutionLabel.text = @"...";
}

#pragma mark - Private methods

- (MZFlashCardItem*)getRandomFlashCardItem
{
    MZFlashCardItem* nextFlashCard;
    
    if (self.cardPack.flashCards.count == 1)
    {
        nextFlashCard = [self.cardPack.flashCards firstObject];
    }
    else if (self.cardPack.flashCards.count > 1)
    {
        // sort flashCardItems by goodnessIndex
        [self.cardPack.flashCards sortUsingComparator:^NSComparisonResult(MZFlashCardItem*  _Nonnull card1, MZFlashCardItem*  _Nonnull card2) {
            
            NSComparisonResult result = NSOrderedSame;
            
            if (card1.goodnessIndex < card2.goodnessIndex)
            {
                result = NSOrderedAscending;
            }
            else if (card1.goodnessIndex > card2.goodnessIndex)
            {
                result = NSOrderedDescending;
            }
            
            return result;
        }];
        
        NSLog(@"sorted flashCards: %@", self.cardPack.flashCards);
        
        unsigned int countOfCardsHaveChance = (unsigned int)ceilf((self.cardPack.flashCards.count * (PERCENT_OF_WEAKEST_CARDS_LIMIT / 100.0f)));
        
        if (countOfCardsHaveChance <= 1)
        {
            countOfCardsHaveChance = 2;
        }
        
        unsigned int randomIndex = arc4random_uniform(countOfCardsHaveChance);//arc4random() % countOfCardsHaveChance;
        
        nextFlashCard = self.cardPack.flashCards[randomIndex];
        
        while ([nextFlashCard isEqual:self.currentFlashCardItem])
        {
            randomIndex = arc4random_uniform(countOfCardsHaveChance);
            
            nextFlashCard = self.cardPack.flashCards[randomIndex];
        }
    }
    
    return nextFlashCard;
}

- (void)goToNextRun
{
    self.currentFlashCardItem = [self getRandomFlashCardItem];
    
    self.challengeLabel.text = [self getCurrentFlashCardChallengeText];
    
    self.solutionLabel.text = @"...";
}

- (NSString*)getCurrentFlashCardChallengeText
{
    return self.isChallengeAbove ? self.currentFlashCardItem.challenge : self.currentFlashCardItem.solution;
}

- (NSString*)getCurrentFlashCardSolutionText
{
    return self.isChallengeAbove ? self.currentFlashCardItem.solution : self.currentFlashCardItem.challenge;
}

#pragma mark - Actions

- (IBAction)okButtonTouched:(id)sender
{
    self.currentFlashCardItem.viewed++;
    self.currentFlashCardItem.solved++;
    
    [self goToNextRun];
}

- (IBAction)dontOkButtonTouched:(id)sender
{
    self.currentFlashCardItem.viewed++;
    
    [self goToNextRun];
}

- (IBAction)challengeLabelTouched:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)solutionLabelTouched:(id)sender
{
    self.solutionLabel.text = [self getCurrentFlashCardSolutionText];
}

@end
