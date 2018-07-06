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
//    [self setupFontSizeForLabel:challengeLabel];
}

- (MZFlashCardItem*)getRandomFlashCardItem
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
    
    NSInteger countOfCardsHaveChance = (NSInteger)floor(self.cardPack.flashCards.count * (PERCENT_OF_WEAKEST_CARDS_LIMIT / 100.0f));
    
    if (countOfCardsHaveChance <= 1)
    {
        countOfCardsHaveChance = 2;
    }
    
    NSInteger randomIndex = arc4random() % countOfCardsHaveChance;
    
    MZFlashCardItem* nextFlashCard = self.cardPack.flashCards[randomIndex];
    
    // if the count of flashcard items is too little
    NSInteger maxRoundCounter = 10;
    
    while ([nextFlashCard isEqual:self.currentFlashCardItem])
    {
        randomIndex = arc4random() % countOfCardsHaveChance;
        
        nextFlashCard = self.cardPack.flashCards[randomIndex];
        
        if (maxRoundCounter-- == 0) break;
    }
    
    return nextFlashCard;
}

- (NSString*)getCurrentFlashCardChallengeText
{
    return self.isChallengeAbove ? self.currentFlashCardItem.challenge : self.currentFlashCardItem.solution;
}

- (IBAction)okButtonTouched:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)dontOkButtonTouched:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)challengeLabelTouched:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)solutionLabelTouched:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
